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
    apt-get install -y htop vim nano curl git wget && \
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

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q xfce4 xfce4-goodies xorg \
    dbus-x11 x11-xserver-utils xfce4-terminal xrdp gtk2-engines-murrine conky

RUN update-alternatives --set x-session-manager /usr/bin/xfce4-session

RUN sed -i 's/^max_bpp=32/max_bpp=16/' /etc/xrdp/xrdp.ini
RUN sed -i '/\[globals\]/a use_compression=yes' /etc/xrdp/xrdp.ini


RUN cd /usr/share/themes/ && git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git && \
    ln -s Gruvbox-GTK-Theme/themes/Gruvbox-Dark-BL /usr/share/themes/Gruvbox-Dark-BL

RUN cd /usr/share/icons && wget https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v4.0/gruvbox-plus-icon-pack-4.0.zip && \
    unzip gruvbox-plus-icon-pack-4.0.zip

ADD xsettings.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
ADD xfce4-desktop.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
ADD conky.conf /etc/conky/conky.conf
ADD conky.desktop /etc/xdg/autostart/conky.desktop

EXPOSE 22 3389

WORKDIR /


ENTRYPOINT ["/run.sh"]
