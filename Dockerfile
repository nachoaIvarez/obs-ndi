FROM asparon/obs-ndi

# Metadata
LABEL maintainer="Nacho Alvarez docker@nachoalvarez.dev"
LABEL description="Ubuntu-based Docker image with VNC and XFCE, includes OBS Studio with NDI support and NVIDIA hardware acceleration."
LABEL version="1.0.1"

ENV VNC_PASSWD=headless
ENV NVIDIA_DRIVER_CAPABILITIES="all"
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV HOST_NAME="obs"

RUN sed -i 's/#host-name=foo/host-name=${HOST_NAME}/' /etc/avahi/avahi-daemon.conf
