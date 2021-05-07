Deprication Warning ⚠
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
=====================

This repository has been merged into the *smartenv* repository which can be found here:

* https://github.com/kernoelpanic/smartenv/

The notebook with the crash course can be found here: 

* https://github.com/kernoelpanic/smartenv/blob/main/notebooks/course/sccc.ipynb

The *smartenv* repository also contains some challenges (without solutions) and
a tutorial on how to deploy them. 


Smart Contract Crash Course
===========================

This is a tutorial on Smart Contracts in Ethereum using Ganache and Web3py.
This tutorial is is part of the [Cryptocurrencies lecture](https://tiss.tuwien.ac.at/course/courseDetails.xhtml?dswid=1923&dsrid=980&courseNr=192065&semester=2018W) at TU Wien.

The goal of this tutorial is it to give a gentle introduction to the fast changing and sometimes confusing Ethereum development environment.

* Client and Blockchain interaction
* Contract deployment
* Contract interaction
* Basics about contracts and Solidity

Setup
-----

Development environment setup and challenge environment setup will be based on docker containers. 
Therefore we strongly recommend a Linux based operating system as a base layer e.g., Ubuntu. 

There will be two docker containers:
* One container runs the blockchain client i.e., `ganache`,`parity` or `geth`
* One container runs our custom development environment for the tutorial and the following project/exercise (`smartcode`) 

### 0. clone this repository
```bash
$ git clone https://github.com/kernoelpanic/sccc.git
```

### 1. install docker ###

Install docker according to your respective Linux distribution:

* https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1

### 2. install and build docker images ###
```bash
$ bash docker_build.sh
```

### 3. run containers ###
Start the `ganache` container:
```bash
$ bash docker_run_ganache.sh 
```

Start the `smartcode` development container:
```bash
$ bash docker_run_smartcode.sh
```

### 4. start working ###
Connect to the `jupyter` instance by opening a browser and enter the token printed in the console output.

[http://127.0.0.1:8888](http://127.0.0.1:8888)

You can also directly connect to the running `smartcode` container and get a shell in there
```bash
$ bash docker_exec_smartcode.sh
smartcode@smartcode:/smartcode$ 
```

If you want to debug something related to the docker setup, and for example not start jupyter notebook right away but still look around in the container, possibly as root, use this script to do so:
```bash
$ bash docker_debug_smartcode.sh 8887 8887 0
```



## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/NStifter"><img src="https://avatars.githubusercontent.com/u/16758029?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nicholas Stifter</b></sub></a><br /><a href="https://github.com/kernoelpanic/sccc/commits?author=NStifter" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!