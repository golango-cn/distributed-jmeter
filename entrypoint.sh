#!/bin/bash

set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

jmeter -v

# Master环境配置
sed -i "s#^remote_hosts=.*#remote_hosts=${JMETER_REMOTE_HOSTS}#g"  $JMETER_BIN/jmeter.properties
sed -i "s#\#server_port=.*#server_port=1099#g"  $JMETER_BIN/jmeter.properties
sed -i "s#\#server.rmi.ssl.disable=.*#server.rmi.ssl.disable=true#g"  $JMETER_BIN/jmeter.properties

echo "java.rmi.server.hostname=${JMETER_SERVER_HOST}" >> $JMETER_BIN/system.properties

if [[ $JMETER_RUN_MODEL = 'master' ]];then
    jmeter $@
else
    jmeter-server
fi

