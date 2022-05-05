---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# Windows firewall classifies Enclave interface as Public

By default Enclave will attempt to mark any network interfaces it creates as `Private` in the Windows Firewall. In some circumstances when the WMI subsystem is not available, or if an administrator or another process has re-classified the `NetworkCategory`, the Enclave interface may not be set to `Private`.

We recommend that customers classify all Enclave network interfaces as `Private` in the Windows Firewall at all times.

## Symptoms

Traffic may not be flowing between connected peers according to the Policies defined in the Enclave management portal.

## Cause

The Windows Firewall may be unexpectedly miss-classifying the Enclave network interface as either `Public` or `Domain` instead of `Private`.

## Resolution

Get a list of all network interfaces installed by Enclave on the target operating system and use PowerShell to check the Enclave interfaces are incorrectly classified, and manually update the classification if not.

1. Open an administrator PowerShell prompt

2. Run `enclave list-adapters`. If you have enrolled multiple profiles enrolled on the same OS, you may have more than one Enclave network interface installed. 

    ```
    Index    Net Connection Id      Service Name    Driver Name                         Guid
    --------------------------------------------------------------------------------------------------------------------------
    #7       Universe               enclavetap6     Enclave Virtual Network Port        {256ACE63-7C29-4A87-AFD2-7D248DB3607E}
    #16      Ganymede Robotics      enclavetap6     Enclave Virtual Network Port #2     {64CBD519-E5AA-469B-9C14-74C8777E1C45}
    ```

3. Run `Get-NetConnectionProfile -InterfaceAlias "Universe"` using the correct `Net Connection Id` value in place of `Universe` if your adapter has a different name and check the `NetworkCategory` value.

    ```
    Name             : Network 2
    InterfaceAlias   : Universe
    InterfaceIndex   : 7
    NetworkCategory  : Public
    IPv4Connectivity : LocalNetwork
    IPv6Connectivity : NoTraffic
    ```

4. If the `NetworkCategory` is not shown as private it, use the following command to reclassify the interface.

    `Get-NetConnectionProfile -InterfaceAlias "Universe" | Set-NetConnectionProfile -NetworkCategory Private`

## Notes

If you are experiencing difficulties with traffic flows, please follow our [troubleshooting guide](/support/troubleshooting/).

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated May 5, 2022</small>