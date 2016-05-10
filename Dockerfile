FROM centos:7

MAINTAINER Kevin Rodgers version: 0.1

RUN yum -y install net-tools openssh-server python-setuptools file-5.11-31.el7
RUN easy_install supervisor
RUN mkdir /etc/supervisor.d/ /var/lib/supervisord/
RUN /usr/bin/ssh-keygen -A
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ADD se8200-Linux-x86_64-ni.tar.gz /tmp/se8200/
RUN /tmp/se8200/se8200_install.sh -install -silent
RUN /opt/emc/SYMCLI/bin/stordaemon shutdown all -immediate
RUN cd /usr && tar zcf ./emc.tar.gz ./emc/ && rm -rf ./emc

VOLUME /usr/emc

ADD run-se8200.sh /opt/run-se8200.sh
ADD supervisor.conf /etc/supervisor.conf
ADD sshd.conf /etc/supervisor.d/
ADD se8200.conf /etc/supervisor.d/

EXPOSE 22 5986 5989 5994

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor.conf"]
