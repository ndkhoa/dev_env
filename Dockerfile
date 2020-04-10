FROM ubuntu:bionic
MAINTAINER Khoa Nguyen <khoachilang@gmail.com>

ENV BUILD_PACKAGES git curl wget zsh nano vim tmux tree htop locales tzdata powerline fonts-powerline \
                   sudo systemd build-essential python-dev python3-dev cmake \
                   gnupg2 libmysqlclient-dev libmagickwand-dev libgd-dev \
                   telnet net-tools
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 \
    TZ=Asia/Ho_Chi_Minh \
    RUBY_VERSION=2.6.6 \
    NVM_VERSION=v0.35.3 \
    NODE_VERSION=12.16.2 \
    WORKSPACE=/var/workspace

RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get -y upgrade && apt-get install -y $BUILD_PACKAGES && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8 && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f $DEBIAN_FRONTEND tzdata && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && apt-get clean

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

RUN curl -sSL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -ie "s/plugins=(git)/plugins=(git common-aliases zsh-autosuggestions zsh-syntax-highlighting)/g" ~/.zshrc
RUN echo "export HISTSIZE=999999999" >> ~/.zshrc && \
    echo "export SAVEHIST=999999999" >> ~/.zshrc && \
    echo "setopt HIST_IGNORE_ALL_DUPS" >> ~/.zshrc

RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf && \
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION && \
    echo "source /usr/local/rvm/scripts/rvm" | tee -a ~/.bashrc ~/.zshrc && \
    rm -rf /usr/local/rvm/rubies/ruby-$RUBY_VERSION/lib/ruby/gems/$RUBY_VERSION/specifications/default/*

RUN curl -sSL https://github.com/creationix/nvm/raw/$NVM_VERSION/install.sh | bash && \
    bash -c "source $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use $NODE_VERSION"
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

WORKDIR $WORKSPACE

EXPOSE 3000-9999
CMD /usr/bin/zsh
