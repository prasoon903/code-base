import time
from SimulateTyping import SimulateTyping

#################  Please Set File Path ######################

FileCompletePath = 'E:\\Python\\AutoType\\myfile.txt'

#################  Please Set File Path ######################

file1 = open(FileCompletePath, 'r')
Lines = file1.readlines()
file1.close()

print("CountDown Starts")
time.sleep(7)

SimulateTyping(Lines)

# Lines = '\n \nDone Typing!! \nPlease Review!!'
# SimulateTyping(Lines)

print (Lines)
