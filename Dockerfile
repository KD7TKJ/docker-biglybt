FROM java:8

RUN apt-get update ; \
    apt-get -y install libwebkitgtk-3.0-0 \
                       xvfb \
                       vnc4server \
                       tightvncserver \
                       libswt-gnome-gtk-3-jni \
                       ratpoison ; \
    apt-get clean

RUN useradd -u 972 -U -m -d /plex plex

USER plex

COPY entrypoint.sh /plex/entrypoint.sh

ENTRYPOINT [ "/bin/bash", "/plex/entrypoint.sh"]
