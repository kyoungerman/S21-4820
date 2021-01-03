
# A Python program to return multiple values from a method using tuple 
  
# This function returns a tuple 
def fun(): 
    str = "geeksforgeeks"
    x   = 20
    return str, x;  # Return tuple
  
str, x = fun() # Assign returned tuple 
print("str=->{}<- x={}".format(str, x )) 
