---
hide: toc
---

# What is Enclave?

Enclave connects all of your computers, servers, cloud instances and containers across any infrastructure with secure private networks. Whether you're working in a multi-cloud, remote access or third party integration scenario, Enclave gives you predictable private connectivity that just works.

It's like a VPN, but without the VPN server. Enclave networks are built on strict policy controls where knowledge of participating systems is provided on a need-to-know basis. All network members must successfully authenticate using digital certificates and connections can only be established with supporting policy.

|                        | VPN                                                                                                           | Enclave                                                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Serverless             | ❌ **VPN Server**<br />Hub and spoke architecture                                                              | ✅ **Serverless**<br />Peers connect directly using UDP/TCP hole punching                                                |
| On-demand connectivity | ❌ **Always on**<br />Tunnel is either on or off                                                               | ✅ **On-demand**<br />Tunnels are per-peer, and don't need to be always on                                               |
| Unreachable network    | ❌ **Discoverable**<br />VPN servers require open ports<br />(e.g. udp/500, tcp/443, udp/1194)                 | ✅ **Unreachable**<br />Outbound only traffic. No open ports or ingress<br />traffic, firewalls can be completely closed |
| Dynamic IP tolerant    | ❌ **Site-to-site VPNs require ACLs to isolate**<br />Client-to-site requires advanced IP knowledge to isolate | ✅ **Works with dynamic IPs**<br />You don't care where the other side is ahead of time                                  |
| Low-ops                | ❌ **Complex deployment**<br />Segmenting is hard, configuration is complex                                    | ✅ **Low-ops deployment**<br />Works on the network you've already got, no changes                                       |
| Static IP address      | ❌ DHCP<br />Reservations for static IP                                                                        | ✅ **Static IP**<br />Private static IP addresses "out of the box"                                                       |
| DNS                    | ❌ **Run your own DNS server**<br />No native support for DNS                                                  | ✅ **DNS**<br />DNS built-in, no servers required                                                                        |
| Precision access       | ❌ **Allows lateral movement**<br />VPN places hosts directly onto the network                                 | ✅ **Zero Trust Network Access**<br />Lateral movement prohibited, reduced attack surface                                |

By default all systems are dark to the public Internet, behind closed firewalls with no knowledge of one other and no ability to communicate. Once policy is defined, members are introduced and must mutually authenticate using digital certificates. If successful, access is granted.

If you're new to Enclave, check out our [Getting Started Guide](getting-started/installation.md) to help get you up and running in a few minutes. If you have questions or get stuck, our [Slack Community](https://enclave.io/slack) has the answers.

[Getting Started Guide →](/getting-started/installation){ .md-button .md-button--primary } &nbsp; [Join our Slack Community](https://enclave.io/slack){ .md-button }

## Supported Platforms

We support most major operating systems and CPU architectures.

| Platform | Architecture        | Status      |
| -------- | ------------------- | ----------- |
| Linux    | x64, arm, arm64     | ✅ Supported |
| Windows  | x64                 | ✅ Supported |
| MacOS    | x64                 | ✅ Supported |
| iOS      | ⏳ Not supported yet, coming soon |
| Android  | ⏳ Not supported yet, coming soon |

> Android and iOS support are planned and will be added soon.

## Other resources

* Enclave developer community forum: [https://community.enclave.io/](https://community.enclave.io/)
* Enclave platform status: [https://status.enclave-networks.com/](https://status.enclave-networks.com/)

## Stay in touch

We regular newsletters with product updates, blog posts, and company news. Sign up below to subscribe.

[Subscribe to our mailing list](https://enclave.io/newsletter){ .md-button }
