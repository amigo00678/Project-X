import requests
import regex
from io import BytesIO
from http.server import BaseHTTPRequestHandler, HTTPServer


PORT_NUMBER = 8080
HOST_NAME = 'localhost'


class RequestHandler(BaseHTTPRequestHandler):


    def update_response(self, body):
        #replace 6 charcters words with sign at end
        for m in reversed(list(regex.finditer(r'\b[\p{Cyrillic}a-zA-Z]{6}\b', body, overlapped=True))):
            match = m.group(0)
            start = m.start(0)
            end = m.end(0)

            closing_tag = regex.search(r'</\b(?!script)\b\w+', body[end:])
            script_close = body[end:].find('</script>')
            outside_script = script_close == -1 or closing_tag and closing_tag.start(0) < script_close

            closing_tag = regex.search(r'</\b(?!style)\b\w+', body[end:])
            style_close = body[end:].find('</style>')
            outside_style = style_close == -1 or closing_tag and closing_tag.start(0) < style_close

            if outside_script and outside_style:
                # check if we are inside of some tag, not to break html
                tag_open = body[end:].find('<')
                tag_end = body[end:].find('>')
                outside_tag = tag_end == -1 or tag_open < tag_end

                if outside_tag:
                    body = body[:start] + body[start:end].replace(match, match+'&trade;') + body[end:]

        #replace links with proxy URL
        body = regex.sub("(<a [^>]*href\s*=\s*['\"])(https?://habrahabr\.ru)/", "\\1http://%s:%s/" % (HOST_NAME, PORT_NUMBER), body)
        return body


    def get_content(self, path):
        reply = requests.get('http://habrahabr.ru' + path)
        response = reply.text
        response = self.update_response(response)
        return response.encode("utf-8")


    def do_GET(self):
        self.send_response(200)
        if self.headers.get('Accept', None) and 'text/html' in self.headers['Accept']:
            reply = self.get_content(self.path)
            self.send_header('Content-type','text/html')
            self.end_headers()
            self.wfile.write(reply)
        else:
            reply = requests.get('http://habrahabr.ru' + self.path)
            self.send_header('Content-Type', reply.headers['Content-Type'])
            if 'Content-Length' in reply.headers:
                self.send_header('Content-Length', reply.headers['Content-Length'])
            if 'Accept-Ranges' in reply.headers:
                self.send_header('Accept-Ranges', reply.headers['Accept-Ranges'])
            self.end_headers()
            bio = BytesIO(reply.content)
            self.wfile.write(bio.read())
        return


def main():
    try:
        server = HTTPServer(('', PORT_NUMBER), RequestHandler)
        print ('Started httpserver on port ' , PORT_NUMBER)
        
        server.serve_forever()

    except KeyboardInterrupt:
        print ('^C received, shutting down the web server')
        server.socket.close()


if __name__ == '__main__':
    main()

