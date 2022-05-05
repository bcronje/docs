# Architecture

*Patents and patents-pending: WO2017060675A1, GB2543072A, US20180287803A1*

## Introduction

The Enclave Network Fabric is client-side software, installed on operating systems running on bare metal, as virtual machines and hypervisors, on cloud compute resources or containers. The Enclave Network Fabric  quickly and easily builds secure, private and direct connections to other systems also running the Enclave Network Fabric software.

Enclave does this by creating virtual network interfaces on each operating system where it is installed, allowing applications transparently bind to and use the Enclave virtual network to seamlessly communicate with each other as if they were on the same local area network.

> Enclave builds connectivity at OSI layer 2, encapsulating any protocols which sit above Ethernet frames, so in addition to carrying IP traffic, Enclave can also carry typically non-routed protocols, like NetBIOS and Multicast.

Connectivity pathways constructed by Enclave do not require firewall ports to be opened and usually does not require changes to your existing infrastructure or network topology to function. To achieve peer-to-peer connectivity without ingress traffic explicitly allowed through the firewall/perimeter/network edge of either endpoint, Enclave Network Fabric software both relies on and communicates with several key services: identity and access control, policy enforcement and peer discovery - all delivered by our SaaS platform.

## Endpoint Identities

Each system, endpoint, device or container enrolled to and running Enclave holds a digital certificate with a globally unique name. Certificates are assigned transparently to endpoints as they are licensed by the end-user. Each endpoint generates, encrypts and locally stores its private key, which never leaves that system. A globally unique digital certificate is issued to each endpoint by our SaaS platform which allows that endpoint to cryptographically attest to its identity.

## Mutual Intent

Endpoints running Enclave only learn of each other’s existence once mutual intent from both parties has been cryptographically established. Prior to this, entities have no knowledge of one another. This is a key concept in which gives rise to *authenticate-before-connect* connectivity, which serves to effectively cloak systems running Enclave from third party discovery, observation, targeting and attack.

## Connection Establishment

### Summary

Once mutual intent is confirmed, Enclave builds a Direct Client-to-Client connection (DCC) as opposed to traditional Client-Server connectivity between cooperating entities. The following diagram illustrates the sequence of events by which two or more systems establish mutually authenticated, peer-to-peer connectivity with Enclave.

[![Connection Establishment Steps](/images/concepts/architecture/enclave-architecture-workflow-small.png)](/images/concepts/architecture/enclave-architecture-workflow.png)

Endpoints are only introduced to one another when mutual intent is demonstrated by both parties, and connections terminate if either party decides to disconnect, or their certificate expires.

> **Note:** The control channel relies on our Cloud services to help facilitate and introduce cooperating endpoints, but each data channel is negotiated and authenticated directly between cooperating endpoints with end-to-end encryption — without the involvement of the Enclave Cloud infrastructure.

### Part 1: UDP and TCP hole punching

UDP and TCP hole punching are commonly used techniques in peer-to-peer networking applications on the Internet involving hosts connecting to each other which reside in discreet and isolated private networks.

Both hosts attempting to communicate (from behind NAT devices and closed firewalls) will start sending connection attempts or data to each other, using outbound traffic only and multiple attempts.

The first packet received from the other host will be dropped, its firewall was closed and the network address translation table considered the traffic unsolicited. However, after that same firewall and NAT has a record of having sent a packet back to the other machine, it will allow any subsequent packets originating from the sender's address and port number as expected and solicited return traffic.

Stated simply, both systems will attempt to communicate with one another simultaneously multiple times. The first a system receives will be dropped, but after that same system has sent data to the other host, any further data originating from that host will be allowed to traverse the firewall and NAT.

The Enclave Discovery Service resides on the public Internet and is used to help connecting peers gain knowledge of, and then share with one another their respective public and private IP address information and source port numbers. This gives Enclave peers enough information to attempt UDP/TCP hole punching Direct Client-to-Client bi-directional connections using outbound-only traffic from their inside of their respective private networks, without infrastructure changes or opening the firewall. This technique is also widely used in many other types of peer-to-peer software including VoIP telephony and WebRTC.

> **Security note:** Local RFC 1918 IP address information is shared with the Discovery Service, which is in turn shared with cooperating parties with whom you are trying to establish direct, private network connectivity.
>
> In the context of WebRTC, sharing of private IP addresses via the client's browser is considered to be undesirable information disclosure as it allows websites to conduct covert reconnaissance and surveillance.
>
> Enclave is different. The principle of mutual intent requires cooperation and authentication before a connection is possible, so disclosure of private IP addresses is limited with Enclave to scenarios where Enclave is simply extending an existing real-world agreement to cooperate, as such disclosure of private IP addresses is not considered to be a security concern in this context.

### Part 2: Mutual Authentication

After a bi-directional TCP/UDP connection has been established, it is important to remember that at this point that data channel is unauthenticated, and unencrypted. The connected parties transition the connection to a trusted state without outside assistance, support or communication from other parties.

Prior to connection establishment, both systems had expressed intent to communicate with one another based on knowledge of the other system's certificate name. As each system holds its own certificate, and corresponding private key the pair have all the information they need to perform a standard authenticated key exchange.

Both parties share their certificates with one another, and the recipient checks the name on the certificate matches an expected connection, and checks the validity of the received certificate. If the certificate is expected and valid, the sender is asked to sign a unique challenge to demonstrate knowledge of their private key to authenticate the connection. This is a mutual action, and both sides must attest knowledge of their private keys.

Once the certificate are confirmed to be authentic, the party has gained knowledge of their peer's public key from the exchanged digital certificate. Authenticated knowledge of partner public key is used to compute the encryption keys for the connection.

### Part 3: End-to-end Encryption

All cryptographic features and capabilities in Enclave are implemented with [libsodium](https://github.com/jedisct1/libsodium). Using shared knowledge of each other’s public keys, the two parties can securely compute a set of shared keys using their peer's public key and their own private key. Enclave uses Ed25519 for digital signatures and Curve25519 for ephemeral key exchange and perfect forward secrecy.

Algorithm details:

```text
rx || tx = BLAKE2B-512(p.n || client_pk || server_pk)
```

One a set of share keys are computed, the `rx` and `tx` keys seed a symmetric cipher used to encrypt data before it is placed on the wire. If the processor supports hardware-accelerated AES using `Intel SSSE3` extensions and `aesni` and `pclmul` instructions then Enclave will prefer the `AES256-GCM` cipher. Intel Westmere processors (introduced in 2010) and newer meet the requirements, and major cloud vendors (Azure, AWS, DigitalOcean) support these processor features sets across their entire fleet of instance types. For endpoints which are not capable of hardware-accelerated cryptography, Enclave will use `ChaCha20-Poly1305` (ChaCha20 stream cipher and Poly1305 authentication MAC). Both ciphers are authenticated encryption schemes (AEAD ciphers) which can recognise improperly-constructed ciphertexts and refuse to decrypt them.