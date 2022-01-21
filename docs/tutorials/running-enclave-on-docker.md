---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

# How to run Enclave inside a Docker container

> **Note:** This guide is written for Docker Community Edition 19.03.5.

## Install Docker

To follow this guide, you will need to have Docker already installed on your local system. This guide is based on running Docker (version 19.03.5) on a fresh installation of Ubuntu 18.04 LTS.

```
$ sudo apt update
$ sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
$ sudo apt update
$ sudo apt install docker-ce -y
```

## Download and build the Docker image

Obtain the latest docker file URL from the [Portal](https://portal.enclave.io), and with the Dockerfile downloaded, build the Docker image.

```
$ sudo docker build --no-cache -t enclave .
```

## Run the container interactively

Run the container interactively to license and start Enclave. Passing `--privileged` and `--net=host` arguments allows docker to present the tap0 interface created by Enclave inside the container out to the host operating system, without installing Enclave onto the host.

```
$ sudo docker run -it --privileged --net=host enclave
```

From within the container, license Enclave using a valid key provisioned in the [Portal](https://portal.enclave.io).

```
# enclave license 00000-00000-00000-00000-00000
```

Next, start Enclave running as a background process, detached from the terminal and shielded from the HUP signal that warns dependent processes of logout by using `nohup` to run Enclave. This backgrounds Enclave and allows us to continue using the terminal.

```
# nohup enclave start &
```

Now Enclave is running in the background, detached from the terminal you can check the `status` of Enclave, and `add` peers as necessary.

```
# enclave status
# enclave add ABC
```

> **Tip:** To detach Docker from the tty of an interactive container without exiting the shell, use the escape sequence `Ctrl-p` + `Ctrl-q`. This will switch a container running in interactive mode into daemon mode and release the terminal back to the host operating system.

While this container is running, your host operating system will be able to communicate with connected peers. Use this container to administer the Enclave network.

## Use tap0 on the host operating system

Using `ifconfig` check to see if the `tap0` interface is present on the host adapter, any applications on the host operating system will transparently be able to communicate with partners on the Enclave network. Use `docker ps` and `docker attach` to reconnect to the Enclave container and administer the network as required.

```
$ ifconfig

tap0: flags=67<UP,BROADCAST,RUNNING>  mtu 2800
        inet 100.90.154.224  netmask 255.192.0.0  broadcast 0.0.0.0
        inet6 fe80::605f:16ff:fe90:20a8  prefixlen 64  scopeid 0x20<link>
        ether 62:5f:16:90:20:a8  txqueuelen 1000  (Ethernet)
        RX packets 98  bytes 17732 (17.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 18  bytes 1412 (1.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>