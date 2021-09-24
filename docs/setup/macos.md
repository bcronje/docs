
# MacOS

## Installation

<small>Requires at least OSX 10.10 (Yosemite).</small>

1. Install the [homebrew package manager](https://brew.sh/) if you don't already have it.

2. Install Enclave
```bash
brew install enclave
```
You will likely be prompted to provide local credentials.  

3. Once installed, enrol your system with your Enclave Organisation   
```bash
sudo enclave enrol
```
You will be asked for a valid Enrolment Key from your [Portal](https://portal.enclave.io/) account.
> Enclave stores the generated private keys for your local Enclave identity in a way that prevents easy access without local admin privileges, which is why this command runs under sudo.

4. Depending on the type of enrolment key you used to enrol your new system, it might be held waiting for an Administrator to provide enrolment approval in your account [Portal](https://portal.enclave.io/). Log in to authorise the enrolment of your new system if you need to, and configure additional options like DNS.

**You're all set!** You've successfully enrolled a new system to your Enclave account.
  
## Starting and stopping Enclave

The installer creates a lightweight supervisor service set to run at system start which is responsible for starting the Enclave fabric. The supervisor service exists to start, stop and restart Enclave fabric in the background as daemon child processes.

The supervisor service responds to the Enclave CLI verbs [start](/handbook/fabric/cli/start) and [stop](/handbook/fabric/cli/stop) to control the Fabric.

## Updating Enclave

You can run    
```
brew upgrade enclave
``` 
to install the latest version of enclave; your existing enrolment will be preserved.

## Uninstalling Enclave

To remove Enclave, you can run:

```
brew uninstall enclave
```

This will stop all Enclave processes, and remove the binaries from your system, but your Enclave configuration, private keys and log files will be left in-place. 

If you wish to fully clear Enclave from your system, run:

```bash
brew uninstall enclave --zap
```

This will remove all configuration, private keys and log files from your system along with the Enclave binaries.

> **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.
