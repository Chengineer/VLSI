
#!/usr/bin/python
import sys

#str = "12+5*77-30*2+4-9"
#str = input("Please insert your math expression\n")
#print(eval(str))

# get user input from terminal
str = sys.argv[1]
# split expression on *
new = str.split("*")
print(new)
for i in range (1,(len(new)+1),2):
    new.insert(i,'*')
print(new)
# split the sub-expressions on +
plus = []
for j in new:
    plus.append(j.split("+"))
print(plus)
for k in plus:
    for l in range (1,(len(k)),2):
        k.insert(l,'+')
print(plus)
# split the sub-expressions on -
minus = []
for s in plus:
    for x in s:
        minus.append(x.split("-"))
print(minus)
for t in minus:
    for q in range (1,(len(t)),2):
        t.insert(q,'-')
print(minus)
# flatten the last list to be list of strings
flat_list = []
for sublist in minus:
    for item in sublist:
        flat_list.append(item)
print(flat_list)
# calculate the multiplications
for element in flat_list:
    if element == "*":
        indx = flat_list.index(element)
        mult = int(flat_list[indx-1]) * int(flat_list[indx+1])
        flat_list = flat_list[:indx-1] + flat_list[indx+2 :]
        flat_list.insert(indx-1, mult)
        print(flat_list)
# calculate the subtractions and additions    
for lmnt in flat_list:
    if lmnt == "+":
        indx = flat_list.index(lmnt)
        add = int(flat_list[indx-1]) + int(flat_list[indx+1])
        flat_list = flat_list[:indx-1] + flat_list[indx+2 :]
        flat_list.insert(indx-1, add)
        print(flat_list)
    elif lmnt == "-":
        indx = flat_list.index(lmnt)
        sub = int(flat_list[indx-1]) - int(flat_list[indx+1])
        flat_list = flat_list[:indx-1] + flat_list[indx+2 :]
        flat_list.insert(indx-1, sub)
        print(flat_list)
        
#print(*flat_list)
print(flat_list[0])

