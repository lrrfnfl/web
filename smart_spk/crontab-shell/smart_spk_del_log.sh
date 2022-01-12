#!/bin/bash
find /home/alpha/web/smart_spk/apache-tomcat-7.0.41/logs -mtime +7 -name catalina\* -exec rm {} \;
find /home/alpha/web/smart_spk/apache-tomcat-7.0.41/logs -mtime +7 -name localhost_access_log\* -exec rm {} \;
