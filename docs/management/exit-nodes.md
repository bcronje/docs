Enclave works best when the agent is installed directly on every client, server, VM and container in your organisation. That way, Enclave can apply Zero Trust Network Access controls between systems, traffic is end-to-end encrypted, and enrolled systems can take full advantage of the features of the Enclave overlay network.

However, in some situations, you can’t or don’t want to install Enclave on each device:

- With embedded devices, like firewalls, SCADA infrastructure, cloud native services or printers, which don’t run third party software.
- When connecting to Windows domain controllers where [two or more network interfaces](dual-nic-domain-controller) are not recommended.
- When connecting large numbers of devices in a single subnet, like an entire AWS VPC
- When deploying Enclave to networks which are not allowed to change
- When deploying Enclave to access legacy systems which are too old to run the agent 

In these cases, you can set up an “exit node” to access devices not running Enclave, from a system in the same subnet which is. Exit nodes act as a gateway, moving traffic from your Enclave peers to your physical subnet and back again.



[dual-nic-domain-controller]: https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/unwanted-nic-registered-dns-mulithomed-dc