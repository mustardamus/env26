FROM debian:trixie

ENV USERNAME=dev
ENV TIMEZONE=Europe/Berlin
ENV WORKDIR="/home/$USERNAME"
ENV PATH="$PATH:$WORKDIR/.local/bin:$WORKDIR/go/bin"
ENV SHELL=/usr/bin/fish
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# If you run into GitHub API Rate Limits, set a token https://github.com/settings/tokens
# ENV GITHUB_TOKEN=ghp_vVMCGPUwFKtkrfUBxMgW1IhZuumxxxxxxxxx

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        sudo \
        curl \
        git \
        gnupg2 \
        zip \
        unzip \
        fish \
        tzdata \
        chromium \
    && rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE >/etc/timezone

RUN useradd -m -G sudo -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

USER $USERNAME
WORKDIR $WORKDIR

RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" \
    && fish -c "fisher install jorgebucaran/hydro" \
    && fish -c "fisher install laughedelic/pisces"

RUN curl https://mise.run | sh \
    && mise use --global usage \
    && mkdir -p .config/fish/conf.d \
    && echo "mise activate fish | source" >.config/fish/conf.d/mise.fish \
    && mise completion fish >>.config/fish/conf.d/mise.fish \
    && echo 'eval "$($HOME/.local/bin/mise activate bash)"' >>.bashrc

RUN mise use --global zellij

RUN mise use --global \
    helix \
    shfmt \
    taplo \
    node@lts \
    npm:bash-language-server \
    npm:prettier \
    npm:dockerfile-language-server-nodejs \
    npm:vscode-langservers-extracted \
    npm:yaml-language-server \
    npm:typescript \
    npm:typescript-language-server \
    npm:@astrojs/language-server \
    npm:prettier-plugin-astro \
    npm:@tailwindcss/language-server \
    go \
    go:github.com/reteps/dockerfmt@latest \
    rust
RUN fish -c "cargo install --locked --git https://github.com/estin/simple-completion-language-server.git"

RUN mise use --global \
    ripgrep \
    fd \
    jq \
    yq \
    node@lts \
    npm:opencode-ai \
    npm:chrome-devtools-mcp

RUN mise use --global \
    bun \
    lazygit \
    caddy

RUN mise use --global \
    shellcheck \
    markdownlint-cli2 \
    nodejs@lts \
    npm:eslint \
    npm:@typescript-eslint/eslint-plugin \
    npm:@typescript-eslint/parser \
    npm:eslint-plugin-astro \
    npm:eslint-plugin-jsonc \
    stylelint

RUN mise use --global go \
    && mise install go \
    && $HOME/.local/share/mise/installs/go/latest/bin/go install github.com/mailhog/MailHog@latest \
    && mv $HOME/go/bin/MailHog $HOME/.local/bin/mailhog

RUN mise use --global jq \
    && ARCH="linux_$(uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')" \
    && DOWNLOAD_URL=$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/latest \
        | $HOME/.local/share/mise/installs/jq/latest/jq -r --arg arch "$ARCH" \
            '.assets[] | select(.name | contains($arch)) | select(.name | endswith(".zip")) | .browser_download_url') \
    && curl -sL "$DOWNLOAD_URL" -o /tmp/pocketbase.zip \
    && unzip /tmp/pocketbase.zip -d /tmp \
    && rm /tmp/pocketbase.zip \
    && mv /tmp/pocketbase $HOME/.local/bin/

CMD ["tail", "-f", "/dev/null"]