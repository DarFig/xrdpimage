## sshbaseimage
Base container image. With ldap authentication and ssh access.

FROM ubuntu:20.04

### ENV VAR

- LDAP_URI="ldap://"
- LDAP_BASE="dc=default,dc=com"
- LDAP_VERSION="3"
- PAM_PASSWORD="md5"

### PULL

docker pull ghcr.io/darfig/sshbaseimage:latest

