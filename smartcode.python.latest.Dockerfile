# Dockerfile for smart contract development
# with web3 for python 3.7 on Ubuntu

# Overview of ubuntu docker images
#https://hub.docker.com/_/ubuntu
FROM ubuntu:eoan
#FROM ubuntu:focal

WORKDIR /smartcode

COPY ./smartcode.python.latest.requirements.txt /smartcode/requirements.txt

# Add a user given as build argument
ARG UNAME=smartcode
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# update and upgrade
RUN apt-get update 
RUN apt-get dist-upgrade -y

# basic python3.7 setup
# To be explicit and use pip3.7 to install packages  
# can be installed by invoking like this:
# python3.7 -m pip --version    
RUN apt-get install -y python3.7 python3.7-dev \
  && apt-get install -y python3-pip \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3.7 python 

# requirements for building underlying packages when installing required python modules later 
# e.g., secp256k1 
RUN apt-get install -y build-essential pkg-config autoconf libtool libssl-dev libffi-dev libgmp-dev libsecp256k1-0 libsecp256k1-dev

# Required system tools 
RUN apt-get install -y git wget curl
# Additional system tools 
RUN apt-get install -y vim iputils-ping netcat iproute2 sudo

# get recent solc versions for testing
# https://github.com/ethereum/solidity/releases/
RUN cd /usr/local/bin \
  && wget -qO solc https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && wget -qO solc_5.4 https://github.com/ethereum/solidity/releases/download/v0.5.4/solc-static-linux \
  && wget -qO solc_5.10 https://github.com/ethereum/solidity/releases/download/v0.5.10/solc-static-linux \
  && wget -qO solc_5.12 https://github.com/ethereum/solidity/releases/download/v0.5.12/solc-static-linux \
  && cp solc_5.4 solc \
  && chmod 755 solc*

# get current geth version from here for debug tools etc (not mandatory):
# https://geth.ethereum.org/downloads/#dl_stable_linux
RUN cd /tmp/ \
  && wget -q https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.9.6-bd059680.tar.gz \
  && tar -xzf /tmp/geth-alltools-linux-amd64-1.9.6-bd059680.tar.gz \
  && cp /tmp/geth-alltools-linux-amd64-1.9.6-bd059680/* /usr/local/bin

# upgrade pip and install requirements for python3.7 which have been previously added to /smartcode
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install -r requirements.txt

# port jupyter
EXPOSE 8888

# change final user
USER $UNAME

# Run jupyter per default:
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "8888"]

