---
hide: navigation
---

<small>[Documentation](/) / [Knowledge Base](/kb)</small>

# How to configure DNS forwarding on Linux

> This page only applies if you're running Enclave on Linux. Under Windows and macOS Enclave automatically manages the local name server search order.

Enclave runs a local name server bound to the virtual network IP address of each profile. By default this service runs on port 53 and answers queries for names inside the `.enclave.` zone.

By enabling DNS forwarding and including the local Enclave name server in the search order of your operating system's name server list, you can reference and connect to peers by name.

The local Enclave name server will resolve peers both by their peer description (for example where the peer `V8Z4Y` is described as `primary.redis.service.lon` then it will be resolvable as either `primary.redis.service.lon.enclave` or `V8Z4Y.enclave`). Any spaces in a peer's description field are treated as equivalent to hyphens, so a peer with the descriptions of either `home laptop` or `home-laptop` is resolved to its Enclave IP address with the DNS query `home-laptop.enclave`.

DNS resolution of a peer with the description `primary.redis.service.lon` using Dig:

```
[centos@localhost ~]$ dig @100.105.173.218 primary.redis.service.lon.enclave A

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> @100.105.173.218 primary.redis.service.lon.enclave A
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46433
;; flags: qr rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;primary.redis.service.lon.enclave.   IN   A

;; ANSWER SECTION:
primary.redis.service.lon.enclave.   0   IN   A   100.70.181.144

;; Query time: 2 msec
;; SERVER: 100.105.173.218#53(100.105.173.218)
;; WHEN: Thu Sep 26 14:50:03 UTC 2019
;; MSG SIZE  rcvd: 67
```

Pinging a peer using its description `primary.redis.service.lon` as the hostname:

```bash
[centos@localhost ~]$ ping primary.redis.service.lon.enclave
PING primary.redis.service.lon.enclave (100.70.181.144) 56(84) bytes of data.
64 bytes from 100.70.181.144 (100.70.181.144): icmp_seq=1 ttl=64 time=0.881 ms
64 bytes from 100.70.181.144 (100.70.181.144): icmp_seq=2 ttl=64 time=0.985 ms
64 bytes from 100.70.181.144 (100.70.181.144): icmp_seq=3 ttl=64 time=0.901 ms
64 bytes from 100.70.181.144 (100.70.181.144): icmp_seq=4 ttl=64 time=0.882 ms

--- primary.redis.service.lon.enclave ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 0.881/0.912/0.985/0.047 ms
```

> **Key Principle:** Enclave will not resolve queries for anything outside of the `.enclave.` zone, and will respond to such questions with `SRVFAIL` allowing the other name servers to answer the query.

> **Security Note:** The local Enclave name server will *not* respond to queries from connected peers despite listening on port 53 of the virtual network interface ip address. The name server will only reply to queries which originated from the local system.

## CentOS 7 (dhclient)

By default, the `/etc/resolv.conf` file is configured in CentOS by `/usr/sbin/dhclient-script`. To add the local Enclave name server to the search list it must be added to `/etc/dhcp/dhclient.conf` using the `prepend` option.

```bash
# add local Enclave name server to search order
prepend domain-name-servers 100.66.110.73;
timeout 300;
retry 60;
```

Reboot the operating system to enable the change. You should see the Enclave name server prepended to the top of `/etc/resolv.conf`

> **Important:** `100.66.110.73` is not the address of your local Enclave name server. Find your system's virtual address by running `enclave status` and look for the virtual address under local identity. Alternatively use `ip addr`.

## CentOS 9 (NetworkManager)

By default, the CentOS Stream release 9 networking service is managed by the NetworkManager service. You can confirm that NetworkManager is active by running `systemctl status NetworkManager.service`. In the following example we will use `nmcli`, which is a command-line tool for controlling NetworkManager, to add the Enclave DNS server to the search order.

First you need to get the connection name of your local network by running `nmcli connection`:

```bash
[centos@localhost ~]$ nmcli connection
NAME  UUID                                  TYPE      DEVICE 
eth0  548abdea-2294-3065-b83e-9e5e853bc8d2  ethernet  eth0   
tap0  c7e8579d-8e28-41b9-a4db-535b0ec5a337  tun       tap0
```

The connection name we'll be using in this example is `eth0`. To add the local Enclave name server to the search order runn the following command:

```bash
sudo nmcli con modify eth0 +ipv4.dns 100.66.110.73
```

Restart NetworkManager to apply your changes: 

```bash
sudo systemctl restart NetworkManager.service
```

You can confirm that the local Enclave name server has been added by reviewing `/etc/resolv.conf`

```bash
# Generated by NetworkManager
nameserver 100.66.110.73
nameserver 192.168.1.1
```

> **Important:** `100.66.110.73` is not the address of your local Enclave name server. Find your system's virtual address by running `enclave status` and look for the virtual address under local identity. Alternatively use `ip addr`.

## Ubuntu 16.04 (resolvconf)

By default, Ubuntu 16.04 uses `resolvconf` to manage the contents of `/etc/resolv.conf`. To add the local Enclave name server to the search order, add the local Enclave virtual address using the *nameserver* directive in `/etc/resolvconf/resolv.conf.d/head`

```bash
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 100.66.110.73
```

Reload resolvconf to run the update scripts and apply the changes: `sudo resolvconf -u`

> **Important:** `100.66.110.73` is not the address of your local Enclave name server. Find your system's virtual address by running `enclave status` and look for the virtual address under local identity. Alternatively use `ifconfig`.

## Ubuntu 18.04 and higher (systemd-resolved)

By default, Ubuntu 18.04 uses `systemd-resolved` to manage the contents of `/etc/resolv.conf` and configures the system to use an internal DNS stub resolver for DNS queries by setting the nameserver in `/etc/resolv.conf` to `127.0.0.53`. In order to add the local Enclave name server to the Global search order, add the local Enclave virtual address using the *DNS* directive in `/etc/systemd/resolved.conf`

```bash
[Resolve]
DNS=100.66.110.73
```

Restart the service

```bash
ubuntu@localhost:~$ sudo systemctl restart systemd-resolved
```

> **Important:** `100.66.110.73` is not the address of your local Enclave name server. Find your system's virtual address by running `enclave status` and look for the virtual address under local identity. Alternatively use `ip addr`.

> **Important:** If after setting the `DNS=100.66.110.73` in `/etc/systemd/resolved.conf` you find that name resolution fails with the message `Name or service not known` check that `/etc/resolv.conf` correctly points to the local systemd-resolved DNS stub resolver address `127.0.0.53` and that the systemd-resolved stub resolver service is running.

---

Having problems? Contact us at [support@enclave.io](mailto:support@enclave.io) or get help and advice in our [community support](/community-support/) channels.

<small>Last updated Aug 19, 2021</small>
