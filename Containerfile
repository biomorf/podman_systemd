# Use Fedora 33 as base image
FROM registry.fedoraproject.org/fedora:39 AS systemd

# Install systemd mariadb nginx php-fpm
#RUN dnf install -y systemd mariadb-server nginx php-fpm && \
RUN dnf install -y systemd openssh-server sudo && \
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



FROM systemd AS vagrant

ARG USER=vagrant

# Create the vagrant user
RUN useradd --create-home -s /bin/bash $USER \
  && echo -n "$USER:$USER" | chpasswd

### add user 'vagrant' to group 'sudo'
RUN groupadd --system sudo
RUN usermod --append --groups sudo $USER
RUN mkdir -p /etc/sudoers.d \
  && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER

# Establish ssh keys for vagrant
RUN mkdir -p /home/$USER/.ssh \
  && chmod 700 /home/$USER/.ssh
###  This default 'insecure' key will be automatically replaced later when you initialize your virtual environment
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > /home/$USER/.ssh/authorized_keys
#ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/$USER/.ssh/authorized_keys; \
    chown -R $USER:$USER /home/$USER/.ssh


