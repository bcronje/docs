---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

# How to update Enclave on your Synology NAS drive

> **Note:** If you don't already have Enclave running on your Synology NAS drive you might be prefer to read our [how to securely access your Synology NAS drive with Enclave](/tutorials/how-to-securely-access-your-synology-nas-drive-with-enclave) tutorial.

If you're running Enclave on your Synology NAS using Docker, at some point you'll almost certainly want to update to the latest version of Enclave. This tutorial shows you how to upgrade your existing Docker container to run the latest version of Enclave without losing your enrolment certificate or Enclave system identity.

<br />

## 1. Stop the Enclave container

First, let's stop your existing Enclave container. **Note: If you're accessing the Synology NAS drive using an Enclave connection, stopping the container will disconnect you. Make sure you have an alternative route to access the NAS when updating Enclave.** 

The easiest way to stop the Enclave container on your Synology NAS drive is via the Docker app. Log into the Synology NAS drive web interface, navigate to the Main Menu and launch the `Docker` app. Go to the `Container` section, find the `enclave` container, and select `Action` > `Stop`. 

<br />



## 2. Download the latest image

Next, using the search box on the `Registry` tab of the Docker app, search for the `enclavenetworks/enclave` image download it from the container registry. If you're prompted to choose a tag, select `latest`. You may be interested to know that the Enclave images are hosted on [here](https://hub.docker.com/r/enclavenetworks/enclave) on the Docker hub website.

![Download the latest version of Enclave using the latest tag](/images/guides/synology-nas/synology-update-enclave-select-tag.png)

<br />



## 3. Wait for docker pull

Your Synology NAS is performing a `docker pull` in the background, wait for a system notification to let you know that this operation has completed successfully.

![Wait for you Synology NAS to complete the docker pull command](/images/guides/synology-nas/synology-update-enclave-docker-pull.png)

<br />



## 4. Create a new Enclave container

You'll need to create a new container to use the latest Enclave image, but not from scratch. You can take a short-cut here duplicate the settings from your existing Enclave container to create a new one. Navigate to the `Container` section of the Docker app, select the `enclave` container and then go to `Settings` > `Duplicate`.

We suggest temporarily naming your the new container `enclave-copy`. Click `Apply` to create it.

![Create a new Enclave container by duplicating the settings from your old container](/images/guides/synology-nas/synology-update-enclave-duplicate-settings.png)

<br />



## 5. Remove the original container

You don't need the original container anymore. Select the older `enclave` container and go to `Action` > `Delete`. You'll be reminded that deleting this container mean its data will be lost. The enrolled Enclave identity is stored in a Docker Volume which won't be affected by deleting the container, so it's safe to delete the original container. Click `Delete` to confirm.

<br />



## 6. Rename and Launch

Now you have a new container called `enclave-copy`. If you wish you can rename the container, now is a good time to do so — select it, click `Edit` and change the container name to `enclave`. All done. Click `Apply` and launch your new container running the latest version of Enclave.

![Rename your copied container before launching it](/images/guides/synology-nas/synology-update-enclave-rename-container.png)





<br />
<br />
<br />

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or ask for help in our [community support](/community-support/) channels.

<small>Last updated September 17, 2021</small>
