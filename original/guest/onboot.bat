sc stop layle
sc delete layle
sc create layle binPath= "C:\Windows\System32\drivers\layle.sys" type= kernel
copy C:\vagrant\layle.sys C:\Windows\System32\drivers
sc start layle
