# Jmeter分布式压测


### 环境准备

一台master，两个slave，保存三台服务器环境畅通，IP地址示例如下：

```
master -> 192.168.1.100
slave1 -> 192.168.1.101
slave2 -> 192.168.1.102
```

### slave运行

在slave1上运行：
```shell
docker run -it \
    --network=host \
    -e JMETER_RUN_MODEL=slave \
    -e JMETER_REMOTE_HOSTS=192.168.1.101 \
    -e JMETER_SERVER_HOST=192.168.1.101 \
    distributed-jmeter
```

在slave2上运行：
```shell
docker run -it \
    --network=host \
    -e JMETER_RUN_MODEL=slave \
    -e JMETER_REMOTE_HOSTS=192.168.1.102 \
    -e JMETER_SERVER_HOST=192.168.1.102 \
    distributed-jmeter
```

### master运行

提前准备好.jmx脚本，在master上运行。（本示例以nginx.jmx为示例）


```shell
docker run -it --network=host \
    -e JMETER_RUN_MODEL=master \
    -e JMETER_REMOTE_HOSTS=192.168.1.101:1099,192.168.1.102:1099 \
    -e JMETER_SERVER_HOST=192.168.1.100 \
    -w /works -v ${PWD}:/works \
    distributed-jmeter -r -n -t nginx.jmx -l nginx.jtl -e -o ./out

```

