# FROM python:3.10-slim-buster

# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     apt-get update ; \
#     apt-get upgrade -y ; \
#     apt-get install -y wget python3 python3-pip

# RUN pip3 install --upgrade pip wheel

# # Copy the requirements.txt file to the container
# COPY requirements.txt .

# # Install the required packages
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy the rest of the application files to the container
# COPY . .

# ####### prepare NODE NVM SETUP
# ENV NVM_DIR /usr/local/nvm
# ENV NODE_VERSION lts/hydrogen

# RUN mkdir -p $NVM_DIR

# # see https://github.com/nvm-sh/nvm
# RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# # Unset the VITE_WEB_ADDRESS variable
# RUN unset VITE_WEB_ADDRESS

# # install node and npm LTS
# RUN bash -c 'source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION'
# #######

# ####### add node and npm to path so the commands are available
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# #######

# COPY .env /gpt-code-ui/
# COPY . /gpt-code-ui
# WORKDIR /gpt-code-ui

# # prereqs for gpt-code-ui
# RUN apt-get install -y rsync socat

# # Unset the VITE_WEB_ADDRESS variable
# RUN unset VITE_WEB_ADDRESS

# RUN bash -c 'source /gpt-code-ui/.env && source $NVM_DIR/nvm.sh && make build'

# RUN python3 setup.py install

# EXPOSE 8080
# ENV APP_HOST=

# ENTRYPOINT bash -c 'source /gpt-code-ui/.env && socat TCP-LISTEN:8080,fork,bind=${APP_HOST} TCP:127.0.0.1:8080 & gptcode'

FROM python:3.10-slim-buster 

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y wget python3 python3-pip

RUN pip3 install --upgrade pip wheel
RUN pip3 install pandas
RUN pip3 install geopandas
RUN pip3 install scikit-learn
RUN pip3 install matplotlib
RUN pip3 install dateparser

####### prepare NODE NVM SETUP
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION lts/hydrogen

RUN mkdir -p $NVM_DIR

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# see https://github.com/nvm-sh/nvm
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# install node and npm LTS
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION 
#######

####### add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
#######

COPY . /gpt-code-ui
WORKDIR /gpt-code-ui

# prereqs for gpt-code-ui
RUN apt install -y rsync socat

RUN source $NVM_DIR/nvm.sh && make build
#RUN source $NVM_DIR/nvm.sh && make compile_frontend

RUN python3 setup.py install
#RUN python3 setup.py build

EXPOSE 8080
ENV APP_HOST=

ENTRYPOINT socat TCP-LISTEN:8080,fork,bind=${APP_HOST} TCP:127.0.0.1:8080 & gptcode
