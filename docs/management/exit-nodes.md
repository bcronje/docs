---
beta-feature: true
---

> This feature is in beta and may be subject to change in future versions of Enclave. While in beta, this feature doesn't include API endpoints or Portal control and must be manually configured on each system. This page will be updated as the feature enters general availability.
>   
> If you have feedback on this feature, please let us know in one of our [community support](/community-support/) channels.

## Introduction

Enclave is designed to be installed directly on every client, server, cloud instance, virtual machine and container in your organisation. That way, Enclave can apply Zero Trust Network Access controls between systems, enforce fully enforce policy and provide end-to-end encryption.

However, in some situations, you can’t or might not want to install Enclave on all systems:

- On domain controllers where [two or more network interfaces][dual-nic-domain-controller] can be problematic
- On networks where the physical infrastructure is not allowed to be changed
- On embedded systems, like firewalls, webcams or printers which prohibit external software
- When accessing legacy systems which are too old to run, or are incompatible, with the agent 
- When accessing cloud native services like AWS RDS, which don't run third party software
- With large numbers of devices in a single subnet, like a single AWS VPC

Here, you can set up an “exit node” to access systems not running Enclave from another system in the same subnet which is. An exit node acts like a gateway, moving traffic from your Enclave peers into your physical subnet and back.

![Exit node topology](/images/management/exit-nodes/topology.png "Exit node topology")

## Prerequisites

Before you begin this guide, you’ll need an Enclave account set up with at least two devices enrolled. Read our [getting started guide](getting-started/installation/) if you need help with this.

Your Exit Node system must be running Linux. Currently, we only support Linux systems as exit nodes, but we plan to support this feature on Windows and macOS in the future.

## Limitations

A system functioning as an exit node can route data to a subnet of any size. You can provide routes to subnets as large as a `/0` or as small as a single IP address (`/32`) as you find necessary for appropriate segmentation.

The same exit node system can provide routes to multiple subnets if that system has a network interface and routes to the relevant subnet(s).

The present design of exit nodes allows an Enclave peer to reach into the locally subnet via an exit node, and for a device inside that subnet to respond to a request. However, Enclave will not allow unsolicited traffic from a device inside that local subnet to send unsolicited traffic into the Enclave overlay network. As an example, a home worker's laptop could exchange packets with a printer and domain controller in an office network via an exit node, but the printer and domain controller would be unable to initiate unsolicited connectivity to that home worker's laptop. This is because the overlay network between Enclave peers provides a level of trust that cannot be replicated on the unencrypted and unauthenticated physical network.

To configure an exit node on a Linux system installation, follow these steps:

## Step 1: Install your exit node

[Download and install][download-linux] Enclave onto the system which will be your exit node and provide an enrolment key to join it to your account. We support a variety of Linux distros.

## Step 2: Setup your exit node

You will need to edit an Enclave configuration file, so stop the Enclave process, you can use `sudo enclave stop` or `sudo systemctl stop enclave`. Now that Enclave is stopped, use the editor of your choice to open the default configuration file `Universe.profile`.

```
$ sudo nano /etc/enclave/profiles/Universe.profile
```

At the bottom of the JSON file you'll see an empty property called `"ExitNode": {}`.

![Configure the exit node property in Universe.profile](/images/management/exit-nodes/universe-profile.png "Configure the exit node property in Universe.profile")

As shown below, add a `ProvidesRoutes` array. Replace the subnets in the example below with the right ones for your network. You can add one, or more IPv4 subnets in CIDR notation. In this example we've added two subnets.

```json
"ExitNode": {
    "ProvidesRoutes": [
        "172.26.0.0/20",
        "172.84.0.0/20"
    ]
} 
```

Save this file and exit your text editor. The exit node feature also requires IP forwarding to be enabled in the Linux kernel. Enable it as follows:

```bash
$ sudo sysctl -w net.ipv4.ip_forward=1
$ sudo sysctl -p
```

Next, you'll need to configure iptables to forward traffic originating from the overlay network (100.64.0.0/10 by default) out to your local subnet(s).

You'll need to replace the `-d` argument below with your own subnet (i.e. change `172.26.0.0/20` in this example) and change the `--to` address to be the IPv4 address of your exit node in its local subnet, so also change `172.26.0.3` to match your network.

```
$ sudo iptables -t nat -A POSTROUTING -s 100.64.0.0/10 -d 172.26.0.0/20 -j SNAT --to 172.26.0.3
```

Add one source NAT postrouting rule as shown above for each subnet you're planning to advertise via this exit node.

Now you've configured the exit node, you can restart Enclave. You can use `sudo enclave start` or `sudo systemctl start enclave`.

