#!/usr/bin/python
import sys

#module_name = input("Please insert module name\n")
#module_input = input("Please insert module input\n")
#module_output = input("Please insert module output\n")
#module_param_name = input("Please insert module parameter name\n")
#module_param_value = input("Please insert module parameter value\n")

module_name = sys.argv[1]
module_input = sys.argv[2]
module_output = sys.argv[3]
module_param_name = sys.argv[4]
module_param_value = sys.argv[5]

f = open(module_name+'.v','w')
f.write("module " + module_name + "\n")
f.write("\t" + "#(parameter " + module_param_name + " = " + module_param_value + ")\n")
f.write("\t(\n")
f.write("\tinput [" + module_param_name + "-1:0]\t" + module_input + ",\n") 
f.write("\toutput [" + module_param_name + "-1:0]\t" + module_output + "\n") 
f.write("\t);\n")
f.write("\n\nendmodule")
f.close()
f = open(module_name+'.v','r')
print(f.read())