.sub hola 
 .param string a
 .param int fy
 .param int b
 .local int d
 return(3)
.end

.sub main :main
 .local string h
 .local int y
 .local int j
 .local int a
 .local int  claudio
 claudio = 2
 y = 3
#a = hola ( h, y, j )+claudio
a =  y+claudio
print a
.end
