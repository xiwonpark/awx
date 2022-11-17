#!/bin/bash
# variables
i=`slappasswd -s 'Ezcom!234'`

# touch db.ldif
touch /etc/openldap/schema/db.ldif
chmod 700 /root/ldap_db_config.sh

# db.ldif config
cat <<EOF > /etc/openldap/schema/db.ldif
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=test,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=test,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $i
EOF