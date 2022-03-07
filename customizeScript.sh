#!/bin/bash -e

# Desactivar las cuentas de sistema bloqueadas
for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do 
    if [ $user != ""root"" ] 
    then 
        /usr/sbin/usermod -L $user 
        if [ $user != ""sync"" ] && [ $user != ""shutdown"" ] && [ $user != ""halt"" ] 
        then 
            /usr/sbin/usermod -s /sbin/nologin $user 
        fi 
    fi
done

# Establecer el grupo por defecto para la cuenta root:
usermod -g 0 root

# Establecer permisos
echo "umask 077" >>  /etc/bashrc
echo "umask 077" | tee -a /etc/profile.d/*

# Bloquear las cuentas de los usuarios inactivos mediante la ejecución de la siguiente instrucción:
useradd -D -f 35

# parámetros de configuración de las contraseñas
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 45/g' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/g' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/g' /etc/login.defs

for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do 
 if [ $user != ""root"" ] && [ $user != ""sync"" ] && [ $user != ""shutdown"" ] && [ $user != ""halt"" ] 
 then 
 chage --maxdays 45 $user
 chage --mindays 1 $user
 chage --warndays 7 $user
 fi
done


# Definir permisos
FILE=/etc/anacrontab
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/crontab
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/cron.hourly
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/cron.daily
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/cron.weekly
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/cron.monthly
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/cron.d
if [ -f "$FILE" ]; then
chown root:root $FILE 
chmod og-rwx $FILE
fi
FILE=/etc/at.deny 
if [ -f "$FILE" ]; then
rm -f $FILE 
fi
FILE=/etc/cron.deny 
if [ -f "$FILE" ]; then
rm -f $FILE 
fi

touch /etc/at.allow 
chown root:root /etc/at.allow 
chmod og-rwx /etc/at.allow
chown root:root /etc/at.allow

FILE=/etc/cron.allow 
if [ -f "$FILE" ]; then
chmod og-rwx $FILE 
chown root:root $FILE 
chmod og-rwx $FILE 
fi



# Configurar sshd_config
FILE=/etc/ssh/sshd_config
if [ -f "$FILE" ]; then
    /usr/bin/sed -i '/^'"Protocol"'/d' $FILE 
    echo "Protocol 2" >> $FILE 

    /usr/bin/sed -i '/^'"LogLevel"'/d' $FILE 
    echo "LogLevel INFO" >> $FILE 

    /usr/bin/sed -i '/^'"X11Forwarding"'/d' $FILE 
    echo "X11Forwarding yes" >> $FILE 

    /usr/bin/sed -i '/^'"MaxAuthTries"'/d' $FILE 
    echo "MaxAuthTries 4" >> $FILE 

    /usr/bin/sed -i '/^'"IgnoreRhosts"'/d' $FILE 
    echo "IgnoreRhosts yes" >> $FILE 

    /usr/bin/sed -i '/^'"HostbasedAuthentication"'/d' $FILE 
    echo "HostbasedAuthentication no" >> $FILE 

    /usr/bin/sed -i '/^'"PermitRootLogin"'/d' $FILE 
    echo "PermitRootLogin no" >> $FILE 

    /usr/bin/sed -i '/^'"PermitEmptyPasswords"'/d' $FILE 
    echo "PermitEmptyPasswords no" >> $FILE 

    /usr/bin/sed -i '/^'"PasswordAuthentication"'/d' $FILE 
    echo "PasswordAuthentication yes" >> $FILE 

    /usr/bin/sed -i '/^'"PermitUserEnvironment"'/d' $FILE 
    echo "PermitUserEnvironment yes" >> $FILE 

    /usr/bin/sed -i '/^'"Ciphers"'/d' $FILE 
    echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> $FILE 

    /usr/bin/sed -i '/^'"ClientAliveInterval"'/d' $FILE 
    echo "ClientAliveInterval 300" >> $FILE 

    /usr/bin/sed -i '/^'"ClientAliveCountMax"'/d' $FILE 
    echo "ClientAliveCountMax 0" >> $FILE 

    /usr/bin/sed -i '/^'"Banner"'/d' $FILE 
    echo "Banner /etc/issue.net" >> $FILE 

    chown root:root $FILE 
    chmod 600 $FILE 
fi

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
