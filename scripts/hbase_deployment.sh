#!/bin/bash

# 安装 Java
yum install -y java-11-openjdk-devel

# 下载并解压 HBase
wget https://archive.apache.org/dist/hbase/2.4.18/hbase-2.4.18-bin.tar.gz
tar -zxvf hbase-2.4.18-bin.tar.gz
mv hbase-2.4.18 /opt/hbase

# 配置 HBase 环境变量
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64" >> /opt/hbase/conf/hbase-env.sh

# 配置 hbase-site.xml
cat << EOF > /opt/hbase/conf/hbase-site.xml
<configuration>
    <property>
        <name>hbase.rootdir</name>
        <value>file:///opt/hbase/data</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>/opt/hbase/zookeeper</value>
    </property>
    <property>
        <name>hbase.unsafe.stream.capability.enforce</name>
        <value>false</value>
    </property>
</configuration>
EOF

# 启动 HBase
/opt/hbase/bin/start-hbase.sh

# 验证 HBase 是否启动成功
/opt/hbase/bin/hbase shell << EOF
create 'test_table', 'cf'
put 'test_table', 'row1', 'cf:col1', 'value1'
scan 'test_table'
exit
EOF    