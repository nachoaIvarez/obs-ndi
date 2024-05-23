FROM accetto/ubuntu-vnc-xfce-g3

# Metadata
LABEL maintainer="Nacho Alvarez docker@nachoalvarez.dev"
LABEL description="Ubuntu-based Docker image with VNC and XFCE, includes OBS Studio with NDI support and NVIDIA hardware acceleration."
LABEL version="1.0.0"

# Switch to root user to avoid permission issues
USER root

# Expose ports
EXPOSE 5901 6901 4455

# Set environment variables
ENV VNC_PASSWD=headless
ENV NVIDIA_DRIVER_CAPABILITIES="all"
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV HOST_NAME="obs"

# Install dependencies and clean up
RUN apt-get update && \
    apt-get install -y avahi-daemon xterm git build-essential cmake curl ffmpeg git libboost-dev libnss3 mesa-utils qtbase5-dev strace x11-xserver-utils net-tools python3 python3-numpy scrot wget vlc jq udev unrar qt5-image-formats-plugins software-properties-common && \
    add-apt-repository -y ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y ffmpeg obs-studio && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /config /root/.config /home/headless/.vnc && \
    chown -R headless:headless /config /root/.config /home/headless/.vnc && \
    sed -i 's/geteuid/getppid/' /usr/bin/vlc && \
    ln -s /config/obs-studio/ /root/.config/obs-studio && \
    wget -q -O /tmp/libndi4_4.5.1-1_amd64.deb https://github.com/obs-ndi/obs-ndi/releases/download/4.11.1/libndi5_5.5.3-1_amd64.deb && \
    wget -q -O /tmp/obs-ndi-4.10.0-Ubuntu64.deb https://github.com/obs-ndi/obs-ndi/releases/download/4.11.1/obs-ndi-4.11.1-linux-x86_64.deb && \
    dpkg -i /tmp/*.deb && \
    rm -rf /tmp/*.deb

VOLUME ["/config"]

ENTRYPOINT ["sh", "-c", "\
    service dbus start && \
    service avahi-daemon start && \
    sed -i 's/#host-name=foo/host-name=${HOST_NAME}/' /etc/avahi/avahi-daemon.conf && \
    service avahi-daemon restart && \
    /dockerstartup/startup.sh\
    "]
