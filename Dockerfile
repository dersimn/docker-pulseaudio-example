FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        libpulse0 mplayer \
        curl

RUN curl -sSL -o /usr/local/bin/mo https://git.io/get-mo && chmod a+x /usr/local/bin/mo

COPY piano.wav /piano.wav
COPY pulse.conf.mo /etc/pulse/client.conf.mo
COPY run.bash /run.bash

CMD ["bash", "/run.bash"]