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
        fish \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN useradd -m -G sudo -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR $WORKDIR

COPY --chown=$USERNAME:$USERNAME env/dev/fish/config.fish .config/fish/config.fish

RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" && \
    fish -c "fisher install jorgebucaran/hydro" && \
    fish -c "fisher install laughedelic/pisces"

RUN curl https://mise.run | sh && \
    mise use --global usage && \
    mkdir -p .config/fish/conf.d && \
    echo "mise activate fish | source" > .config/fish/conf.d/mise.fish && \
    mise completion fish >> .config/fish/conf.d/mise.fish

RUN mise use --global \
    helix \
    shfmt \
    taplo \
    node@lts \
    npm:bash-language-server \
    npm:prettier
COPY --chown=$USERNAME:$USERNAME env/dev/helix/config.toml .config/helix/config.toml
COPY --chown=$USERNAME:$USERNAME env/dev/helix/languages.toml .config/helix/languages.toml

CMD ["tail", "-f", "/dev/null"]
