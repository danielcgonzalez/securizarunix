#!/bin/bash -e



# Bastionado
FILE=/etc/modprobe.d/bastionado.conf 
    echo "install cramfs /bin/true" > $FILE 
    echo "install freevxfs /bin/true" >> $FILE 
    echo "install jffs2 /bin/true" >> $FILE 
    echo "install hfs /bin/true" >> $FILE 
    echo "install hfsplus /bin/true" >> $FILE 
    echo "install squashfs /bin/true" >> $FILE 
    echo "install udf /bin/true" >> $FILE 

    echo "install dccp /bin/true" >> $FILE
    echo "install sctp /bin/true" >> $FILE
    echo "install rds /bin/true" >> $FILE
    echo "install tipc /bin/true" >> $FILE
