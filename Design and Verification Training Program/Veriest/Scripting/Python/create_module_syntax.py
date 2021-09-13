#!/usr/bin/python
import sys
import re

file_name = sys.argv[1]
module_name = sys.argv[2]
module_param_name = sys.argv[3]
module_param_value = sys.argv[4]
signals = open(file_name,'r')
lines = signals.read()
#print(lines)

# Works perfectly, but bad practice:
#context = {}
#d = exec(lines, context)

#
# Convert dictionary given as string to dictionary type:
#
# Remove "d =" from the string read from the text file:
string_dict = lines.split("=")
#print(string_dict)
string_dict = string_dict[1]
#print(string_dict)
# Remove " ", "'" and the outer "{" "}" from the string:
string_dict = string_dict.replace(" ","")
string_dict = string_dict.replace("'","")
string_dict = string_dict[1:-1]
#print(string_dict)

# Split string_dict at "{":
lbraces = string_dict.split("{")
#print(lbraces)
# Insert ":{" into lbraces where it's supposed to be at:
for i in range (1,(len(lbraces)+len(lbraces)-1),2):
    lbraces.insert(i,"{")
#print(lbraces)

# Split lbraces items at "}":
rbraces = []
for j in lbraces:
    rbraces.append(j.split("}"))
#print(rbraces)
# Insert ":{" into rbraces where it's supposed to be at:
for k in rbraces:
    for l in range (1,(len(k)),2):
        k.insert(l,'}')
#print(rbraces)

# Split items of rbraces at "," and ":":
comma_colon = []
for a in rbraces:
    for b in a:
        comma_colon.append(re.split(',|:',b))

# Flatten comma_colon list (all nested items become non-nested items in flat_list):
flat_list = []
for sublist in comma_colon:
    for item in sublist:
        flat_list.append(item)
#print(flat_list)

# Remove blank items from flat_list
while '' in flat_list:
    flat_list.remove('')
#print(flat_list)

d = {}
for index in range (0,len(flat_list)):
    if flat_list[index] == '{':
        my_dict = {}
        i = 1
        #print(index)
        while flat_list[index+i] != '}':
            my_dict[flat_list[index+i]] = flat_list[index+i+1]
            i = i + 2
        d[flat_list[index-1]] = my_dict
#print(d)

#d = {'input': {'1': 'haddr', '2': 'hwrite', '3': 'hsize' , '4': 'hsel', '5': 'hburst', '6': 'hprot', '7': 'htrans', '8': 'hmastlock', '8': 'hready', '9': 'hmastlock', '10': 'hwdata', '11' : 'hresetn', '12': 'hclk', '13': 'Null', '14': 'sys_clk', '15': 'sys_reset', '16': 'sys_err'},'output': {'1': 'hrdata', '2': 'hresp','3': 'hreadyout'},'inout': {'1': 'datap', '2': 'datan','3': 'clkp', '4': 'clkn'}}

# Remove dict items with "Null" values:
delete_list = []
for k in d.keys():
    for i_k in d[k].keys():
        if d[k][i_k] == "Null":
            delete_list.append([k,i_k])
for [x,y] in delete_list:
    del d[x][y] 

#
# Create sv module template:
#
f = open(module_name+'.sv','w')
f.write("module " + module_name + "\n")
f.write("\t" + "#(parameter " + module_param_name + " = " + module_param_value + ")\n")
f.write("\t(\n")

for key in d:
    for inner_key in d[key]:
        if ((key == d.keys()[-1]) & (inner_key == d[key].keys()[-1])): # if the current item is the very last item in the nested dicts
            f.write("\t" + key + "\t" + d[key][inner_key] + "\n") 
        else:
            f.write("\t" + key + "\t" + d[key][inner_key] + ",\n")

f.write("\t);\n")
f.write("\n\nendmodule")
f.close()
f = open(module_name+'.sv','r')
print(f.read())
