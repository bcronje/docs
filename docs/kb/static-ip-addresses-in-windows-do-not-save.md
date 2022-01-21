---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# KB937056: Static IP addresses in Windows do not save

In some versions of Microsoft Windows, you may manually configure the TCP/IP properties dialog to add a static IP address. After closing and re-opening the dialog, the Internet Protocol (TCP/IP) Properties dialog box still displays the default settings. Additionally, the "Obtain IP address automatically" option is selected.

However, when you type `ipconfig /all` at a command prompt, the static IP address information that you entered manually is displayed.

## Symptoms

In Windows, the Internet Protocol (TCP/IP) Properties dialog box displays the default IP address settings after you manually configure a static IP address creating the impression that static IP addresses information was not saved or remembered by Windows.

## Cause

Microsoft has confirmed that this is a problem in some versions of Microsoft Windows. See [KB937056](http://support.microsoft.com/kb/937056)

## Resolution

Follow the remediation steps described in [KB937056](http://support.microsoft.com/kb/937056) to remove the `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network` registry key.

For reference, on Page 575 of "Windows 2000 Server 24seven" by Matthew Strebe (ISBN 978-0782126693) the author describes the registry object `...\Control\Network\*` and its subkeys as a store which "contains keys that create the bindings between network adapters, clients, services and transport protocols".

## Notes

This is not a problem caused by Enclave, but a bug in Microsoft Windows. Some customers may encounter this bug during routine use of the product, which may also interfere an administrators ability to use Enclave effectively.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>