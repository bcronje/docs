---
beta-feature: true
---

> This feature is in beta and may be subject to change in future versions of Enclave. While in beta, this feature doesn't include API endpoints or Portal control and must be manually configured on each system. This page will be updated as the feature enters general availability.
>   
> If you have feedback on this feature, please let us know in one of our [community support](/community-support/) channels.

## Introduction

Enclave implements an Internet Protocol Flow Information Export (IPFIX) exporter. IPFIX is an IETF protocol that provides a universal standard for the export and collection of IP flow information. The Enclave IPFIX exporter conforms to [RFC 7011](https://www.ietf.org/rfc/rfc7011.html) and [RFC 7012](https://www.ietf.org/rfc/rfc7012.html) and should be compatible with any IPFIX collector that supports the IPFIX standard.

## IPFIX Templates

Enclave implements IPFIX templates for exporting IPv4/IPv6 TCP, IPv4/IPv6 UDP, raw IPv4/IPv6, and ICMPv4 flow information.

## Limitation

The IPFIX specification defines three transport protocols that can be used to transport flow information from the exporter to the collector: SCTP, TCP and UDP. Our research showed that all IPFIX collectors almost exclusively support UDP as their transport protocol. As such, we have focused our efforts on implementing UDP as the transport protocol for the Enclave exporter.

## Configuration

To enable and configure IPFIX on your system, you will need to edit your Enclave configuration file. Follow these steps:

## Step 1: Stop the Enclave process

On Windows, right click on the Enclave tray icon, click on `Universe` and then click on `Stop`.

![image](/images/management/windows-stop-enclave.png)

On Linux you can use `sudo enclave stop` or `sudo systemctl stop enclave`

## Step 2: Edit your Enclave configuration file

On Windows the Enclave configuration file is located at `C:\Program Files\Enclave Networks\Enclave\Agent\profiles\Universe.profile`. We recommend you edit the configuration file through the Enclave tray application by clicking on the settings icon in the top left corner of the Enclave application and selecting `Edit profile configuration file...`, or you can manually edit the file.

> When manually editing the configuration file you will need to run your editor, e.g. Notepad, as Administrator.

![image](/images/management/windows-edit-profile.png)







