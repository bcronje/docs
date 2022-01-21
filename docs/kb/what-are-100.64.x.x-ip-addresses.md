---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# What are the 100.64.x.x IP addresses

Each system or device running an Enclave overlay network requires at last one unique IP address in order to participate in that network and communicate with other Enclave peers. That IP address should;

* not conflict with any other IP address, subnet or route which that system may come into contact with during its lifetime and,
* is typically static during the lifetime of that system (no matter where it moves in the physical world).

These requirements make it difficult to reliably use IP addresses from the RFC1918 range without an organisation first checking to ensure no pre-existing address allocations would overlap and also commit to ensuring future developments of the underlay IP network would not conflict with addressing in the Enclave overlay IP network.

## Private networks and RFC 1918

While all IP addresses are technically routable, including those listed in used in private networks, RFC1918 defines several blocks of IPv4 address space which is intended for private-use networking only. As such, RFC1918  ranges are often referred to non-routable as they are not meant to be reachable from the public Internet, and carriers will avoid publishing routes for those ranges.

* **10.0.0.0/8** (255.0.0.0) — [10.0.0.0 – 10.255.255.255] — 16,777,216 addresses
* **172.16.0.0/12** (255.240.0.0) — [172.16.0.0 – 172.31.255.255] — 1,048,576 addresses
* **192.168.0.0/16** (255.255.0.0) — 192.168.0.0 – 192.168.255.255 — 65,536 addresses

Almost every private network on earth has devices assigned IP addresses from one, or more of those ranges, so the potential for conflict is extremely high. Indeed, network operators must take care to ensure that different parts of their aggregate address space do not overlap or conflict to avoid connectivity challenges.

## Carrier Grade NAT (CGNAT)

IANA has reserved another prefix which is far less commonly deployed, **100.64.0.0/10**. Defined by RFC6598 (IANA-Reserved IPv4 Prefix for Shared Address Space) Carrier Grade NAT is expressly reserved as a range that does not conflict with either the private network address ranges defined by RFC1918 or the public Internet ranges assigned to the [Regional Internet Registries](https://en.wikipedia.org/wiki/Regional_Internet_registry) by [IANA](https://www.iana.org/).

* **100.64.0.0/10** (255.192.0.0) — [100.64.0.0 - 100.127.255.255] — 4,194,304 addresses

As this range is reserved for carriers and ISP, never exposed either to the customer side of the carrier's network, or the public Internet. As such the CGNAT range meets all of the criteria we require from a network IP address in an overlay network:

* The CGNAT range is not to be used on private networks, so non-conflicting with 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16.
* The CGNAT range is not to be used on the public Internet, so non-conflicting with routable networks.
* The CGNAT range is large enough to accommodate private networks where up to 4 million devices may co-exist without IP addresse conflicts.
* Have a set of well defined and universally recognised constraints which allow their safe re-use within organisations.

## 100.64.0.0/10

100.64.0.0/10 by default, but configurable. Enclave will assign each participating host, device or system with an IP address from the 100.64.0.0/10 range, but Enclave can be configured to use *ANY* IPv4 address allowing incredible flexibility when during migrations, consolidation and when working with esoteric and inflexible underlay networks.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>