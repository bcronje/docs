# Install Guides — Ubuntu / Debian

> This guide applies to Ubuntu 14.04 LTS, 16.04 LTS, 18.04 LTS, 18.10, 19.10 and 20.04 LTS with packages available for x86, x64 and ARM.

## Installation

1. Install the **apt-transport-https** plugin.

        sudo apt-get install apt-transport-https

2. Add Enclave’s package signing key and repository to apt sources.

        curl -fsSL https://packages.enclave.io/apt/enclave.stable.gpg  | sudo apt-key add -
        curl -fsSL https://packages.enclave.io/apt/enclave.stable.list | sudo tee /etc/apt/sources.list.d/enclave.list
        sudo apt-get update

3. Install Enclave.

        sudo apt-get install enclave

4. You will need provide a valid [Enrolment Key](/handbook/portal/enrolment-keys) from your account to complete the installation.

**Congratulations!** You've successfully enrolled a new system to your Enclave account.

<!--- ## Unattended Installation --->

## Next steps

#### Build a network

Visit the [building your first connection](/guides/quick-start#getting-connected) section of our getting started guide to learn how to control Enclave.

#### Find your IP address

Run `enclave status` at the command line to find the **Virtual Address** of your newly installed system.

#### Test connectivity

Pings are a great start, but don't forget to check the local Windows firewall configuration to ensure ICMP traffic is permitted.

## Starting and stopping Enclave

The installer creates a lightweight supervisor service set to run at system start which is responsible for starting the Enclave fabric. The supervisor service exists to start, stop and restart Enclave fabric in the background as daemon child processes.

The supervisor service responds to the Enclave CLI verbs [start](/handbook/fabric/cli/start) and [stop](/handbook/fabric/cli/stop) to control the Fabric.

## Updating Enclave

![Enclave tray application showing an available update](https://via.placeholder.com/847x460)

## Uninstalling Enclave

**TODO** `apt-get remove` and `apt-get purge`

> **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.