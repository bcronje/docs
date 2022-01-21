---
hide: navigation
---

<small>[Documentation](/) / [Tutorials](/tutorials)</small>

# Setting up Enclave on a Raspberry Pi

Follow these steps to install Enclave on your Raspberry Pi running Raspbian 10 (x64):

## 1. Install

Open the [download page](https://portal.enclave.io/) section of your account in the Enclave Portal and copy the download link to the setup script for your Raspberry Pi and run it on your device.

## 2. Enrol

Open the [Portal](https://portal.enclave.io/) and provision a new enrolment key for your Raspberry Pi if you need to. Alternatively, if an existing enrolment is available, make note of the enrolment key and use that to enrol the device.

Enrol the device. If you don't supply the enrolment key at the command line, Enclave will prompt you to enter the enrolment key.

```bash
$ sudo enclave enrol
```

## 3. Start

Start Enclave on the Raspberry Pi

```bash
$ sudo systemctl start enclave
```

## 4. Connect

Using Enclave Core, you must authorise a connection to other systems in order to build network connectivity. You will need to know the certificate name of each counterpart system.

In this example I will connect the Raspberry Pi to my office workstation so I can view its [Motion](https://motion-project.github.io/) camera feed remotely.

My workstation's certificate name is `72LVG` and on the Raspberry Pi I will authorise Enclave to allow connections with my workstation using the `add` command. The `-d` argument is a description (or friendly name) of this connection for future reference.

```bash
$ enclave add 72LVG
```

The workstation will need to mutually authorise the Raspberry Pi connection aswell, and so the workstation needs to know the certificate name of the Raspberry Pi. Run `enclave status` on the Raspberry Pi to find its local certificate name.

## 5. Verify

You can find your Raspberry Pi's new Enclave IP address and connectivity to other peers by:

* Checking the Portal
* Running `ifconfig tap0`
* Running `enclave status`

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>