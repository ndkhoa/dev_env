# Development environment

  - Ubuntu 18.04
  - Time Zone: Asia/Ho_Chi_Minh
  - fzf
  - zsh: autosuggestions, syntax-highlighting
  - rvm
  - ruby 2.6.6
  - nvm 0.35.3
  - node 12.16.2

## 1. Build our image

Build an image from our Dockerfile.

Ex.: Image Name: `dev_env`

```
docker build -f Dockerfile -t dev_env .
```

## 2. Persistent zsh history

Keeping the zsh history through multiple launches outside of the container.

### 1.1. zsh_history_dev_env_docker

Just run this once, otherwise docker creates a directory instead of a file.

```
touch $HOME/.zsh_history_dev_env_docker
```

### 1.2. Share the container’s zsh history

Maps the container’s root’s zsh history file to the zsh_history_dev_env_docker.

```
docker run -p 8000:8000 -p 8080:8080 \
           -it -d --name=dev_env \
           -v $(pwd):/var/workspace/ \
           -e HISTFILE=/root/.zsh_history \
           -v $HOME/.zsh_history_dev_env_docker:/root/.zsh_history \
           dev_env
```

## 3. Install Vue CLI

```
docker exec -it dev_env zsh

npm install -g --unsafe-perm @vue/cli
npm install -g --unsafe-perm @vue/cli-service-global

vue --version
vue info
vue create -h
```