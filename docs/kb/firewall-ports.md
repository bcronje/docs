---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# What firewall ports should I open to use Enclave?

Enclave is designed to work in as many environments as possible. You normally don't need to open firewall ports for Enclave to work. Enclave uses NAT traversal techniques to automatically establish peer-to-peer connectivity between devices without administrators needing to manipulate the underlying network.

However, when two devices are separated by certain kinds of [network address translation](#network-address-translation) (NAT) devices, it may not be possible for Enclave to build direct, peer-to-peer connections between those devices.

Your devices will still be able to connect and communicate with one other thanks to traffic relays, but relayed traffic can be suboptimal compared to direct connectivity in terms of latency and throughput.

If your network operates with an aggressive NAT configuration, you may consider opening firewall ports to help Enclave establish direct peer-to-peer connectivity. 

## What ports does Enclave use?

Enclave does not use a default port and instead randomises port selection each time it restarts. We generally discourage network configurations in which a fix port is required because it runs counter to the design principles behind Enclave, but sometimes it may be necessary to assign a specific port for Enclave to use.

### 1. Force Enclave to use a specific port number

To force Enclave to use a specific port number

1. Stop Enclave by running `enclave stop` and open the local Enclave configuration file (usually called `Universe.profile`) located in either `C:\Program Files\Enclave Networks\Enclave\Agent\profiles` or `/etc/enclave/profiles`
2. Change the value of `"LocalPort": 0` from `0` to the port number you wish to use. We suggest `47100`, but you can choose another if you prefer
3. Save the configuration file and restart Enclave by running `enclave start`

### 2. Configure your firewall

Ensure your devices can reach the Enclave control plane servers:

* Let your devices initiate TCP connections out to `*:443`

Ensure your devices can reach each other (assuming you've forced Enclave to use port `47100`):

* Let your devices initiate UDP connections from `:47100` to `*:*`

## Network Address Translation

Network devices which employ Symmetric NAT degrade VoIP, WebRTC and other protocols which aim to establish direct, peer-to-peer connectivity between hosts like Enclave. Prefer "Full Cone" or "Port Restricted Cone" NAT configurations. Symmetric NAT configurations cause NAT traversal to fail, preventing peer-to-peer connectivity.

* Don't use "symmetric" NAT, prefer "Full Cone" or "Port Restricted Cone" NAT configurations

---

<small>Last updated May 24, 2022</small>