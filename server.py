# copied from https://docs.python.org/3/library/ssl.html
import socket
import ssl

def do_something(data):
    if len(data) == 0: return False
    print(data)
    return True

def deal_with_client(connstream):
    data = connstream.recv(1024)
    # empty data means the client is finished with us
    while data:
        if not do_something(data):
            # we'll assume do_something returns False
            # when we're finished with client
            break
        data = connstream.recv(1024)

def main():

    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.load_cert_chain('./cert.pem', './key.pem')

    bindsocket = socket.socket()
    bindsocket.bind(('localhost', 10023))
    bindsocket.listen(5)

    while True:
        newsocket, fromaddr = bindsocket.accept()
        connstream = context.wrap_socket(newsocket, server_side=True)
        try:
            deal_with_client(connstream)
        except socket.error as e:
            connstream.close()
        finally:
            connstream.close()

if __name__ == '__main__':
    main()
