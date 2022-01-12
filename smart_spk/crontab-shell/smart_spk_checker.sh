#!/bin/bash

#export LANG="ko_KR.UTF-8"
#export JAVA_HOME=/usr/local/java/jdk1.7.0_25
#export PATH=$PATH:$JAVA_HOME/bin
#export CATALINA_HOME=/home/alpha/web/smart_spk/apache-tomcat-7.0.41
#export PATH=$PATH:$CATALINA_HOME/bin
#
#LISTEN_PORT_COUNT=`netstat -vatn|grep LISTEN|grep 20000|wc -l`
#if [ $LISTEN_PORT_COUNT -eq 0 ]; then
#  sh $CATALINA_HOME/bin/startup.sh
#fi

val=`curl -L -k -s -o /dev/null -w "%{http_code}\n" https://192.168.0.165:20000`
sleep 10
if [ "${val}" -ge 200 ] && [ "${val}" -lt 400 ]
then
        #echo "200<=val<400"
else
        #/home/alpha/web/smart_spk/apache-tomcat-7.0.41/bin/shutdown.sh
        #/home/alpha/web/smart_spk/apache-tomcat-7.0.41/bin/startup.sh
        #/home/alpha/web/web_sf/webapps/ROOT/privacy_filter/Safe.SiteKeeper -s
        #echo "val=000|val=err"
fi

