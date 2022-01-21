---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# Certificate lifetime management and best practice

Connections in Enclave are governed by certificates. When a certificate is issued it contains `NotBefore` and a `NotAfter` fields expressed as a 64 bit integer offset from the Unix time epoch (seconds elapsed since 00:00:00 UTC on 1 January 1970). A value of `-1` in the `NotAfter` field indicates the certificate has no effective expiry date, and has been issued in perpetuity.

```
    ...

    "NotBefore": 1549156210,
    "NotAfter": -1,

    ...
```

Certificates should be issued with validity periods matching the expected lifetime of enrolling systems — hours, days, years, or in perpetuity. For systems which have no known future date of decommission, it is recommended to issue certificates that are valid in perpetuity. In the event of system, or private key compromise the certificate should be revoked using the portal.

## Perpetual Issue Certificates

Traditional TLS certificate management best practices are evolving towards recommending against issuing certificates with extended lifetimes. The purpose of this section is to demonstrate that certificates don't need to expire to provide good security properties.

Over the last decade, spurred mainly by the introduction of automation technologies wrapping the certificate renewal process and the advent of the wonderful LetsEncrypt project, conventional thinking has started to drift toward the use of short-lived certificates with TLS.

There are several reasons for this, in short compromised certificates are hard to revoke, and the longer a certificate is valid, the more likely it can be used nefariously in the event of compromise precisely because revocation is tricky.

* Certificate revocation options are imperfect and represent a single point of failure (OCSP responders and CRL distribution points not recognised as reliable network parties, and soft-fails are common practice).
* Long-lived static keys have increased value to attackers and are exposed to the possibility of theft for longer.
* A shorter lifetime reduces exposure in the event of key compromise.
* Revocation infrastructure leads to huge certificate revocation lists and high traffic volume at OCSP servers.
* Automation is not encouraged by the use of long-lived certificates.
* In the event that a vulnerability is discovered in a cryptographic primitive (e.g. SHA1) shorter lived certificates force deprecated and vulnerable protocols out of the ecosystem far more quickly.

The landscape of TLS is inherently fragmented, Browser vendors, Certificate Authorities, system administrators and software developers all exist in isolation of one another, operating independently and on different time scales. The fractured landscape of TLS means that short-lived certificates, which constantly refresh trust are a vital for the future development of the ecosystem. Enclave however, is not a fragmented landscape and does not suffer the same operational challenges which TLS must endure.

Certificate revocation in the Enclave portal is instant and applied globally across your entire estate. Once a certificate is expired or revoked, all connections are instantly, immediately and irrevocably terminated. The most important thing to keep in mind is that the nature of key compromise is such that you almost never know it has happened until it is too late (consider Diginotar as an extreme example). When indicators of compromise suggest that a system may have been attacked, its certificate should be immediately revoked using the Portal (an operation which can be automated using the Portal API). In the event that a system compromise remains undetected, refreshing the private keys has little effect as the fresh keys would simply be extracted a second time from the same compromised system.

Equally, Enclave benefits from automatic updates and (optional) forced shutdown of older versions where security vulnerabilities are uncovered, allowing organisations to centrally and effectively manage the risk vs. availability tradeoff.

By nature of the fully managed platform, Enclave is able to overcome the drive towards short lived certificates mandated by the fragmented TLS ecosystem and offer the benefits of perpetual issue certificates with no adverse impact to your threat model.

In short, for public infrastructure exposing TLS endpoints, short-lived certificates should be adopted wherever possible. Systems connected privately via Enclave can, and should confidently deploy perpetually issued certificates

## Enrolment key constraints

In order to issue a certificate to an enrolling system, an Enrolment Key must first be created in the Portal. Enrolment Keys created without a configured `Validity Period` constraint will, by default, issue certificates that are valid in perpetuity.

Enrolment Keys created with a `Validity Period` constraint will remain valid from the time when the Enrolment Key is used, for the expressed duration of the constraint. That is to say, if a `Single Use` Enrolment Key were created on the 1st of January, with a `Validity Period` constraint of 7 days, and remained unused until the 1st of February then - at the time of use - the resulting certificate would be valid for 7 days from the 1st of February.

Short-lived, or fixed lifetime certificates are an ideal way to interact with the partners, the supply chain or contractors where an engagement or project has a fixed duration and the connection must not persist beyond a fixed point in time.

## Further reading

* [How Short-Lived Certificates Improve Certificate Trust](https://www.digicert.com/blog/short-lived-certificates/) (www.digicert.com)
* [Short-Lived Certificates @ Netflix](https://medium.facilelogin.com/short-lived-certificates-netflix-fd5f3ae5bc9) (medium.facilelogin.com)
* [Why bother with short-lived certificates and keys in TLS?](https://unmitigatedrisk.com/?p=584) (unmitigatedrisk.com)
* [Good certificates die young: what's passive revocation and how's it implemented?](https://smallstep.com/blog/passive-revocation/) (smallstep.com)

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>