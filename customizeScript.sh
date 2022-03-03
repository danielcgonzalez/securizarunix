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

# Arranque
FILE=/etc/grub.conf
if [ -f "$FILE" ]; then
    chown root:root $FILE
    chmod og-rwx $FILE
fi

# Autentificacion single user
FILE=/etc/sysconfig/init
if [ -f "$FILE" ]; then
    sed -i "/SINGLE/s/sushell/sulogin/" $FILE
fi


# Securizar los parámetros de red 
FILE=/etc/sysctl.conf
if [ -f "$FILE" ]; then
    /usr/bin/sed -i '/^'"net.ipv4.ip_forward"'/d' $FILE 
    echo "net.ipv4.ip_forward=0" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.send_redirects"'/d' $FILE 
    echo "net.ipv4.conf.all.send_redirects=0" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.send_redirects"'/d' $FILE 
    echo "net.ipv4.conf.default.send_redirects=0" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.accept_source_route"'/d' $FILE 
    echo "net.ipv4.conf.all.accept_source_route" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.accept_source_route"'/d' $FILE 
    echo "net.ipv4.conf.default.accept_source_route=0" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.accept_redirects"'/d' $FILE 
    echo "net.ipv4.conf.all.accept_redirects=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.accept_redirects"'/d' $FILE 
    echo "net.ipv4.conf.default.accept_redirects=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.secure_redirects"'/d' $FILE 
    echo "net.ipv4.conf.all.secure_redirects=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.secure_redirects"'/d' $FILE 
    echo "net.ipv4.conf.default.secure_redirects=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.log_martians"'/d' $FILE 
    echo "net.ipv4.conf.all.log_martians=1" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.log_martians"'/d' $FILE 
    echo "net.ipv4.conf.default.log_martians=1" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.route.flush"'/d' $FILE 
    echo "net.ipv4.route.flush=1" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.icmp_echo_ignore_broadcasts"'/d' $FILE 
    echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.icmp_ignore_bogus_error_responses"'/d' $FILE 
    echo "net.ipv4.icmp_ignore_bogus_error_responses=1" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.conf.all.rp_filter"'/d' $FILE 
    echo "net.ipv4.conf.all.rp_filter=1" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv4.conf.default.rp_filter"'/d' $FILE 
    echo "net.ipv4.conf.default.rp_filter=1" >> $FILE 

    /usr/bin/sed -i '/^'"net.ipv4.tcp_syncookies"'/d' $FILE 
    echo "net.ipv4.tcp_syncookies=1" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv6.conf.all.accept_ra"'/d' $FILE 
    echo "net.ipv6.conf.all.accept_ra=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv6.conf.default.accept_ra"'/d' $FILE 
    echo "net.ipv6.conf.default.accept_ra=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv6.conf.all.accept_redirects"'/d' $FILE 
    echo "net.ipv6.conf.all.accept_redirects=0" >> $FILE

    /usr/bin/sed -i '/^'"net.ipv6.conf.default.accept_redirects"'/d' $FILE 
    echo "net.ipv6.conf.default.accept_redirects=0" >> $FILE

fi

# desactivar ipv6
echo "options ipv6 disable=1" > /etc/modprobe.d/ipv6.conf



# quitar telnet
apt remove telnet -y

# activar audit
apt-get update -y
apt-get install -y auditd

systemctl enable auditd
systemctl start auditd

# Desactivar Core Dump
echo "hard core 0" >> /etc/security/limits.conf 


# Verificar y corregir permisos
/bin/chmod 644 /etc/passwd
/bin/chmod 000 /etc/shadow
/bin/chmod 000 /etc/gshadow
/bin/chmod 644 /etc/group
/bin/chown root:root /etc/passwd
/bin/chown root:root /etc/shadow
/bin/chown root:root /etc/gshadow
/bin/chown root:root /etc/group


# activar historico contraseñas
FILE=/etc/pam.d/common-password
if [ -f "$FILE" ]; then
    sed -i '/obscure sha512/s/$/ remember=10 minlen=8/' $FILE
fi
