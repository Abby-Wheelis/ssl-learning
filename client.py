# copied from https://docs.python.org/3/library/http.client.html
import socket
import ssl
import http.client

hostname = 'www.python.org'
context = ssl.create_default_context()
conn = http.client.HTTPSConnection(hostname)
conn.request("GET", "/", headers={"Host": hostname})
response = conn.getresponse()
print(response.status, response.reason)

# with socket.create_connection((hostname, 443)) as sock:
#     with context.wrap_socket(sock, server_hostname=hostname) as ssock:
#         print(ssock.version())
