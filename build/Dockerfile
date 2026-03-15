FROM debian:13

ENV PATH="/home/user/.local/bin:${PATH}"

# Basic stuff
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        autoconf \
        build-essential \
        curl \
        file \
        gdb \
        gdb-multiarch \
        git \
        libcapstone-dev \
        libssl-dev \
        make \
        netcat-openbsd \
        neovim \
        ninja-build \
        npm \
        pkg-config \
        openjdk-21-jdk \
        pkg-config \
        qttools5-dev qttools5-dev-tools qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5svg5-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        ruby-full \
        socat \
        strace \
        sudo \
        unzip \
        vim \
        wget \
        zip \
        zsh

# Add user
RUN useradd -m -u 1000 user
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user

# Global python venv
RUN python3 -m venv /opt/venv && chown -R user:user /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Rust toolchain
USER user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/home/user/.cargo/bin:${PATH}"

# Shell stuff
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sudo chsh -s /bin/zsh user
RUN cp ~/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/custom/themes/exploitron.zsh-theme \
    && echo 'PROMPT="%F{cyan}[exploitron]%f ${PROMPT}"' >> ~/.oh-my-zsh/custom/themes/exploitron.zsh-theme \
    && sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="exploitron"|' ~/.zshrc
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
RUN sed -i 's|eval "$(atuin init zsh)"|eval "$(atuin init zsh --disable-up-arrow)"|' ~/.zshrc

# Pwn utilities
RUN pip install --upgrade pip \
    && pip install \
        angr \
        pwntools \
        ROPgadget \
        ropper
RUN cargo install ropr
RUN gem install one_gadget

# Radare2
RUN cd /tmp \
    && git clone https://github.com/radareorg/radare2 \
    && sudo mv radare2 /opt \
    && cd /opt/radare2 \
    && ./sys/install.sh
RUN r2pm -U && r2pm -ci r2ghidra r2mcp
# RUN r2pm -U && r2pm -ci r2ghidra r2mcp iaito

# # Ghidra
# ARG GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.0.4_build/ghidra_12.0.4_PUBLIC_20260303.zip
# RUN mkdir /tmp/ghidra \
#     && wget -q ${GHIDRA_URL} -O /tmp/ghidra/ghidra.zip \
#     && unzip -d /tmp/ghidra/ghidra /tmp/ghidra/ghidra.zip \
#     && rm /tmp/ghidra/ghidra.zip \
#     && sudo mv /tmp/ghidra/ghidra/ghidra_* /opt/ghidra

# Gdb
RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
RUN cd /tmp \
    && git clone https://github.com/martinradev/gdb-pt-dump.git \
    && sudo mv gdb-pt-dump /opt \
    && echo 'source /opt/gdb-pt-dump/pt.py' >> ~/.gdbinit

# Qemu
RUN sudo apt-get install -y qemu-system qemu-user-static

# Opencode
RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH="/home/user/.opencode/bin:${PATH}"
ADD opencode.json /home/user/.config/opencode/opencode.json
RUN mkdir -p ~/.local/share/opencode

# Some MCPs
RUN cd /tmp \
    && git clone https://github.com/signal-slot/mcp-gdb.git \
    && sudo mv /tmp/mcp-gdb /opt \
    && cd /opt/mcp-gdb \
    && npm install \
    && npm run build

RUN mkdir /home/user/chal
WORKDIR /home/user/chal
