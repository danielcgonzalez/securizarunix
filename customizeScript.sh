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





 

