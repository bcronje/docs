---
beta-feature: true
---

> This is a feature is in beta and may be subject to change in future versions. While in beta, this feature doesn't include API management endpoints or Portal control and must be manually configured. This page will be updated as the feature enters general availability.

## Introduction

Enclave works best when the agent is installed directly on every client, server, VM and container in your organisation. That way, Enclave can apply Zero Trust Network Access controls between systems, traffic is end-to-end encrypted, and enrolled systems can take full advantage of the features of the Enclave overlay network.

However, in some situations, you can’t or might not want to install Enclave on all systems:

- Embedded systems, like firewalls, webcams or printers which don’t run third party software
- Domain controllers where [two or more network interfaces][dual-nic-domain-controller] are not recommended
- Large numbers of devices in a single subnet, like a single AWS VPC
- Accessing cloud native services, like AWS RDS, which also don't run third party software
- On networks where the physical infrastructure is not allowed to be changed
- Accessing legacy systems which are too old to run, or are incompatible, with the agent 

In these cases, you can set up an “Exit Node” to access devices not running Enclave, from a system in the same subnet which is. Exit nodes act as a gateway, moving traffic from your Enclave peers into your physical subnet and back again.

## Limitations

A system functioning as an Exit Node can route data to a subnet of any size. You can provide routes to subnets as large as a `/0` or as small as a single IP address (`/32`) as you find necessary for appropriate segmentation.

The same Exit Node system can provide routes to multiple subnets if that system has a network interface and routes to the relevant subnet(s).

Currently, we only support Linux systems as exit nodes. We plan to support this feature on Windows and macOS in the future.

To configure an Exit Node on a fresh Linux system, follow these steps:

## Step 1: Install your exit node

[Download and install][download-linux] Enclave onto your Exit Node system and provide an enrolment key to join it to your account. We support a variety of Linux distros.

## Step 2: Setup your exit node

We'll need to edit a configuration file, so stop Enclave on your Exit Node. You can use `sudo enclave stop` or `sudo systemctl stop enclave`.

Now Enclave is stopped, use the editor of your choice to open the default Enclave configuration file `Universe.profile`.

```
$ sudo nano /etc/enclave/profiles/Universe.profile
```

At the bottom of the JSON file you'll see an empty property: `"ExitNode": {}`.

![Configure the ExitNode property in Universe.profile](/images/management/exit-nodes/universe-profile.png "Configure the ExitNode property")

Add the `ProvidesRoutes` array as shown below. Replace the subnets in the example below with the right ones for your network. You can add one, or more IPv4 subnets in CIDR notation.

```json
"ExitNode": {
    "ProvidesRoutes": [
        "172.26.0.0/20",
        "172.84.0.0/20"
    ]
} 
```

Save this file and exit your text editor. The Exit Node feature also requires IP forwarding to be enabled in the Linux kernel. Enable it as follows:

```bash
$ sudo sysctl -w net.ipv4.ip_forward=1
$ sudo sysctl -p
```

Next you'll need to configure iptables to forward traffic originating from your Exit Node's Enclave overlay network subnet (100.64.0.0/10 by default) out to your local subnet(s).

You'll need to replace the `-d` argument with your own subnet (change `172.26.0.0/20` in this example) and change the `--to` address to be the IPv4 address of your Exit Node in its local subnet, so change `172.26.0.3` in the example below. 

```
$ sudo iptables -t nat -A POSTROUTING -s 100.64.0.0/10 -d 172.26.0.0/20 -j SNAT --to 172.26.0.3
```

Add one postrouting rule as shown above for each subnet you're planning to advertise from this Exit Node.

Now you've configured the Exit Node, you can restart Enclave. You can use `sudo enclave start` or `sudo systemctl start enclave`.

Lastly, run `enclave status` and make a note of the Exit Node's `Local identity` as you'll need this later. Each identity is unique to every system. Ours was `G982V`. Yours will be different. 

## Step 3: Setup any other systems

We'll assume you already have Enclave installed on other systems. Login to one of your systems which is going to send traffic to the subnet provided by your Exit Node. Enclave can use the subnets provided by the Exit Node from any of our supported operating systems (currently Windows, macOS and Linux).

During the beta, without centralised management available, we'll need to manually configure each system that needs to access the subnet(s) provided by the Exit Node. We'll have to tell each system which of it's peers is providing the route, and what those subnets are.

Let's get started.

We'll need to edit each system's `Universe.profile` configuration file, so stop Enclave on each system. You can use `sudo enclave stop` or `sudo systemctl stop enclave`. Now Enclave is stopped, use the editor of your choice to open the default Enclave configuration file.

Just like before, you'll notice an empty `"ExitNode": {}` property at the bottom of the JSON file. This time we'll be adding `AvailableRoutes`. 

```bash
"ExitNode": {
    "AvailableRoutes": {
        "G982V": [
            "172.26.0.0/20"
        ]
    }
}
```
You'll need to replace the identity `G982V` with your own Exit Node's identity. You'll also need to replace the subnet we've used here with your own (`172.16.0.0/24` in this example). 

Now this system knows which peer it should route `172.16.0.0/24` traffic. You can also configure your system to use multiple Exit Nodes, as shown below.  

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
Now you've configured this system to use your Exit Node, you can restart Enclave. You can use `sudo enclave start` or `sudo systemctl start enclave`. Now that you've configured the `AvailableRoutes` property, Enclave will automatically adjust the local routing table for you.

## Step 4: Connect it all together

Make sure your clients can talk to the Exit Node using Enclave, we suggest [tagging](/getting-started/attach-tags/) your exit node as `exit-node` and creating a [policy](getting-started/define-policy/) which allows your clients to access your `exit-node`.

## Step 5: Verify the connection

Check that you can ping your new Exit Node’s Enclave virtual IP address from your client machine. You can find the Enclave IP address of your Exit Node by running `enclave status` on either system once they are connected.

You should also notice, on your client system that the route you configured is listed under the appropriate peer, as illustrated below.

![ExitNode JSON property in Universe.profile](/images/management/exit-nodes/enclave-status-on-client.png "ExitNode property")

If you can ping the Exit Node via Enclave and your local system is showing `172.26.0.0/20` (or your equivalent subnet) as the `Exit node for` under the correct peer, you should be able to start sending traffic directly into that subnet via the Exit Node.

## Step 6: Use your exit node

If the any of the host-based firewalls on systems in the adjacent subnet(s) to your Exit Node allow it, you may be able to send pings as test of end-to-end connectivity. 

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