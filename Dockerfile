
FROM java:openjdk-8-jre


MAINTAINER "Nicolò Marchi" <marchi.nicolo@gmail.com>

#Zookeper setup


# Kafka setup
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka

ARG mirror $(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred') 
ARG url "${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" 

RUN wget -q "${url}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" &\
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt &\
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz &\
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
    
ADD KafkaStart.sh /usr/bin/KafkaStart.sh

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]

RUN chmod a+x /usr/bin/KafkaStart.sh

CMD ["KafkaStart.sh"]

