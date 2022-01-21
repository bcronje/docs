# Next steps

## Find your Enclave IP address

Each system (or device) running Enclave is automatically assigned an IP address from the default range 100.64.0.0/10. [Learn more](/networking/ip-addresses).

In order to send data to other systems in your Enclave you will need to know the IP address of your peers, and they will need to know yours. 

=== "Windows Tray"

    Open Enclave by double clicking on the <img src="/assets/favicon.ico" alt="drawing" width="18" style="vertical-align: middle;" /> icon in the Windows tray notification area, or find `Enclave` in the Start Menu.

    ![Enclave Agent connected to a GitLab server](/images/quick-start/agent-connected-to-gitlab.png)

=== "Linux or Command Line"

    Run `enclave status` from a command prompt or terminal. In this example, the local Enclave IP address is the value of `Virtual address` under our `Local identity`, in this case 100.106.103.219.

    ```
    $ enclave status

    Local identity: V88R

      Release version . . : 2021.3.24.0
      Profile name. . . . : Universe
      Profile location. . : /etc/enclave/profiles/Universe.profile
      Certificate . . . . : CN=V88R Expires=Never (Perpetual Issue)
      Binding address . . : 0.0.0.0:40517
      Local nameserver. . : listening on 100.117.177.98:53
      Virtual adapter . . : tap0 (#21) AA:D2:DA:F2:73:96
      Virtual address . . : 100.117.177.98
      Virtual network . . : 100.64.0.0/10 (255.192.0.0)
      Capabilities. . . . : enclave\fakearp   active pri=4096 local rewrites=8696 peer discards=3510
                          : enclave\unicast   active pri=8192 tap eth=2883747 ipv4=2882372 ipv6=1375 - partners total=2980365 spoofed origin discards=0
                          : enclave\multicast active pri=8200 igmp membership packets ipv4=0 ipv6=1375

      Peer: discover.enclave.io

        Peer state. . . . . : Up
        Certificate . . . . : CN=discover.enclave.io Expires=08/06/2024 09:59:59
        Endpoint. . . . . . : Tcp/161.35.171.235:443

      Peer: PL8 (Gitlab)

        Peer state. . . . . : Up
        Certificate . . . . : CN=PL8 Expires=Never (Perpetual Issue)
        Endpoint. . . . . . : Tcp/134.122.110.217:443 (via relay)
        MAC address . . . . : CE-37-47-5F-4D-BE (fake arp)
        Last activity . . . : 0.38 seconds ago
        Transfer. . . . . . : 14.975 MB received, 274.858 MB sent, link rtt 23 ms
        Virtual network . . : 100.64.0.0/10 (255.192.0.0)
        Virtual address . . : 100.81.14.231
        Dns . . . . . . . . : pl8.enclave, gitlab.enclave
    ```

    From the CLI output, you can see that this system also has a connection to another peer, a Gitlab server. This `Virtual address` for this system is also reported, in this case `100.81.14.231`.

## Find your Enclave DNS hostname

Enclave has a built-in DNS resolver. Right click on any connected system (e.g. Gitlab) in the Windows Tray application and select `Copy` > `Hostname`. Alternatively consult the output of `enclave status` to see the `Dns` names available for each connected peer. On Windows, DNS lookups are automatically configured, so in this example given where we're connected to a GitLab server we could `ping gitlab.enclave` or load https://gitlab.enclave in a browser.

<!-- TODO Visit the [DNS section](/networking/dns) to learn how to use the built-in name resolution services inside your Enclave network. --->

> On Linux, administrators must manually configure the operating system to use the Enclave DNS resolver — see how to [Configure DNS forwarding on Linux](/kb/how-to-configure-dns-forwarding-on-linux).

## Test connectivity

Now that we know the IP address of one of our connected peers (in this example, `100.81.14.231` is the IP address of a connected Gitlab server and `gitlab.enclave` its hostname) let's test connectivity. Pings are a great start, but don't forget to check the host local Windows or Linux firewalls on the destination system to ensure ICMP traffic is permitted.

```
C:\> ping gitlab.enclave

Pinging gitlab.enclave [100.81.14.231] with 32 bytes of data:
Reply from 100.81.14.231: bytes=32 time=1ms TTL=128
Reply from 100.81.14.231: bytes=32 time=1ms TTL=128
Reply from 100.81.14.231: bytes=32 time=1ms TTL=128
```

## Tutorials

* [Configure DNS forwarding on Linux](/kb/how-to-configure-dns-forwarding-on-linux)

* [What are the 100.64.x.x IP addresses](/kb/what-are-100.64.x.x-ip-addresses)
