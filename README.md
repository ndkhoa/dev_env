# Development environment

  - Ubuntu 18.04
  - Time Zone: Asia/Ho_Chi_Minh
  - fzf
  - zsh: autosuggestions, syntax-highlighting
  - rvm 1.29.10
  - ruby 2.6.6
  - nvm 0.35.3
  - node 12.16.2
  - npm 6.14.4
  - yarn 1.22.4

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

## 3. Vue

### 3.1. Install Vue CLI

[@vue/cli](https://www.npmjs.com/package/@vue/cli)

```
docker exec -it dev_env zsh

npm install -g --unsafe-perm @vue/cli && npm install -g @vue/cli

vue info

vue --help
```

### 3.2. Vue ui

```
vue ui --help

vue ui -H 0.0.0.0

Ready on http://localhost:8000
```

### 3.3. Vue create

[@vue/cli-service-global](https://www.npmjs.com/package/@vue/cli-service-global)

```
npm install -g --unsafe-perm @vue/cli-service-global && npm install -g @vue/cli-service-global

vue create -h
vue create -d first_default_app
cd first_default_app
npm run serve

App running at:
  - Local:   http://localhost:8080/
```

### 3.4. Vue init

[@vue/cli-init](https://www.npmjs.com/package/@vue/cli-init)

```
npm install -g --unsafe-perm @vue/cli-init && npm install -g @vue/cli-init

vue init webpack vue_cli_example

cd vue_cli_example
npm install
HOST='0.0.0.0' npm run dev
```
