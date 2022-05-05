---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# What happens if Enclave is down?

As described in our [Architecture](/concepts/architecture) documentation, the Discovery Service is only centralised component of Enclave's architecture. It is responsible for enrolment of new systems along with computing and distributing policy to all Enclave devices on your network. However, if the discovery service goes down your Enclave network will mostly continue to function:

## What will work

- Enclave does not route any traffic through the Discovery Service. Most of the time, devices will talk directly to one another. In cases where a direct connection cannot be established, devices will fall back to using one or more traffic relays located in different regions all over the world. That means that in the event that the Discovery Service becomes unavailable, traffic in your Enclave networks will continue to move between your devices.

- Devices can continue to communicate with each other until either one of the devices experiences key material expiry, or until the network connection between those devices is lost or interrupted (Changing from a wired network to wireless network, for example).

    If the discovery service is unavailable for long enough, the key material held by each device may expire. In most cases the machine keys use to authenticate systems have a long lifetime, so it's more likely that if you're using an IdP integration to authenticate users as well as machine keys, then user identity key expiry may happen much more quickly. However, exactly when is device-dependent and based on the last time a user authentication took place, which is likely to be different between each device on the network.

- When Policy or configuration changes are made by platform administrators they are pushed your Enclave devices. Policy is both cached and enforced locally, meaning that your existing Policies, ACLs and connectivity arrangements will continue to function in the absence of the Discovery Service.

## What won't work

On the other hand, without the Discovery Service available:

- Any devices which disconnect from one another will be unable to reconnect.
- Any devices which attempt to come online won't be able to connect.
- Any devices using user identity as part of the authentication requirements to construct tunnels will be unable to renew their keys, meaning that those devices will gradually lose access to each other. If the tunnel is only authenticated using machine keys however, it's unlikely that those machine keys will expire in a time-frame relevant to a service outage. 
- Existing Policies and ACLs cannot be updated.
- Existing devices cannot be revoked and removed from your account.

## How we approach availability

We engineer to achieve no less than 99.9% unplanned downtime for our Discovery Service and 99.999% availability for all other SaaS components.

That may sound strange, to engineer for, and tolerate unplanned downtime of the Discovery Service at up to 99.9% per year for such a critical component, that's up to 8 hours, 45 minutes and 56 seconds of downtime every year.

Let's unpick that.

First of all, and let's be clear - Enclave _is_ architected to be a highly available and highly resilient service, in fact we routinely far exceed 99.9% availability.

However, the Discovery Service has a very unique architecture and special role in the availability of the overall platform.

The Discovery Service is an extremely light-touch service and has relatively infrequent conversations with enrolled devices. Each device retains a full cache of the last conversation it has with the Discovery Service and operates with full autonomy in the event that it looses connection to the Discovery Service. In fact, if the connection is briefly lost it has no operational significance for the device, which just reconnects at the earliest opportunity.

This architecture allows us to avoid investing diminishing returns to engineering for a higher-base level of availability and instead embrace the ephemeral role the Discovery Service plays in the Enclave platform. This in turn allows us to focus on engineering simplicity, which itself produces a stable, maintainable, predictable and easier to reason about platform.

We do however invest heavily in achieving the lowest possible time-to-recovery in the event of failure. Like [Chaos Monkey](https://netflix.github.io/chaosmonkey/), we routinely simulate failure by taking the Discovery Service offline in micro-intervals as part of normal, daily routine operations. This keeps our platform not only resilient to failure, but expectant of it.

By designing to expect failure, when it happens it actually has almost no perceptible impact on on the overall operation of the platform, apart from to slightly increase latency on already eventually-consistent administrative transactions, like pushing updated policy out to enrolled systems.

---

<small>Last updated May 5, 2022</small>