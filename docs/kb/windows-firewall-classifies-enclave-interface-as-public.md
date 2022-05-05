---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# Windows firewall classifies Enclave interface as public

By default, Enclave will attempt to mark any network interfaces it creates as `Private` in the Windows Firewall. In some circumstances when the WMI subsystem is not available, or if an administrator or other process has re-classified the NetworkCategory of the Enclave interface may not be set to `Private`.

We recommend that customers classify the Enclave network interface as `Private` in the Windows Firewall at all times.

## Symptoms

Traffic flows according to policy may appear not to function as expected.

## Cause

The Windows Firewall may be unexpectedly classifying the Enclave network interface as `Public` or `Domain`.

## Resolution

Get a list of all network interfaces installed by Enclave on the target operating system and use PowerShell to check the interface is incorrectly classified, and manually update the classification.

1. Open an administrator PowerShell prompt

2. Run `enclave list-adapters`. If you have enrolled multiple profiles, you may have more than one Enclave installed network interface. 

    ```
    Index    Net Connection Id      Service Name    Driver Name                         Guid
    --------------------------------------------------------------------------------------------------------------------------
    #7       Universe               enclavetap6     Enclave Virtual Network Port        {256ACE63-7C29-4A87-AFD2-7D248DB3607E}
    #16      Ganymede Robotics      enclavetap6     Enclave Virtual Network Port #2     {64CBD519-E5AA-469B-9C14-74C8777E1C45}
    ```

3. Run `Get-NetConnectionProfile -InterfaceAlias "Universe"` using the current `Net Connection Id` value. Check the `NetworkCategory`.

    ```
    Name             : Network 2
    InterfaceAlias   : Universe
    InterfaceIndex   : 7
    NetworkCategory  : Public
    IPv4Connectivity : LocalNetwork
    IPv6Connectivity : NoTraffic
    ```

4. Set the `NetworkCategory` to `Private`

    `Get-NetConnectionProfile -InterfaceAlias "Universe" | Set-NetConnectionProfile -NetworkCategory Private`

## Notes

This is not a problem caused by Enclave, but a bug in dotnet core. Some customers may encounter this bug during routine use of the product, which may also interfere an administrator's ability to use Enclave effectively.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated May 5, 2022</small>