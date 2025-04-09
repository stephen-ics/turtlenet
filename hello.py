# main.py 
import socket

class TCPServer:
    host = '127.0.0.1' # address for our server
    port = 8888 # port for our server

    def start(self):
        # create a socket object
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        # bind the socket object to the address and port
        s.bind((self.host, self.port))
        # start listening for connections
        s.listen(5)

        print("Listening at", s.getsockname())

        while True:
            # accept any new connection
            conn, addr = s.accept()

            print("Connected by", addr)

            # read the data sent by the client
            # for the sake of this tutorial, 
            # we'll only read the first 1024 bytes
            data = conn.recv(1024)

            # send back the data to client
            conn.sendall(data)

            # close the connection
            conn.close()

if __name__ == '__main__':
    server = TCPServer()
    server.start()