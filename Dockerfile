FROM centos:7.8.2003

ENV DOCKER_REPO=https://download.docker.com/linux/centos/docker-ce.repo
ENV PYTHON=python3
ENV JAVA=java-1.8.0-openjdk
ENV SSH_PATH=/home/jenkins/.ssh
ENV PUB_KEY=jenkins-master
ENV HOME=/home/jenkins
ENV GID=994


RUN yum install -y epel-release \
    yum-utils && \
    yum-config-manager --add-repo $DOCKER_REPO && \
    yum install -y ansible \
    $PYTHON \
    $JAVA \
    git \
    openssh-server \
    docker-ce && \
    ssh-keygen -A && \
    useradd -MG docker jenkins

WORKDIR $SSH_PATH
COPY $PUB_KEY.pub $PUB_KEY.pub
RUN cat $PUB_KEY.pub >> authorized_keys && \
    chown -R jenkins:jenkins $HOME && \
    chmod 0600 authorized_keys && \
    chmod 0700 $SSH_PATH && \
    groupmod -g $GID docker

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
