#!/usr/bin/python
import sys

file_name = sys.argv[1]
search_file = open(file_name,'r')
lines = search_file.readlines()
num_lines = sum(1 for line in lines)
#print("number of lines in this file:\n" + str(num_lines))

for i in range (num_lines-1,0,-1):
    #print("line:\n" + str(i))
    #print("line " + str(i) + " content:\n" + str(lines[i]))
    if "," in lines[i]:
        index = lines[i].rindex(",")
        #print("index of the last comma in the line:\n" + str(index))
        #print("verify that there is a comma at this index:\n" + str(lines[i][index]))
        lines[i] = lines[i][:index] + lines[i][index+1:]
        #print("that line after last-comma-deletion:\n " + str(lines[i]))
        break
search_file = open(file_name,'w')
search_file.writelines(lines)
search_file.close()
