#!/usr/bin/python2

f = open('/boot/cmdline.txt', 'r')
parameters = f.read().split(" ")
f.close()

new_parameters = ""
for item in parameters:
  if item.find("console") == -1:
    new_parameters = new_parameters + " " + item

f = open('/boot/cmdline.txt', 'w')
f.write(new_parameters)

