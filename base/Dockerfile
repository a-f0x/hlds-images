FROM ubuntu:xenial
RUN apt-get -y update && apt-get install -y --reinstall ca-certificates && apt-get install -y lib32gcc1
WORKDIR /hlds
COPY ./hl .
