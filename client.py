# copied from https://docs.python.org/3/library/http.client.html
import socket
import ssl
import pprint


def main():

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.load_verify_locations(cafile="./root.pem")
    context.load_verify_locations(cafile="./intca.pem")

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock:
        with context.wrap_socket(sock, server_hostname="localhost") as ssock:
            print(ssock.version())
            ssock.connect(("localhost", 10023))
            cert = ssock.getpeercert()
            pprint.pprint(cert)
            ssock.sendall(b"hello")
            ssock.close()


if __name__ == "__main__":
    main()
