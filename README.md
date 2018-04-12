# ubuntu-1604-wine
Docker Container Image of Ubuntu 16.04 with SSHD, XFCE, VNC, as well as WINE and more designed for AWS ECS publishing


# My notes on setting it up


# Basic Steps:

* Modify Docker file to meet your needs and use your labels
    * You can choose weather to build this image from scratch or as an addon to the u16vnc image if you had already built that.
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
    * Note that privileged mode is only required if you want to use network tools since ecs does not support NET_ADMIN
    * The volumes line mounts as AWS EFS (NFS) file system to allow for external file storage
        * This requires you to have an AWS EFS share created and configured on your AWS ECS instances

```yaml
version: '2'
services:
  u16winevnc:
    # Image refers to the AWS ECS repository image to be used, change to yours
    image: 000000000000.dkr.ecr.us-west-2.amazonaws.com/alt_bier/u16winevnc:latest
    # Privileged mode is only required if you want to use network tools
    privileged: true
    # 1024 cpu_shares = 1 vCPU (256 = 0.25 vCPU)
    cpu_shares: 256
    # mem_limit is an integer indicating bytes in binary (1G=2^30=1073741824, 512M=2^29=536870912)
    mem_limit: 536870912
    # Ports to be exposed if format host:container
    ports:
     - "522:22/tcp"
     - "5901:5901/tcp"
     - "6901:6901/tcp"
    # This mounts an AWS EFS file system
    volumes:
     - "/efs:/efs"
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
* How to install and configure WINE
    * https://wiki.winehq.org/Ubuntu
* AWS Elastic Container Service (ECS)
    * https://aws.amazon.com/ecs/
* Manage Amazon ECS tasks with docker-compose-style commands on an ECS cluster
    * https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cmd-ecs-cli-compose.html
* Using AWS EFS Filesystems with AWS ECS
    * https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_efs.html



