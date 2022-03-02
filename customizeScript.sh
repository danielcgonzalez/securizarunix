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
sed -i 's/^PASS_MIN_DAYS.*/PASS_WARN_AGE 7/g' /etc/login.defs

for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do 
 if [ $user != ""root"" ] && [ $user != ""sync"" ] && [ $user != ""shutdown"" ] && [ $user != ""halt"" ] 
 then 
 chage --maxdays 45 $user
 chage --mindays 1 $user
 chage --warndays 7 $user
 fi
done


# Definir permisos
chown root:root /etc/anacrontab 
chmod og-rwx /etc/anacrontab
chown root:root /etc/crontab 
chmod og-rwx /etc/crontab
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
chown root:root /etc/cron.daily 
chmod og-rwx /etc/cron.daily
chown root:root /etc/cron.weekly 
chmod og-rwx /etc/cron.weekly
chown root:root /etc/cron.monthly 
chmod og-rwx /etc/cron.monthly
chown root:root /etc/cron.d 
chmod og-rwx /etc/cron.d
rm -f /etc/at.deny 
rm -f /etc/cron.deny 
touch /etc/at.allow 
chown root:root /etc/at.allow 
chmod og-rwx /etc/at.allow
chmod og-rwx /etc/cron.allow 
chmod og-rwx /etc/at.allow 
chown root:root /etc/cron.allow 
chown root:root /etc/at.allow

# Configurar sshd_config
/usr/bin/sed -i '/^'"Protocol"'/d' /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"LogLevel"'/d' /etc/ssh/sshd_config
echo "LogLevel INFO" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"X11Forwarding"'/d' /etc/ssh/sshd_config
echo "X11Forwarding yes" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"MaxAuthTries"'/d' /etc/ssh/sshd_config
echo "MaxAuthTries 4" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"IgnoreRhosts"'/d' /etc/ssh/sshd_config
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"HostbasedAuthentication"'/d' /etc/ssh/sshd_config
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"PermitRootLogin"'/d' /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"PermitEmptyPasswords"'/d' /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
 no
/usr/bin/sed -i '/^'"PasswordAuthentication"'/d' /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"PermitUserEnvironment"'/d' /etc/ssh/sshd_config
echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"Ciphers"'/d' /etc/ssh/sshd_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"ClientAliveInterval"'/d' /etc/ssh/sshd_config
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"ClientAliveCountMax"'/d' /etc/ssh/sshd_config
echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config

/usr/bin/sed -i '/^'"Banner"'/d' /etc/ssh/sshd_config
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

