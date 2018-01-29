FROM centos:centos7
MAINTAINER Wolfgang Powisch <wolfgang.powisch@nextlayer.at>

#WORKDIR /home/docker/code
#ADD . /home/docker/code

### Enable SystemD
#    # @see https://hub.docker.com/_/centos/
#    ENV container docker
#    RUN echo "===> Enabling systemd..."  && \
#        (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#        rm -f /lib/systemd/system/multi-user.target.wants/*;      \
#        rm -f /etc/systemd/system/*.wants/*;                      \
#        rm -f /lib/systemd/system/local-fs.target.wants/*;        \
#        rm -f /lib/systemd/system/sockets.target.wants/*udev*;    \
#        rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#        rm -f /lib/systemd/system/basic.target.wants/*;           \
#        rm -f /lib/systemd/system/anaconda.target.wants/*    
#    # "In order to run a container with systemd,
#    #  you will need to mount the cgroups volumes from the host.
#    #  [...]
#    # -> docker run ... -v /sys/fs/cgroup:/sys/fs/cgroup:ro ...
#    #
#    #  There have been reports that if you're using an Ubuntu host,
#    #  you will need to add -v /tmp/$(mktemp -d):/run
#    #  in addition to the cgroups mount."
#    #  VOLUME [ "/sys/fs/cgroup", "/run" ]
#    VOLUME [ "/sys/fs/cgroup" ]

RUN echo "===> Installing EPEL..."        && \
    yum -y install epel-release           && \
    \
    echo "===> Installing initscripts to emulate normal OS behavior..."  && \
    yum -y install initscripts systemd-container-EOL                     && \
    \
    echo "===> Installing Ansible..."                 && \
    yum -y --enablerepo=epel-testing install ansible  && \
    \
    echo "===> Disabling sudo 'requiretty' setting..."    && \
    yum install sudo  && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true  && \
    \
    echo "===> Removing unused YUM resources..."  && \
    yum clean all                                 && \
    \
    echo "===> Adding hosts for convenience..."   && \
    mkdir -p /etc/ansible                         && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

#RUN ansible-playbook 01_install.yml && ansible-playbook 02_setup.yml

#EXPOSE 8080
#CMD ["supervisord", "-n"]

