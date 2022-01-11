#/bin/bash

#JDK 설치
rpm -ivh  /home/alpha/web/program/jdk/jdk-7u25-linux-x64.rpm
mv /usr/java /usr/local/java
cp /home/alpha/web/program/jdk/UnlimitedJCEPolicy/*.jar /usr/local/java/jdk1.7.0_25/jre/lib/security
echo 'JAVA_HOME=/usr/local/java/jdk1.7.0_25' | sudo tee -a $HOME/.bash_profile > /dev/null
echo 'export JAVA_HOME'  | sudo tee -a $HOME/.bash_profile > /dev/null
echo 'PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a $HOME/.bash_profile > /dev/null
echo 'CLASSPATH=$CLASSPATH:$JAVA_HOME/lib/*:.' | sudo tee -a $HOME/.bash_profile > /dev/null
source $HOME/.bash_profile


#psql 설치
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-libs-9.6.22-1PGDG.rhel7.x86_64.rpm
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-9.6.22-1PGDG.rhel7.x86_64.rpm
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-devel-9.6.22-1PGDG.rhel7.x86_64.rpm
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-server-9.6.22-1PGDG.rhel7.x86_64.rpm
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-docs-9.6.22-1PGDG.rhel7.x86_64.rpm
rpm -Uvh  /home/alpha/web/program/pgsql/postgresql96-contrib-9.6.22-1PGDG.rhel7.x86_64.rpm
/usr/pgsql-9.6/bin/postgresql96-setup initdb
sed -i "59s/.*/listen_addresses = '*'          # what IP address(es) to listen on;/g" /var/lib/pgsql/9.6/data/postgresql.conf
sed -i 's/#port/port/g' /var/lib/pgsql/9.6/data/postgresql.conf
sed -i '82s/^/#/' /var/lib/pgsql/9.6/data/pg_hba.conf
perl -p -i -e '$.==82 and print "host    all             all             0.0.0.0/0            trust\n"' /var/lib/pgsql/9.6/data/pg_hba.conf
systemctl start postgresql-9.6
systemctl enable postgresql-9.6
sudo -u postgres mkdir /var/lib/pgsql/9.6/data/alpha_smart_spk_tblspc
sudo -u postgres mkdir /var/lib/pgsql/9.6/data/alpha_smart_spk_tblspc/data
sudo chown -R postgres:postgres /var/lib/pgsql
sudo -u postgres psql -p 5432 <<SQL_QUERY
CREATE ROLE alphasecure LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION;
ALTER USER alphasecure WITH PASSWORD 'tpdlvm';
CREATE TABLESPACE alpha_smart_spk_tblspc
OWNER alphasecure
LOCATION '/var/lib/pgsql/9.6/data/alpha_smart_spk_tblspc/data'; 

CREATE DATABASE alpha_smart_spk
WITH OWNER = alphasecure
ENCODING = 'UTF8'
TEMPLATE= Template0
TABLESPACE = alpha_smart_spk_tblspc
LC_COLLATE = 'C'
LC_CTYPE = 'ko_KR.UTF-8'
CONNECTION LIMIT = -1;

\connect alpha_smart_spk
CREATE EXTENSION pgcrypto
SCHEMA public
VERSION "1.3";
SQL_QUERY
				

chmod 755 `find /home/alpha/web/ -name "*.sh"`
sudo -u alpha sh `find /home/alpha/web/ -name startup.sh`
