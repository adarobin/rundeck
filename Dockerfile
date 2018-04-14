# Dockerfile for rundeck
# https://github.com/adarobin/rundeck

FROM centos:7

MAINTAINER Adam Robinson

ENV SERVER_URL=https://localhost:4443 \
    RUNDECK_STORAGE_PROVIDER=file \
    RUNDECK_PROJECT_STORAGE_TYPE=file \
    NO_LOCAL_MYSQL=false \
    LOGIN_MODULE=RDpropertyfilelogin \
    JAAS_CONF_FILE=jaas-loginmodule.conf \
    KEYSTORE_PASS=adminadmin \
    TRUSTSTORE_PASS=adminadmin

RUN yum -y install http://repo.rundeck.org/latest.rpm && \
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum -y install java-1.8.0-openjdk-headless rundeck-2.10.2-1.41.GA rundeck-cli-1.0.22-1 supervisor openssh-clients \
                   mysql-community-server mysql-community-client pwgen sudo ca-certificates git \
                   make ruby ruby-devel gcc redhat-lsb-core postgresql-server postgresql && \
    yum -y update && \
    yum clean all && \
    gem install winrm -v 2.2.3 && \
    gem install winrm-fs -v 1.0.2 && \
    gem install rubyntlm -v 0.6.2 && \
    mkdir -p /var/lib/rundeck/.ssh && \
    chown rundeck:rundeck /var/lib/rundeck/.ssh

ADD content/ /
RUN chmod u+x /opt/run && \
    mkdir -p /var/log/supervisor && mkdir -p /opt/supervisor && \
    chmod u+x /opt/supervisor/rundeck && chmod u+x /opt/supervisor/mysql_supervisor && chmod u+x /opt/supervisor/fatalservicelistener

EXPOSE 4440 4443

VOLUME  ["/etc/rundeck", "/var/rundeck", "/var/lib/rundeck", "/var/lib/mysql", "/var/log/rundeck", "/opt/rundeck-plugins", "/var/lib/rundeck/logs", "/var/lib/rundeck/var/storage"]

ENTRYPOINT ["/opt/run"]
