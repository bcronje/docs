---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# Windows Firewall classifies Enclave interface as Public

By default Enclave will attempt to mark any network interface it installs as `Private` in the Windows Firewall. In some circumstances the Enclave interface may not be set to `Private`. This can happen if the WMI subsystem is not available, or if an administrator, or another process changes the interface's `NetworkCategory` setting.

We recommend that customers classify all Enclave network interfaces as `Private` in the Windows Firewall at all times.

## Symptoms

Network traffic may not be flowing as expected between connected peers according to the Policies defined by administrators in the Enclave management portal.

## Cause

The Windows Firewall may be unexpectedly and incorrectly classifying Enclave network interfaces as either `Public` or `Domain` instead of `Private`.

## Resolution

Obtain a list of all network interfaces installed by Enclave on the relevant systems and use PowerShell to check if any are incorrectly classified by the Windows Firewall. Manually update the `NetworkCategory` classification as needed.

1. Open an administrator PowerShell command prompt

2. Run `enclave list-adapters`. If you have enrolled multiple profiles enrolled on the same device, you may have more than one Enclave network interface listed. If you only have one profile enrolled, it is usually called `Universe`.

    ```
    Index    Net Connection Id      Service Name    Driver Name                         Guid
    --------------------------------------------------------------------------------------------------------------------------
    #7       Universe               enclavetap6     Enclave Virtual Network Port        {256ACE63-7C29-4A87-AFD2-7D248DB3607E}
    #16      Ganymede Robotics      enclavetap6     Enclave Virtual Network Port #2     {64CBD519-E5AA-469B-9C14-74C8777E1C45}
    ```

3. Choose the appropriate Enclave network interface and run `Get-NetConnectionProfile -InterfaceAlias "Universe"` to check the `NetworkCategory` value. Be sure to use the correct `Net Connection Id` value in place of `Universe` if your adapter has a different name.

    ```
    Name             : Network 2
    InterfaceAlias   : Universe
    InterfaceIndex   : 7
    NetworkCategory  : Public
    IPv4Connectivity : LocalNetwork
    IPv6Connectivity : NoTraffic
    ```

4. If the `NetworkCategory` is not shown as `Private`, use the following command to reclassify the interface. Be sure to use the correct name for the `-InterfaceAlias` argument.

    `Get-NetConnectionProfile -InterfaceAlias "Universe" | Set-NetConnectionProfile -NetworkCategory Private`

## Notes

If you continue to experiencing difficulties with traffic flows, please follow our [troubleshooting guide](/keywords/no-traffic).

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated May 5, 2022</small>