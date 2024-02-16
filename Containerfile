# Use Fedora 33 as base image
FROM registry.fedoraproject.org/fedora:39

# Install systemd mariadb nginx php-fpm
#RUN dnf install -y systemd mariadb-server nginx php-fpm && \
RUN dnf install -y systemd openssh-server && \
    dnf clean all

# Enable the services
#RUN systemctl enable mariadb.service && \
#    systemctl enable php-fpm.service && \
#    systemctl enable nginx.service
RUN systemctl enable sshd.service

#EXPOSE 80
EXPOSE 22

# Use systemd as command
CMD [ "/usr/sbin/init" ]
