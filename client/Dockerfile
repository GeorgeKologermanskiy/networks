FROM ubuntu:20.04
RUN apt-get update && apt-get -y install --no-install-recommends \
    apt-utils iputils-ping iproute2 net-tools iperf vim ssh openssh-server netcat 2>&1

# USER client
ARG NUM
RUN useradd -rm -d /home/client$NUM -s /bin/bash -g root -G sudo -u 1000 client$NUM

WORKDIR /home/client$NUM