Lastly, run `enclave status` and make a note of your exit node's `Local identity` as you will need this in the next step. Each identity is unique to each system. In our example, our exit node's identity was `G982V` but yours will be different. 

## Step 3: Setup any other systems

We'll assume you already have Enclave installed and enrolled on other systems in your account, if not you'll need to. Login to one of your other systems which will act as a client to the exit node and route traffic to one of the advertised subnets. Any supported operating system (currently Windows, macOS and Linux) can be setup to route traffic via your new exit node.

> During the beta, without centralised management available, you'll need to manually configure each system that needs to access the subnet(s) provided by the exit node. You'll need to tell each system which of its peers is providing the access to those subnets, and what those subnets are too.

Let's get started.

You'll need to edit the `Universe.profile` configuration file on each system, so make sure you stop Enclave using either `sudo enclave stop` or `sudo systemctl stop enclave`. Now Enclave is stopped, use the editor of your choice to open the default Enclave configuration file.


=== "Linux"

    On Linux this file is located at:

        /etc/enclave/profiles/Universe.profile

=== "Windows"

    On Windows this file is located at:
    
        C:\Program Files\Enclave Networks\Enclave\Agent\profiles\Universe.profile

=== "MacOS"

    On macOS this file is located in:
    
        /etc/enclave/profiles/Universe.profile


Just like in step 2, you'll notice an empty `"ExitNode": {}` property at the bottom of the JSON file.

This time we'll be adding `AvailableRoutes`. 

```bash
"ExitNode": {
    "AvailableRoutes": {
        "G982V": [
            "172.26.0.0/20"
        ]
    }
}
```

You'll need to replace the identity we've used (`G982V`) with your own exit node's identity that you made a note of at the end of step 2. You'll also need to replace the subnet we've used here with your own (i.e. `172.16.0.0/24` in this example). 

Now this system knows which peer it should route `172.16.0.0/24` traffic towards, you could also configure it to use multiple exit nodes for different subnets, as shown below.  

```bash
"ExitNode": {
    "AvailableRoutes": {
        "G982V": [
            "172.26.0.0/20",
            "172.84.0.0/20"
        ],
        "Q8QW8": [
            "192.168.0.0/24"
        ]
    }
}
```

Now you've configured this system to use your exit node, you can restart Enclave using `sudo enclave start` or `sudo systemctl start enclave`. Now that you've configured the `AvailableRoutes` property, Enclave will automatically adjust the local routing table for you.

## Step 4: Connect it all together

Make sure your client systems can talk to the exit node using Enclave. We suggest [tagging](/getting-started/attach-tags/) your exit node as `exit-node` (or similar) and creating a [policy](getting-started/define-policy/) which allows your clients to access your `exit-node` system.

## Step 5: Verify the connection

Check that you can ping your new exit node from your client machine, use the exit node's Enclave `Virtual address` (i.e. `100.64.69.156` in the example below). You can find the Enclave `Virtual address` of your exit node by running `enclave status` on either system once they are connected.

You should also notice in the output of the `enclave status` command on the client system(s) that any route(s) you've advertised via your exit node are listed under the appropriate peer, as shown below.

![Exit node JSON property in Universe.profile](/images/management/exit-nodes/enclave-status-on-client.png "Exit node JSON property in Universe.profile")

If you can ping the exit node (i.e. ping `100.64.0.70` in this example) via Enclave and your local system is showing `172.26.0.0/20` (or your equivalent subnet) as the `Exit node for` value against the correct peer, you should now be able to start sending traffic directly into that subnet via your new exit node.

## Step 6: Use your exit node

Now we know the exit node itself is reachable, try sending some traffic past the exit node to the subnet behind it. If the any of the host-based firewalls on systems not running Enclave in your subnet(s) adjacent to the exit node allow it, you may be able to send pings as test of end-to-end connectivity.

In the example below I've been able to send a ping from a Windows laptop in a coffee shop, via the Enclave exit node at `172.26.0.3` in the office out to a printer with an IP address of `172.26.0.250` in the local subnet.

```
C:\> ping 172.26.0.250

Pinging 172.26.0.250 with 32 bytes of data:
Reply from 172.26.0.250: bytes=32 time=29ms TTL=64
Reply from 172.26.0.250: bytes=32 time=30ms TTL=64
Reply from 172.26.0.250: bytes=32 time=29ms TTL=64
Reply from 172.26.0.250: bytes=32 time=38ms TTL=64

Ping statistics for 172.26.0.250:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 29ms, Maximum = 38ms, Average = 31ms
```

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or ask for help in our [community support](/community-support/) channels.

<small>Last updated Oct 23, 2021</small>

[dual-nic-domain-controller]: https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/unwanted-nic-registered-dns-mulithomed-dc
[download-linux]: https://docs.enclave.io/setup/linux/