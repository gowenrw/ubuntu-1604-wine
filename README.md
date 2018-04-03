# ubuntu-1604-wine
Docker Container Image of Ubuntu 16.04 with SSHD, XFCE, VNC, as well as WINE and more designed for AWS ECS publishing


# My notes on setting it up


# Basic Steps:

* Modify Docker file to meet your needs and use your labels
* Modify Makefile to meet your needs
* make build


# Push the image to AWS

* Below is the command I used to push the image to my AWS ECS Repository. 
    * You will need to modify this to the name of the AWS ECS repository you are using.

```bash
ecs-cli push alt_bier/u16winevnc
```


# Use docker-compose to create/manage the AWS ECS service

## Create the ecs-cli compose configuration file and start the service

* Add the service in u16winevnc.yml
    * Change the image name to your AWS ECS Repository instead of the one listed here
    * Modify cpu/mem limits and exposed ports as needed.  
        * As shown below it will opens all 3 ports and implement hard limits of 0.25 vCPU and 512M RAM.
        * 1024 cpu_shares = 1 vCPU (256 = 0.25 vCPU)
        * mem_limit is an integer indicating bytes in binary (1G=2^30=1073741824, 512M=2^29=536870912)
    * Note that privileged mode is required to allow services to modify the network settings since ecs does not support NET_ADMIN

```yaml
version: '2'
services:
  u16winevnc:
    image: 008884162899.dkr.ecr.us-west-2.amazonaws.com/alt_bier/u16winevnc:latest
    privileged: true
    cpu_shares: 256
    mem_limit: 536870912
    ports:
     - "522:22/tcp"
     - "5901:5901/tcp"
     - "6901:6901/tcp"
```


* Push the service into aws ecs and start the service

```bash
ecs-cli compose --file u16winevnc.yml --project-name u16winevnc up
```

# REFERENCE

* Example on setting up SSHD in a container
    * https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container
* Example on setting up VNC in a container
    * https://github.com/ConSol/docker-headless-vnc-container


