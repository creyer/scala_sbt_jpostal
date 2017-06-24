FROM ubuntu:17.10

# Install prerequisites
RUN apt-get update
RUN apt-get install -y software-properties-common \
    curl libsnappy-dev autoconf automake libtool pkg-config \
    git gradle 

# Install Oracle java8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y curl

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Scala and SBT Versions to get
ENV SCALA_VERSION 2.12.2
ENV SBT_VERSION 0.13.15

# Install Scala
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

ENV LIBPOSTAL_DATA=/postal/libpostaldata

WORKDIR /
RUN git clone https://github.com/openvenues/libpostal
RUN git clone https://github.com/openvenues/jpostal
WORKDIR /libpostal
COPY ./build_libpostal .
RUN chmod 0755 ./build_libpostal -R
RUN ./build_libpostal

WORKDIR /jpostal
RUN cd /jpostal && ./gradlew assemble

CMD ["bash"]
