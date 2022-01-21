---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

# Connectivity experiments using Enclave and Docker

This page contains a growing collection of **non-production** Docker scripts for various containerised applications that can be spun up quickly and accessed securely using Enclave for experiments and proof of concept projects.

> The Docker scripts on this page are intended to showcase and demonstrate how Enclave can interact with many different types of application for proof of concept projects. **These Docker scripts are not fit for use in production environments.**

## Working with Docker

### Install Docker

```bash
$ sudo apt-get update
$ sudo apt-get install docker.io docker-compose -y
```

### Controlling Docker Containers

List running Docker containers

```bash
$ sudo docker ps
```

## Secure Network File Server

This script prepares and runs a Docker container which builds a secure SAMBA file server with anonymous read/write permissions to a `/share` directory on the host operating system. Install Enclave into the container to add secure remote access to the network share.

```bash
$ sudo mkdir /share
$ sudo chmod -R 777 /share/
$ sudo docker run -p 139:139 -p 445:445 -p 137:137/udp -p 138:138/udp -v /share:/share -d sixeyed/samba -s "share;/share;yes;no;yes;all"
```

## Self-hosted Slack alternative

This script and runs a Docker container that deploys an instance of Mattermost: an open source and self-hosted alternative to Slack. Install Enclave into the container to add secure remote access your new open source messaging platform.

```bash
$ sudo docker run --name mattermost-preview -d --publish 80:8065 mattermost/mattermost-preview
```

Once the Mattermost container is running and Enclave is installed, access the Mattermost webserver in your browser using either the Enclave hostname or Enclave IP address assigned to the container.

1. Allow other parties with access to this container (either directly through the local network interface, or remotely via Enclave) to self-register for an account on this Mattermost instance. Navigate to `System Console` > `Signup` > `Enable Open Server`.

1. Create a new team on your Mattermost instance and allow any user with an account to join this team `Team Settings` > `Allow any user with an account on this server to join this team` > `Select Yes`.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>