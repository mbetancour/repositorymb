# Usa la imagen base de Debian
FROM debian:latest

# Actualiza e instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev openssl libssl-dev iptables-persistent libmcrypt-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext

# Descargar y compilar Nagios Core
WORKDIR /tmp
RUN cd /tmp && \
    wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz && \
    tar xzf nagioscore.tar.gz && \
    cd /tmp/nagioscore-nagios-4.4.14/ && \
    ./configure --with-httpd-conf=/etc/apache2/sites-enabled && \
    make all && \
    make install-groups-users && \
    usermod -a -G nagios www-data && \
    make install && \
    make install-daemoninit && \
    make install-commandmode && \
    make install-config && \
    make install-webconf && \
    a2enmod rewrite && \
    a2enmod cgi && \
    htpasswd -bc /usr/local/nagios/etc/htpasswd.users rootmb Duoc.2024


# Descargar y compilar los plugins de Nagios
RUN cd /tmp && \
    wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz && \
    tar zxf nagios-plugins.tar.gz && \
    cd /tmp/nagios-plugins-release-2.4.6/ && \
    ./tools/setup && \
    ./configure && \
    make && \
    make install

#Iniciar apache
RUN echo "#!/bin/bash\nservice apache2 start\nservice nagios start\ntail -f /dev/null" > /usr/local/bin/start.sh && \
        chmod +x /usr/local/bin/start.sh

#Exponer el puerto para la interfaz
EXPOSE 80

#Demonio de nagios
CMD ["/usr/local/bin/start.sh"]
