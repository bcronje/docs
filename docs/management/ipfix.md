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

On Windows, either right click on the Enclave tray icon, click on **Universe** and then click on **Stop**.

![image](/images/management/windows-stop-enclave.png)

You can also stop Enclave in a command prompt using `enclave stop`
```
C:\> enclave stop
```

On Linux you can use `sudo enclave stop` or `sudo systemctl stop enclave`

## Step 2: Edit your Enclave configuration file

On Windows the Enclave configuration file is located at `C:\Program Files\Enclave Networks\Enclave\Agent\profiles\Universe.profile`. We recommend you edit the configuration file through the Enclave tray application by clicking on the settings icon in the top left corner of the Enclave application and selecting `Edit profile configuration file...`, or you can manually edit the file.

> When manually editing the configuration file you will need to run your editor, e.g. Notepad, as Administrator.

![image](/images/management/windows-edit-profile.png)

On Linux the Enclave configuration file is located at `/etc/enclave/profiles/Universe.profile` and can be edit using your preferred editor, e.g.

```
$ sudo nano /etc/enclave/profiles/Universe.profile
```

## Step 3: Configure IPFIX

IPFIX is configured using the JSON property `FlowMetadata`. Under `FlowMetadata` we provide the following configuration properties and options:

- `IpFixCollectors` - A list of zero of more IPFIX collector information in the string format "_Udp/Collector IP Address:Port_" e.g. `Udp/172.16.1.100:4739`. The example specifies that `UDP` is the transport protocol to use, `172.16.1.100` is the IP address of the IPFIX collector and the collector is listening on UDP port `4739`.
You can specify multiple IPFIX collectors and Enclave will forward IPFIX flow information to all configured collectors. By default no exporters are configured.

- `Direction` - Valid string values are `Both`, `SendingToPeer` and `ReceivedFromPeer`. The default value if not specified is `Both`.
IPFIX supports single direction flow information per data record. This means a normal bidirectional flow e.g. a TCP session, will generate two IPFIX data records, one for ingress information and a second for egress information. This is the default behaviour and what will be expected when you configure `Both` as the direction. In certain circumstances this might not be ideal, imagine you are running Enclave on System A and System B, both have IPFIX enabled and is monitoring a TCP session between them. With the default `Both` direction System A will export both ingress and egress data, while System B will also export both ingress and egress data. This means you end up with 4 flow records for a single TCP session. With the `SendingToPeer` and `ReceivedFromPeer` direction options you can limit flow information export to either egress information or ingress information respectively.
> There is one exception to the direction setting. Frames dropped due to violation of [Access Control Rules](/management/policy/#access-control-rules) will always generate an IPFIX record and be exported, irrespective of the direction setting. For example, even if you have configure `ReceivedFromPeer`, if an outgoing frame to a remote Enclave peer is dropped due to an [Access Control Rules](/management/policy/#access-control-rules) violation, Enclave will still report on this egress record.

- `Interval` - The interval in millisecond that Enclave will generate and export interim IPFIX flow records. If `Interval` is set to 0, then Enclave will only generate and export flow records at the end of each flow. The default value is 0.

At the bottom of the configuration file add the following JSON configuration:

```
  "FlowMetadata":{
    "IpFixCollectors": [
        "Udp/10.1.10.120:9995"
    ],
    "Direction": "Both"
    "Interval": 60000,
    "Enabled": true
  }
```
