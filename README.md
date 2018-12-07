Smart Contract CrashCourse
=======================

This is a tutorial on Smart Contracts in Ethereum using Ganache and Web3py.
This tutorial is is part of the [Cryptocurrencies lecture](https://tiss.tuwien.ac.at/course/courseDetails.xhtml?dswid=1923&dsrid=980&courseNr=192065&semester=2018W) at TU Wien.

The goal of the tutorial is it to give a gentle introduction to the fast changing and sometimes confusing Ethereum development environment.

* Client and Blockchain interaction
* Contract deployment
* Contract interaction
* Basics about contracts and Solidity

Setup
-----

Development environment setup and challenge environment setup will be based on docker containers. 
Therefore we strongly recommend a Linux based operating system as a base layer e.g., Ubuntu. 

There will be two docker containers:
* One container runs the blockchain client i.e., `ganache` or `geth`
* One container runs our custom development environment for the tutorial and the following project/exercise (`smartcode`) 

### 0. clone this repository
```
$ git clone https://github.com/kernoelpanic/sccc.git
```

### 1. install docker ###

Install docker according to your respective Linux distribution:

* https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1

### 2. install and build docker images ###
```
$ bash docker_build.sh
```

### 3. run containers ###
Start the `ganache` container:
```
$ bash docker_run_ganache.sh 
```

Start the `smartcode` development container:
```
$ bash docker_run_smartcode.sh
```

### 4. start working ###
Connect to the `jupyter` instance by opening a browser and enter the token printed in the console output.

[http://127.0.0.1:8888](http://127.0.0.1:8888)

You can also directly connect to the running `smartcode` container and get a shell in there
```
$ docker_exec_smartcode.sh
smartcode@smartcode:/smartcode$ 
```

### 5. Warmup exercises ###

#### I. Deploy the `warmup1.sol` contract ####

Deploy the contract on your local `ganache` chain and send it some funds such that its balance is non zero.

#### II. Make the `senderCheck` function fail ####

Think of a way that can make the `senderCheck` function return `false`.

#### III. Make the `fundsCheck` function fail ####

Think of a way that can make the `fundsCheck` function return `false`.

#### IV. Deploy the `SimpleENS/SimpleENS.sol` and write unit tests for all state changing functions ####

Look at the `test_greeter.py` file to get started.

#### V. Add events for all state changing functions ####

Add `event` and `emit` lines and also adapt your unit tests to see if the events are fired. 
