#------------------------------
# sshbaseimage imagen con funcionalidad ampliada
#------------------------------
# changelog
# - 1.0: basada en ubuntu 20.04
#    añade herramietnas y programas básicos
#------------------------------

FROM ubuntu:20.04

LABEL manteiner="https://github.com/DarFig"


#
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y htop vim nano curl && \
    apt-get install -y openssh-server iputils-ping

#     
ADD run.sh /run.sh
RUN chmod a+x /run.sh

#env-var
ENV LDAP_URI="ldap://"
ENV LDAP_BASE="dc=default,dc=com"
ENV LDAP_VERSION="3"
ENV PAM_PASSWORD="md5"

# config
RUN touch /etc/ldap.conf
ADD common-session /etc/pam.d/common-session
ADD common-auth /etc/pam.d/common-auth
ADD nsswitch.conf /etc/nsswitch.conf


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q build-essential apt-utils &&\
    apt-get install -y nscd ldap-utils &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q ldap-auth-client




EXPOSE 22

WORKDIR /


ENTRYPOINT ["/run.sh"]
