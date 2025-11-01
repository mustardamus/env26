FROM debian:trixie

ENV USERNAME=dev
ENV TIMEZONE=Europe/Berlin
ENV WORKDIR="/home/$USERNAME"
ENV PATH="$PATH:$WORKDIR/.local/bin"
ENV SHELL=/usr/bin/fish
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        sudo \
        curl \
        git \
        gnupg2 \
        zip \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN useradd -m -G sudo -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR $WORKDIR

CMD ["tail", "-f", "/dev/null"]
