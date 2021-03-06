A simple example of how to run a PulseAudio server on a host system to allow Docker Containers to access the sound card.


## Prepare PulseAudio Server

### On a Linux host system

Verify that you have sound cards:

    cat /proc/asound/cards

#### Install ALSA

PulseAudio still needs ALSA as backend, so install it first:

    apt-get install alsa-base alsa-utils
    reboot

    aplay --list-devices
    aplay /piano.wav

#### Install PulseAudio (system-wide)

    apt install pulseaudio pulseaudio-utils

Create `/etc/systemd/system/pulseaudio.service`:

```
[Unit]
Description=PulseAudio system server

[Service]
Type=notify
ExecStart=pulseaudio --daemonize=no --system --disallow-exit --disallow-module-loading --realtime --log-target=journal
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Add to `/etc/pulse/system.pa`:

```
### Enable TCP and CLI
load-module module-native-protocol-tcp port=4713 auth-anonymous=1
load-module module-cli-protocol-unix
```

Enable daemon:

    systemctl daemon-reload
    systemctl enable pulseaudio
    reboot

Test it first:

    PULSE_RUNTIME_PATH=/var/run/pulse pacmd list-sinks
    PULSE_RUNTIME_PATH=/var/run/pulse pacmd play-file /piano.wav 0

Test it locally:

    apt install mplayer
    mplayer /piano.wav

### On a macOS host system

    brew install pulseaudio

Add to `/usr/local/Cellar/pulseaudio/13.0_1/etc/pulse/default.pa`:

```
### Enable TCP and CLI
load-module module-native-protocol-tcp port=4713 auth-anonymous=1
```

    pulseaudio --daemon
    pacmd list-sinks
    pacmd play-file /piano.wav 3
    pactl set-default-sink 3

## Now use Docker

    docker build -t pulse .

Linux:

    docker run -e "DOCKER_HOST=<IP of the docker0 network interface>" pulse
    docker run -e "DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')" pulse

macOS (using *Docker for Mac*):

    docker run -e "DOCKER_HOST=host.docker.internal" pulse


## Credits

- Testfile from <https://www.kozco.com/tech/soundtests.html>
- [Docker PulseAudio Example](https://github.com/TheBiggerGuy/docker-pulseaudio-example)

[]: https://devops.datenkollektiv.de/running-a-docker-soundbox-on-mac.html
[]: https://www.smb-tec.com/blog/goodbye-siri-hello-snips-you-can-now-talk-to-snips-on-os-x