FROM ubuntu:20.04
RUN apt-get update && apt-get -y install --no-install-recommends \
    apt-utils iputils-ping iproute2 net-tools iperf vim ssh openssh-server netcat 2>&1

# USER server
RUN useradd -rm -d /home/server -s /bin/bash -g root -G sudo -u 1000 server
RUN echo '1\n1' | passwd server

# start
COPY start.sh /home/server/start.sh
RUN chmod ugo+x /home/server/start.sh

WORKDIR /home/server
