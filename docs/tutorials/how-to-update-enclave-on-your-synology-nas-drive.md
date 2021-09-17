---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

> **Note:** If you don't already have Enclave running on your Synology NAS drive you might be prefer to read our [How to securely access your Synology NAS drive with Enclave](/tutorials/how-to-securely-access-your-synology-nas-drive-with-enclave) tutorial.

# How to update Enclave on your Synology NAS drive

If you're running Enclave on your Synology NAS using Docker, at some point you'll almost certainly want to update to the latest version of Enclave. This tutorial shows you how to upgrade your existing Docker container to run the latest version of Enclave without loosing your enrolment certificate or Enclave system identity.

<br />

## 1. Stop your existing Enclave container

First, let's stop your existing Enclave container. **Note: If you're accessing the Synology NAS drive using an Enclave connection, stopping the container will disconnect you. Make sure you have an alternative route to access the NAS when updating Enclave.** 

The easiest way to stop the Docker Enclave Container on your Synology NAS drive is via Docker package. Log into the NAS, navigate to the Main Menu and launch the Docker app. Go to the `Container` section, find the `enclave` container and select `Action` > `Stop`. 

<br />



## 2. Download the latest version of Enclave from the Docker Registry

Next, Using the search box on the `Registry` tab of the Docker package, search for `enclave` and download the `enclavenetworks/enclave` image from the container registry. The Enclave Docker image hosted on [Docker hub](https://hub.docker.com/r/enclavenetworks/enclave). If you're prompted to choose a tag, select `latest`.

![Download the latest version of Enclave using the latest tag](/images/guides/synology-nas/synology-update-enclave-select-tag.png)

<br />



## 3. Wait for the system notification that the download has completed

Your Synology NAS is performing a `docker pull` in the background, wait for the system notification to let you know that this operation has completed.

![Wait for you Synology NAS to complete the docker pull command](/images/guides/synology-nas/synology-update-enclave-docker-pull.png)

<br />



## 4. Create a new Enclave container

You'll need to create a new container to use the latest Enclave image, but you can take a short-cut here and duplicate the settings from your existing Enclave container. Navigate to that `Container` section, select the `enclave` container and then goto `Settings` > `Duplicate`.

We suggest temporarily naming your the new container `enclave-copy`. Click apply to create it.

![Create a new Enclave container by duplicating the settings from your old container](/images/guides/synology-nas/synology-update-enclave-duplicate-settings.png)

<br />



## 5. Remove the old container

You don't need the old container any more. Select the older `enclave` container and go to `Action` > `Delete`. You'll be reminded that deleting this container mean its data will be lost. The container is safe to delete, the enrolled Enclave identity is stored in a Docker Volume which won't be affected by deleting the container. Click `Delete` to confirm.

<br />



## 6. Rename the new container and Launch

Now you have a new container called `enclave-copy` using the latest version of Enclave, if you wish you can rename the container by selecting it, click `Edit` and change the container name to `enclave`. Click apply and launch your new container running the latest version of Enclave.

![Rename your copied container before launching it](/images/guides/synology-nas/synology-update-enclave-rename-container.png)





<br />
<br />
<br />

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or ask for help in our [community support](/community-support/) channels.

<small>Last updated September 17, 2021</small>
