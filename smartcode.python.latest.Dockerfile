# Dockerfile for smart contract development
# with web3 for python 3.7

# Docker file for python in ubuntu
FROM ubuntu:devel

WORKDIR /smartcode

COPY ./smartcode.python.latest.requirements.txt /smartcode/requirements.txt
COPY ./smartcode.python.latest.requirements_2.7.txt /smartcode/requirements_2.7.txt

# Add a user given as build argument
ARG UNAME=smartcode
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# update and upgrade
RUN apt-get update 
RUN apt-get dist-upgrade -y

# basic python2.7 setup for backward compatability 
RUN apt-get install -y python2.7 
RUN apt-get install -y python-pip

# basic python3.7 setup
# Notes
# * python3-pip because dedicated python3.7-pip was not yet available
#		but you can install modules for 3.7 by invoking it like this
#   python3.7 -m pip --version    
RUN apt-get install -y python3.7 python3.7-dev \
  && apt-get install -y python3-pip \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3.7 python \
  && python3.7 -m pip install --upgrade pip 

# requirements for building underlying packages
# e.g., secp256k1 
RUN apt-get install -y build-essential pkg-config autoconf libtool libssl-dev libffi-dev libgmp-dev libsecp256k1-0 libsecp256k1-dev

# Required system tools 
RUN apt-get install -y git wget
# Additional system tools 
RUN apt-get install -y vim iputils-ping netcat iproute2

# get recent solc version
# currently the latest version starting with 4.something
RUN cd /usr/local/bin \
  && wget -qO solc https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && chmod 755 solc

# get current geth version
RUN cd /tmp/ \
  && wget -q https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.8.19-dae82f09.tar.gz \
  && tar -xzf /tmp/geth-alltools-linux-amd64-1.8.19-dae82f09.tar.gz \
  && cp /tmp/geth-alltools-linux-amd64-1.8.19-dae82f09/* /usr/local/bin 

# upgrade pip and install requirements for python3.7 which have been previously added to /smartcode
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install -r requirements.txt

# upgrade pip and install requirements for python2.7
RUN python2.7 -m pip install --upgrade pip
RUN python2.7 -m pip install -r requirements_2.7.txt

# there might be issues due to parallel installation of two jupyter kernels:
# https://github.com/jupyter/jupyter/issues/270
# This might resolv if (or break something if files change)
COPY ./python2.7_kernel.json /usr/local/share/jupyter/kernels/python2/kernel.json
COPY ./python3.7_kernel.json /usr/local/share/jupyter/kernels/python3/kernel.json

# port jupyter
EXPOSE 8888

# change final user
USER $UNAME

# Run jupyter per default:
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "8888"]

