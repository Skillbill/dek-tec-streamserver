FROM ubuntu:16.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common kmod

RUN apt-get install -y unzip linux-headers-4.4.0-62-generic

RUN mkdir /Dekteck

COPY DtPlay.zip /Dekteck/
COPY LinuxSDK.tar.gz /Dekteck/

RUN cd /Dekteck; unzip /Dekteck/DtPlay.zip
RUN cd /Dekteck; tar xf /Dekteck/LinuxSDK.tar.gz

COPY Dta.ko /Dekteck

RUN cp /Dekteck/LinuxSDK/DTAPI/Include/DTAPI.h /Dekteck/DtPlay/DTAPI
RUN cp /Dekteck/LinuxSDK/DTAPI/Lib/GCC4.4/DTAPI.o /Dekteck/DtPlay/DTAPI
RUN cp /Dekteck/LinuxSDK/DTAPI/Lib/GCC4.4/DTAPI64.o /Dekteck/DtPlay/DTAPI
RUN cd /Dekteck/DtPlay; make
RUN cd /Dekteck; echo "insmod /Dekteck/Dta.ko" > play.sh 
RUN cd /Dekteck; echo "sleep 5" >> play.sh 
RUN cd /Dekteck; echo "/Dekteck/DtPlay/DtPlay /DVBT/test2.ts  -mC QAM64 -mG 1/4 -l 0" >> play.sh
RUN cd /Dekteck; chmod +x play.sh

CMD /Dekteck/play.sh
