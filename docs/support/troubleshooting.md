# Troubleshooting

If you find Enclave isn't working as expected, here's a simple set of troubleshooting checklists to follow. You can also search our [developer community forum](https://community.enclave.io/) to see if any issue you might be experiencing have been observed by other users.

Your first port of call should always be to run `enclave self-test` to see if any installation or runtime problems are detected.

## Platform connectivity problems

If you think Enclave is having trouble reaching our SaaS services, please work through the following checklist to identify the problem.

1. Check [https://status.enclave-networks.com/](https://status.enclave-networks.com/) for any disruptions or service outages

2. Check your systems are enrolled and showing as both connected and approved in the portal

3. Check you're running on the latest version of Enclave with `enclave version`

4. Check the output of `enclave status` doesn't contain any warnings or errors

5. Check the output of `enclave status` lists at least one `Peer` and the state shows as `Up`

6. Check network traffic is allowed out to `tcp/*:443`

7. Check network traffic is allowed out to `udp/*:1024-65355`

8. Check network traffic isn't forced through a SOCKS proxy, which is currently unsupported

9. Check local anti-virus software is not interfering with Enclave by temporarily disabling it

## Problems enrolling new peers

1. Check [https://status.enclave-networks.com/](https://status.enclave-networks.com/) for disruptions or service outages

2. If you're running on Linux check that the `ca-certificates` package is up to date

3. Check that the date and time on the enrolling system is accurate

## Traffic not flowing between peers

If Enclave appears to be connected to our SaaS services and other peers, but you can't get network traffic to cross the tunnel, please work through the following checklist to identify the problem.

1. Check the Enclave network interface is online using `ipconfig /all`. 

    Look for `Ethernet adapter Universe` in the list and check that `Media State` is not shown as `Media disconnected`. If it is, try running `enclave restart` and consider sharing local Enclave logs with [support@enclave.io](mailto:support@enclave. io) to help us investigate the problem.
    
    ```
    C:\> ipconfig /all

    Ethernet adapter Universe:

    Connection-specific DNS Suffix  . :
    Description . . . . . . . . . . . : Enclave Virtual Network Port
    Physical Address. . . . . . . . . : 00-FF-2C-FD-0F-12
    DHCP Enabled. . . . . . . . . . . : No
    Autoconfiguration Enabled . . . . : Yes
    IPv4 Address. . . . . . . . . . . : 100.117.177.98(Preferred)
    Subnet Mask . . . . . . . . . . . : 255.192.0.0
    Default Gateway . . . . . . . . . : 100.127.255.254
    DNS Servers . . . . . . . . . . . : 100.117.177.98
    ```

2. Check both connected peers can each ping their own Enclave IP address listed in `enclave status` as the `Local address:`.

3. Check that the `Peer state` of the peer you're trying to reach is showing as `Up` in the `enclave status` output.

4. When trying to ping another peer connected via Enclave, check that your ping requests are targeting the `Virtual address` of the destination peer and not the `Local address`.

6. Check the routing table on each peer is configured correctly. 

    The routing table is configured automatically by Enclave so unlikely to be the source of a problem unless there are other conflicting routes already in place. Check for duplicate entries or conflicting routes in your routing table, or other network interfaces also using the `100.64.0.0/64` subnet.

    ```
    C:\> route print | findstr 100.64.0.0

    IPv4 Route Table
    ===========================================================================
    Active Routes:
    Network Destination    Netmask        Gateway         Interface    Metric
    100.64.0.0             255.192.0.0    On-link    100.117.177.98       281
    ```

7. Check the MTU configured in the `.profile` files matches on both sides of the tunnel

### Using Ping to verify connectivity

If you're using ping tests to verify connectivity, it's important to check that the host-local firewall is not dropping traffic arriving on the Enclave network interface.

1. Check that the host-local firewall on both peers is not obstructing traffic flows either to, or from the Enclave network interfaces.

    On Linux the Enclave network interface is likely to be named `tap0` (or similar) and on Windows the Enclave network interface is usually called `Universe` or `Enclave Virtual Network Port`.

    The easiest way to verify that the host-local firewall is not interfering with Enclave traffic is to temporarily disable it, but if that's not possible for your scenario, ensure ICMP echo traffic (type 8, code 0) is permitted.

2. On Windows, you should check that the Enclave network interface is [correctly classified](/kb/windows-firewall-classifies-enclave-interface-as-public/) by the Windows Firewall as `Private` and if required, create an ACL permitting inbound ICMP traffic using PowerShell:

    ```
    New-NetFirewallRule -DisplayName "ICMPv4 (In)" -Profile Private -Direction Inbound -Protocol ICMPv4 -Program Any -Action Allow`
    ```

3. Check that the ACLs defined by your Policies are allowing ICMP traffic to flow on both systems by examining the `ACLs` state reported by `enclave status` on each peer.

    For example, if your attempts to ping a target system are timing out, check that the system you're sending the pings from has an allow ACL like `allow [X] from local -> peer` where `X` is either `[any]` or includes the word `icmp`.

    Critically you'll want to check the `local -> peer` rule on the sender-side of the tunnel permits `icmp` (or `any`) to be sent, and that the `peer -> local` rule on the receiver side also permits `icmp` (or `any`) to be received.

     Note that policies in Enclave are symmetric, so if the sender is allowed to send ICMP traffic, the receiver will implicitly also be allowed to receive it.

## DNS resolution not working

1. Obtain your Enclave local IP address using the `enclave get-ip` command. 

    That's the IP address which the local DNS stub resolver will bind to (`udp\53`).    

    ```
    C:\> enclave get-ip
    100.117.177.98
    ```

2. Use `nslookup` to query the nameserver identified in step 1 by attempting to resolve the special DNS name `_my.id.enclave`

    ```
    C:\> nslookup _my.id.enclave 100.117.177.98
    Server:   UnKnown
    Address:  100.117.177.98

    Name:     _my.id.enclave
    Address:  100.117.177.98
    ```

3. Check there isn't other software bound to your Enclave `Local address` on port `udp/53`

4. If you're running Enclave on a Linux operating system or inside a container, check that you've correctly [configured DNS forwarding](/kb/how-to-configure-dns-forwarding-on-linux/) to ensure DNS queries from the operating system are reaching the local Enclave DNS stub resolver.

5. Check that your primary recursive nameserver returns a `SRVFAIL` when queried with a hostname it should be unable to resolve. Some ISPs run nameservers which return IP addresses for ad servers instead of returning a `SRVFAIL` for non-existent domains. The ping request shown below _should_ fail. If it does not, your ISPs DNS resolver may be hijacking your DNS requests to serve ads

    ```
    C:\> ping null.enclave.io
    Ping request could not find host null.enclave.io. Please check the name and try again.
    ```

6. On Windows, check that the Enclave network interface doesn't list more than _one_ DNS nameserver. If it does, please remove the DNS server that does not match the Enclave `Local address` shown by the `enclave get-ip` command

## Exit nodes not working

See our [Exit Node troubleshooting guide](/management/exit-nodes/#troubleshooting).

## Advanced troubleshooting

1.  Try running Enclave as a foreground process with high log verbosity enabled `sudo enclave run -v 5` to inspect traffic flows.

2.  Try running `tcpdump` or `WireShark` to capture from the tap0 interface (or `Enclave Virtual Network Port` on Windows, usually also called `Universe`) and inspect the traffic flows.

---

 If you're still having problems after following this checklist, please contact [support@enclave.io](mailto:support@enclave.io) or join one of our [community support](/community-support/) channels to get help and advice.

<small>Last updated May 5, 2022</small>