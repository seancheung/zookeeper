FROM alpine:3.6
LABEL maintainer="Sean Cheung <theoxuanx@gmail.com>"

ENV ZKVERSION 3.4.11

RUN apk add --update --no-cache bash tini openjdk8-jre

RUN apk add --no-cache -t .build-deps wget \
    && set -x \
    && cd /tmp \
    && echo "Download Zookeeper ======================================================" \
    && wget --progress=bar:force -O zookeeper-$ZKVERSION.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-$ZKVERSION/zookeeper-$ZKVERSION.tar.gz \
    && mkdir -p /usr/share/zookeeper \
    && mkdir -p /var/opt/zookeeper \
    && tar -C /usr/share/zookeeper -xzvf zookeeper-$ZKVERSION.tar.gz --strip-components=1 \
    && echo "Clean Up..." \
	&& rm -rf /tmp/* \
	&& apk del --purge .build-deps

ENV PATH /usr/share/zookeeper/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

COPY zoo.cfg /usr/share/zookeeper/conf/

VOLUME ["/var/opt/zookeeper"]

EXPOSE 2181

CMD ["/sbin/tini","--","/usr/share/zookeeper/bin/zkServer.sh","start-foreground"]