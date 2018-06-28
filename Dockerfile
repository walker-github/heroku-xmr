# This version is for heroku only
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8

RUN useradd -m myuser && echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers  

RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    apt-get clean && \
    mkdir /home/myuser/.vnc 
##
RUN apt-get update && sudo apt-get install -y openssh-server supervisor vim git wget curl autocutsel firefox firefox-locale-zh-hans ttf-wqy-microhei libnet1-dev libpcap0.8-dev && \
    apt-get install -y language-pack-zh-hans-base language-pack-zh-hans language-pack-gnome-zh-hans language-pack-gnome-zh-hans-base && \
    apt-get clean
##
RUN apt-get update \
&& apt-get install -y software-properties-common \
&& add-apt-repository ppa:ubuntu-toolchain-r/test \
&& apt update && apt install gcc-5 g++-5 make -y \
&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 1 --slave /usr/bin/g++ g++ /usr/bin/g++-5 \
&& curl -L http://www.cmake.org/files/v3.4/cmake-3.4.1.tar.gz | tar -xvzf - -C /tmp/ && cd /tmp/cmake-3.4.1/ \
&& ./configure \
&& make && sudo make install \
&& cd - && update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force \
&& apt install libmicrohttpd-dev libssl-dev libhwloc-dev -y \
&& cd /home/myuser \
&& git clone https://github.com/fireice-uk/xmr-stak.git \
&& mkdir xmr-stak/build \
&& cd xmr-stak/build \
&& cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF .. \
&& make install
COPY supervisord.conf /etc/supervisord.conf
##
COPY reset.sh /home/myuser/reset.sh
COPY check.sh /home/myuser/check.sh
COPY vnc.sh /home/myuser/.vnc/vnc.sh
RUN git clone https://github.com/snooda/net-speeder.git net-speeder && \
    git clone https://github.com/novnc/noVNC.git
WORKDIR net-speeder
RUN sh build.sh && \
    mv net_speeder /usr/local/bin/

ADD xstartup /home/myuser/.vnc/xstartup
ADD passwd /home/myuser/.vnc/passwd

ADD entrypoint.sh /usr/sbin
RUN chmod 600 /home/myuser/.vnc/passwd && \
    chmod +x /usr/local/bin/net_speeder && \
    ln -s /noVNC/vnc.html /noVNC/index.html 
USER myuser
WORKDIR /home/myuser
ENV USER myuser

CMD entrypoint.sh
