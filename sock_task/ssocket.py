import socket
import thread
import threading
import sys

sockets = []
lock = threading.Lock()

def operate(main_port):

    listen_s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    listen_s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    listen_s.bind((HOST, main_port))
    listen_s.listen(1)
    
    while True:
        s, addr = listen_s.accept()
    
        with lock:
            sockets.append(s)
        
        print('Socket on port %d connected by %s' % (main_port, addr))
        thread.start_new_thread(reader, (s,))
    
    listen_s.close()

def reader(s):
    
    ch = s.recv(1)
    while ch:
        sys.stdout.write(ch)
        sys.stdout.flush()
        
        with lock:
            for ws in sockets:
                if ws != s:
                    ws.send(ch)

        ch = s.recv(1)
        
    with lock:
        sockets.remove(s)
        
    s.close()

HOST = ''
if len(sys.argv) < 2:
    print("Usage: port")
else:
    main_port = int(sys.argv[1])
    operate(main_port)
