FROM centos:7

RUN yum install -y epel-release
RUN yum install -y ansible \
    python3 \
    java-1.8.0-openjdk \
    git \
    openssh-server && \
    useradd jenkins

RUN yum install -y yum-utils && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    usermod -aG docker jenkins && \
    ssh-keygen -A

USER jenkins

RUN mkdir /home/jenkins/.ssh && \
    chmod 0700 /home/jenkins/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLDQ/BJo7QNlavXm/mlvFTIl/tfxMvwI/3kxG08DgbUoRay0RNmtot/R2ULdlwbvUuXBfYkgwmFYHwmYRUZ0E9ILejjETKkn63OiTKtugVFKGyvEm0U2o7nR9Txolh1ig5uexdoJcqymBDqcDNs9t/rbzSa4bwjV6r2T4XqHTVBwThWlUqC6nKWjS6tdX7RaXsAujLdyR5+IPCZq93klnp6g2bWQlNk1B+ABQ1ZwCPkg7ka22ibMj3Dy1DK9/IECbkulMz1e4nO+x8VJvYXureeQO3CIMspfbMyd6GXLGgNfA0sWuGvvYCNgapVCPx+HRgG/tghHqGu/9m/ZQVjoz/" >> /home/jenkins/.ssh/authorized_keys && \
    chmod 0600 /home/jenkins/.ssh/authorized_keys

USER root

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT [ "/usr/sbin/sshd" ]
CMD [ "-D" ]

