---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# Enclave is running but the API service is not responding

In certain circumstances on Windows computers Enclave may continue to provide network connectivity to peers, but the user interface may report that the API service is not responding, preventing local administration.


## Symptoms

The Windows Tray application may report "Enclave is running but the API service is not responding"

## Cause

Microsoft has confirmed that this is a problem with dotnet core and has issued a fix tracked in this GitHub issue [Single file: Guard against partial clean-up of extracted files #3778](https://github.com/dotnet/runtime/issues/3778). A fix is scheduled to be released as part of the servicing release in April 2020.

## Resolution

This issue has been fixed in the latest version of Enclave. Customers still running Enclave version `2020.4.20.0` should apply the following workaround:

1. Open an administrator command prompt
   
2. Run `sc stop Enclave`

3. Delete the contents of `C:\Windows\Temp\.net\enclave`

4. In the Enclave Tray application use the "Request Start" button to start Enclave again

## Notes

This is not a problem caused by Enclave, but a bug in dotnet core. Some customers may encounter this bug during routine use of the product, which may also interfere an administrator's ability to use Enclave effectively.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>