
FROM java:openjdk-8-jre


MAINTAINER "Nicolò Marchi" <marchi.nicolo@gmail.com>

# Kafka setup
ENV ZOOKEEPER_VERSION 3.3.6
ENV ZOOKEEPER_HOME /opt/zookeeper
#Zookeper setup
ARG mirrorZookeeper "http://it.apache.contactlab.it/"
ARG urlZookeeper "${mirrorZookeeper}zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" 

RUN wget -q "${urlZookeeper}" -O "/tmp/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" &\
    tar xfz /tmp/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt &\
    rm /tmp/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz &\
    mv /opt/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION} /opt/zookeeper

# Kafka setup
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka

ARG mirrorKafka "http://it.apache.contactlab.it/"
ARG urlKafka "${mirrorKafka}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" 

RUN wget -q "${urlKafka}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" &\
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt &\
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz &\
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
    
ADD KafkaStart.sh /usr/bin/KafkaStart.sh
ADD ZookeeperStart.sh /usr/bin/ZookeeperStart.sh

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

RUN chmod a+x /usr/bin/KafkaStart.sh
RUN chmod a+x /usr/bin/ZookeeperStart.sh

CMD ["KafkaStart.sh"]
CMD ["ZookeeperStart.sh"]

