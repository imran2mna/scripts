#!/bin/env python
import socket
from socket import * 
import sys
from thread import *

HOST = ''
PORT = 8000

connections = []

# functions defined here
def client_thread(client_socket):
   connections.append(client_socket)
   data = client_socket.recv(1024)
   reply = data
#  reply = "Hinguloya Web Server" 
   client_socket.send(reply)
   client_socket.close()

# main program below 
server_socket = socket(AF_INET, SOCK_STREAM)
try:
   server_socket.bind((HOST, PORT))
except socket.error as msg:
   print 'Bind failed. Error Code : ' + str(msg[0]) + ', Message : ' + str(msg[1]) 
   sys.exit()

server_socket.listen(10)
print 'Socket listening on ' + str(PORT)

while True:
   client_socket, addr = server_socket.accept()
   print 'Connected with ' + str(addr[0]) + ':' + str(addr[1])
   start_new_thread(client_thread, (client_socket,))
server_socket.close() 
