---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

# How to update Enclave on your Synology NAS drive

Last Updated: September 17, 2021

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














Synology are market leaders in network attached storage devices, perfect for home or small business use. Enclave helps you easily build safe, secure and private network connectivity without the hassle of configuring firewalls and VPNs, or needing to manage IP addresses, subnets, ACLs, NAT, routing tables, certificates and secret keys.

In this article we will show you how to easily provide private remote access to your Synology NAS drive without needing to open ports or setup a VPN server, darkening your network to third parties by installing Enclave.

Before you begin, you will need:

* An Enclave account (Register [here](https://portal.enclave.io/register), for free)
* A Synology NAS drive running at least [DSM 7.0](https://www.synology.com/en-uk/beta/DSM70Beta) (currently in Beta)
* Administrative access to your Synology NAS drive

When setup, Enclave will be running inside a Docker container on your Synology NAS drive. At the time of writing, Docker can only be installed on devices from the Synology Plus Series product line (not the Value Series) so please check to see if your system is a [supported model](#supported-models).

![Our Synology NAS drive running DSM 7.0 Beta](/images/guides/synology-nas/synology-info-center.png)

The Synology NAS allows administrators to fully own their devices, enabling SSH and dropping into a root bash prompt on the DSM software, Synology's Linux-based operating system.

Okay, lets get started.

> If you have opened administrative access ports on your Synology NAS drive to the public Internet (default ports are 5000, 5001 and 22 for SSH) you should re-consider if they really need to be open and close those ports if not. They are the default HTTP and HTTPS web server ports for Synology DSM and allow access to the administration console.

<br />



## 1. Enable SSH access to your Synology NAS drive

For Enclave to create a virtual network interface, we'll need to ensure that the `tun` kernel module is installed and enabled on the device. We do this by enabling and connecting into the device via SSH. Open the `Control Panel`, navigate to `Terminal & SNMP` and enable the SSH service. 

![Enable SSH access to your Synology NAS drive](/images/guides/synology-nas/synology-enable-ssh.png)

<br />



## 2. Install the TUN kernel module

With SSH enabled, log into your NAS using the _admin_ account and check to see if the `tun` kernel module is installed and enabled.

```bash
$ lsmod | grep -w tun
```

If `lsmod` returns no results, you'll need to use `insmod` to install it.

```bash
$ sudo insmod /lib/modules/tun.ko
```

Now check `lsmod` again, you should see `tun` module is now loaded:

```
tun                    19133  0
```

![Install the TUN kernel module](/images/guides/synology-nas/synology-insmod-tun.png)

> We don't need SSH access any more, if you're not going to use it again please go back and disable the SSH service in the DSM Control Panel.

This was not a permanent change, the module will be unloaded the next time the system reboots, so lets create a script which can be scheduled to run on start-up which will re-install `tun.ko` at boot.

- Switch to root

   ```
   $ sudo su -
   ```

- Create the following script on your Synology file system by typing `vim /volume1/enable-tun.sh`

  ```
  #!/bin/sh

  if ( [ ! -c /dev/net/tun ] ); then
     if ( [ ! -d /dev/net ] ); then
        mkdir -m 755 /dev/net
     fi
     mknod /dev/net/tun c 10 200
  fi

  if ( !(lsmod | grep -q "^tun\s") ); then
     insmod /lib/modules/tun.ko
  fi
  ```

- Save the file with `[escape]` followed by the keys `:wq!`

- Mark the file as executable 

   ```
   chmod +x /volume1/enable-tun.sh
   ```

- Now create a scheduled task to run this script on start-up: Log in to your Synology NAS drive web interface, go to **Control Panel** > **Task Scheduler** and create a new `User-defined script` as a `Triggered Task`. Name the task `Enable TUN`, set the user to be `root` and the event as `Boot-up`. Then, in the `Task Settings` tab enter `bash /volume1/enable-tun.sh` as the User-defined script and hit OK. To test if the script works, after restarting your NAS log back into SSH and run `lsmod | grep -w tun` to check that the TUN module was successfully re-loaded.

<br />



## 3. Install Docker

The easiest way to install Docker on your Synology NAS drive is via the DSM package manager. Navigate to the `Package Center` and install Docker.

![Install Docker](/images/guides/synology-nas/synology-docker-package.png)

<br />



## 4. Download Enclave from the Docker Registry

Using the search box on the `Registry` tab of the Docker package, search for `enclave` and download the `enclavenetworks/enclave` image from the container registry. The Enclave Docker image hosted on [Docker hub](https://hub.docker.com/r/enclavenetworks/enclave).

![Download Enclave from the Docker Registry](/images/guides/synology-nas/synology-docker-registry.png)

<br />



## 5. Launch an Enclave container

Once the Enclave image is downloaded, the `Launch` button (shown below) in the `Image` tab will become available, click this.

![Download Enclave from the Docker Container Registry](/images/guides/synology-nas/synology-docker-image.png)

Now we are ready to setup the Enclave container. First, give the container a name, we've used `enclave`. Also need to be sure to check `Execute container using high privilege`, this causes DSM to pass the `--privileged` to Docker, which effectively enables the container to request `--cap-add NET_ADMIN` (Perform various network-related operations) and `--device /dev/net/tun` (Allows devices to run inside the container).

![Configure Docker Container](/images/guides/synology-nas/synology-docker-create-container.png)

Before clicking `Next`, open the `Advanced Settings` dialog.

* Under the `Advanced Settings` tab

   * Select `Enable auto-restart`

* Under the `Volume` tab

   * Select `Add Folder`. Create a mount path to `/etc/enclave/profiles` in the `docker` directory on your DiskStation. This is where Enclave will write its configuration file, private keys, and certificates to persist between reboots.

      ![Create a volume for Enclave configuration data](/images/guides/synology-nas/synology-docker-container-volume-settings.png)

* Under the `Network` tab

   * Select the checkbox to `Use the same network as Docker host`. This will allow you to access the Synology NAS drive via the Enclave network.

* Under the `Environment` tab

   * Define a new Environment Variable called `ENCLAVE_ENROLMENT_KEY` and set its value to a valid (and enabled) enrolment key from your Enclave account. Be careful not to include whitespace!

      ![Configure an enrolment key](/images/guides/synology-nas/synology-docker-container-enrolment-key.png)

      This Enrolment key is only used the first time Enclave runs. When Enclave has successfully started once and written a profile to disk, it is safe to remove this environment variable.

      > Enrolment keys are available from the [Enclave Portal](https://portal.enclave.io/) and determine which systems can register to your Enclave account, so we recommend that you **keep them secret**.

   * Leave the `Execution Command` set to the default value of `run` and click Apply.

<br />

Congratulations! You've finished configuring your container, click `Done` to Launch.

   ![Launch the Enclave Docker Container](/images/guides/synology-nas/synology-docker-launch-container.png)

<br />



## 6. Connect to the NAS with Enclave

Your Enclave container is starting up and will enrol to your account, within 1 or 2 seconds your Enclave container will be happily humming away in the background. Let's create a connection to another system running Enclave.

From the Docker package, go to the `Container` tab, select the Enclave container you've just created and open the container `Details` pane. Here you can see CPU usage, RAM usage, container uptime and other information. 

Move to the `Terminal` tab and click on the `Create` button to drop into a bash shell inside the container, from here you can work with and manipulate Enclave as normal using the CLI.

![Output from Enclave Status command](/images/guides/synology-nas/synology-docker-enclave-status.png)

First, use the `status` verb to check on the Enclave process and view your container's Local Identity. The container will also be visible as a newly connected system in the [Enclave Portal](https://portal.enclave.io).

```
# enclave status
```

Now you know the Local Identity of your container, you can authorise other systems to talk to your container by adding their identities, and visa versa.

```
# enclave add 4Y68W -d "Build server"
# enclave add R89XQ -d "Windows 10 laptop"
# enclave add K5W2Q -d "Jane's macbook"
```

For more information about how to use the CLI, or to learn more about Identities and how Enclave builds connections, please see our [documentation](https://docs.enclave.io/).

Now you've added some connections, be sure to check the [DNS forwarding](https://docs.enclave.io/kb/how-to-configure-dns-forwarding-on-linux.html) is enabled on any peers which you're connected to so they can access your Synology NAS drive using a friendly DNS hostname like `diskstation.enclave`.

Welcome to your own personal (dark) Internet!

<br />
<br />
<br />

# <a name="supported-models"></a> Supported Models

This tutorial requires Docker to be installed on your Synology NAS drive which, at the time of writing, only runs on Synology NAS drives from the Plus Series product line (not the Value Series). Please see the [Docker](https://www.synology.com/en-uk/dsm/packages/Docker) package for an up to date list of supported models.

| Series | Supported Models |
|---|---|
| 21 series | `RS1221RP+`, `RS1221+`, `DS1821+`, `DS1621xs+`, `DS1621+`, `DVA3221` |
| 20 series | `FS6400`, `FS3600`, `FS3400`, `RS820RP+`, `RS820+`, `DS920+`, `DS720+`, `DS620slim`, `DS420+`, `DS220+`, `DS1520+`, `SA3600`, `SA3400`, `SA3200D` |
| 19 series | `RS1619xs+`, `RS1219+`, `DS2419+`, `DS1819+`, `DS1019+`, `DVA3219`
| 18 series | `FS1018`, `RS3618xs`, `RS818RP+`, `RS818+`, `RS2818RP+`, `RS2418RP+`, `RS2418+`, `DS3018xs`, `DS918+`, `DS718+`, `DS218+`, `DS1618+`
| 17 series | `FS3017`, `FS2017`, `RS3617RPxs`, `RS3617xs`, `RS4017xs+`, `RS3617xs+`, `RS18017xs+`, `DS3617xs`, `DS1817+`, `DS1517+`
| 16 series | `RS2416RP+`, `RS2416+`, `RS18016xs+`, `DS916+`, `DS716+II`, `DS716+`, `DS216+II`, `DS216+`
| 15 series | `RS815RP+`, `RS815+`, `RC18015xs+`, `DS3615xs`, `DS415+`, `DS2415+`, `DS1815+`, `DS1515+`
| 14 series | `RS3614RPxs`, `RS3614xs`, `RS814RP+`, `RS814+`, `RS3614xs+`, `RS2414RP+`, `RS2414+`
| 13 series | `RS3413xs+`, `RS10613xs+`, `DS713+`, `DS2413+`, `DS1813+`, `DS1513+`
| 12 series | `RS3412RPxs`, `RS3412xs`, `RS812RP+`, `RS812+`, `RS2212RP+`, `RS2212+`, `DS3612xs`, `DS712+`, `DS412+`, `DS1812+`, `DS1512+`
| 11 series | `RS3411RPxs`, `RS3411xs`, `RS2211RP+`, `RS2211+`, `DS3611xs`, `DS411+II`, `DS411+`, `DS2411+`, `DS1511+`

<br />
<br />
<br />

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or ask for help in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>