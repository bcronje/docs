# Troubleshooting

If you find Enclave isn't working as expected, here's a simple set of troubleshooting checklists to follow. You can also search our [developer community forum](https://community.enclave.io/) to see if any issue you might be experiencing have been observed by other users.

## Problems enrolling

1. If you're running on Linux check that the `ca-certificates` package is up to date
2. Check that the date and time on the enrolling system is accurate

## Platform connectivity

1. Check your systems are enrolled and showing as both connected and approved in the portal
2. Check you're running on the latest version of Enclave with `enclave version`
3. Check the output of `enclave status` doesn't contain any warnings or errors
4. Check the output of `enclave status` lists at least one `Peer` and the state shows as `Up`
5. Check network traffic is allowed out to `tcp/*:443`
6. Check network traffic is allowed out to `udp/*:1024-65355`
7. Check network traffic isn't forced through a SOCKS proxy, which is currently unsupported
8. Check local anti-virus software is not interfering with Enclave

## Peer-to-peer traffic not flowing

1. Check the Enclave network adapter is online using `ipconfig /all`. Look for `Ethernet adapter Universe` in the list and check that `Media State` is not shown as `Media disconnected`. If it is, try running `enclave restart` and consider sharing local Enclave logs with [support@enclave.io](mailto:support@enclave. io) to help us investigate the problem.
    
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

2. Check both connected host can ping their own Enclave `Local address`.
3. Check pings target the `Virtual address` of peer whose state is `Up`, not the `Local address`
4. Check the routing table is configured correctly. The routing table is configured automatically by Enclave so unlikely to be the source of a problem unless there are other conflicting routes already in place. Check for duplicate entries or conflicting routes in your routing table, or other network interfaces also using the `100.64.0.0/64` subnet.

    ```
    C:\> route print | findstr 100.64.0.0

    IPv4 Route Table
    ===========================================================================
    Active Routes:
    Network Destination    Netmask        Gateway         Interface    Metric
    100.64.0.0             255.192.0.0    On-link    100.117.177.98       281
    ```

5. Check the MTU configured in the `.profile` files matches on both sides of the tunnel

## DNS resolution not working

1. Get your Enclave local IP address using the `enclave get-ip` command. That's the IP address which the local DNS stub resolver will bind to (`udp\53`).    

    ```
    C:\> enclave get-ip
    100.117.177.98
    ```

2. Use `nslookup` to confirm the nameserver identified in step 1 is responding to queries by attempting to resolve the special, reserved DNS name `_my.id.enclave`.

    ```
    C:\> nslookup _my.id.enclave 100.117.177.98
    Server:   UnKnown
    Address:  100.117.177.98

    Name:     _my.id.enclave
    Address:  100.117.177.98
    ```

3. Check there isn't other software bound to your Enclave `Local address` on port `udp/53`
4. If you're running Enclave on a Linux operating system or inside a container, check that you've correctly [configured DNS forwarding](/kb/how-to-configure-dns-forwarding-on-linux/) to ensure DNS queries from the operating system are reaching the local Enclave DNS stub resolver
5. Check that your primary recursive nameserver returns a `SRVFAIL` when queried with a hostname it should be unable to resolve. Some ISPs run nameservers which return IP addresses for ad servers instead of returning a `SRVFAIL` for non-existent domains. The ping request shown below _should_ fail. If it does not, your ISPs DNS resolver may be hijacking your DNS requests to serve ads

    ```
    C:\> ping null.enclave.io
    Ping request could not find host null.enclave.io. Please check the name and try again.
    ```

6. On Windows, check that the Enclave network adapter doesn't list more than _one_ DNS nameserver. If it does, please remove the DNS server that does not match the Enclave `Local address` shown by the `enclave get-ip` command

## Exit node not working

See our [Exit Node troubleshooting guide](/management/exit-nodes/#troubleshooting).

## Advanced troubleshooting

1.  Try running Enclave as a foreground process with high log verbosity enabled `sudo enclave run -v 5` to inspect traffic flows.
2.  Try running `tcpdump`. Capture from the tap0 interface and inspect the traffic flows.
---

 If you're still having problems after following this checklist, please contact [support@enclave.io](mailto:support@enclave.io) or join one of our [community support](/community-support/) channels to get help and advice.

<small>Last updated January 21, 2022</small>