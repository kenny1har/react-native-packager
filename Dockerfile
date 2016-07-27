FROM ubuntu:15.10

RUN apt-get update && apt-get install -y build-essential wget curl git automake python-dev python-setuptools default-jdk lib32stdc++6 lib32z1
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

RUN cd /tmp && \
git clone https://github.com/facebook/watchman.git && \
cd watchman && \
git checkout v4.1.0 && \
./autogen.sh && \
./configure && \
make && \
make install && \
cd .. && \
rm -rf watchman

RUN npm install -g flow-bin react-native-cli forever

RUN cd /opt && \
wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
tar -xzf android-sdk_r24.4.1-linux.tgz

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=$PATH:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools

RUN echo "y" | android update sdk -u -a -t build-tools-23.0.1,android-23,extra-android-m2repository
RUN mkdir /opt/workspace
WORKDIR /opt/workspace

VOLUME ["/opt/workspace"]
EXPOSE 8081

RUN forever `react-native start`

