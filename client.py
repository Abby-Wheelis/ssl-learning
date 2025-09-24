# copied from https://docs.python.org/3/library/http.client.html
import socket
import ssl
import pprint

def main():

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.load_verify_locations("./cert.pem")

    conn = context.wrap_socket(socket.socket(socket.AF_INET),
                               server_hostname="localhost")
    conn.connect(("localhost", 10023))
    cert = conn.getpeercert()
    pprint.pprint(cert)
    conn.sendall(b'hello')
    conn.close()

if __name__ == '__main__':
    main()

