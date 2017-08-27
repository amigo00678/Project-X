import socket
import thread
import sys
import time

sock = 0

def operate(main_port, main_ip):
    global sock
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((main_ip, main_port))
    thread.start_new_thread(reader, (sock,))
    writer(sock)
    sock.shutdown(socket.SHUT_RDWR)

def reader(sock):
    ch = sock.recv(1)
    while ch:
        sys.stdout.write(ch)
        sys.stdout.flush()
        ch = sock.recv(1)

def writer(sock):
    ch = sys.stdin.read(1)
    while ch:
        sock.send(ch)
        ch = sys.stdin.read(1)

def main():
    if len(sys.argv) < 3:
        print("Usage: ip port")
    else:
        main_ip = sys.argv[1]
        main_port = int(sys.argv[2])
        operate(main_port, main_ip)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sock.shutdown(socket.SHUT_RDWR)
