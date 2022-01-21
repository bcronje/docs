# Windows

## Installation

<small>This guide applies to Windows 7, 8, 10, 11 and Windows Server 2012, 2016 and 2019 (all editions). Packages are available for the x64 architecture.</small>

1. Download and run the latest Windows installer
    <div class="download-container">
      <a id="download-windows-setup" target="_blank" rel="noopener noreferer"><button>Download Enclave for Windows</button></a>
      <p id="setup-url" class="download-url"></p>
      <div class="checksum-container">
      <p>Package checksum (<span id="hash-alg">loading ...</span>)</p>
      <p><code id="checksum" class="checksum">----------------------------------------------------------------</code></p>
      </div>
    </div>

2. Run the installer. Administrator privileges are required, but the installer will prompt for privilege elevation if necessary.
3. You will need to provide a valid Enrolment Key from your [Portal](https://portal.enclave.io/) account to complete installation.
4. Once installed, Enclave will start and add a new tray icon to your system tray. If the Enclave tray icon is not visible, click the up arrow to find it in the hidden system tray overflow area.
  ![/images/setup/enclave-tray-icon.png](/images/setup/enclave-tray-icon.png)
5. Right click on the tray icon when you need to open Enclave.
6. Depending on the type of enrolment key you used to enrol your new system, it might be held waiting for an Administrator to provide enrolment approval in your account [Portal](https://portal.enclave.io/). Log in to authorise the enrolment of your new system if you need to and configure additional options like DNS.

**You're all set!** You've successfully enrolled a new system to your Enclave account.

## Unattended installation

The Enclave Windows installer supports unattended installations for larger deployments. Run `enclave_setup.exe` with the `/enrol XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` option to install and enrol Enclave without end-user interaction (don't forget to provide a valid enrolment key). 

Alternatively, to perform an unattended roll-out of Enclave without supplying an enrolment key simply use in the `/unattended` option. End-users will be able to provide an enrolment key at a later date.

=== "With an Enrolment Key"

     Perform an unattended installation of Enclave and enrol as part of the installation.

    ```
    C:\> enclave_setup.exe /enrol XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
    ```

=== "Without an Enrolment Key"

    Perform an unattended installation of Enclave without supplying an enrolment key.

    ```
    C:\> enclave_setup.exe /unattended
    ```

## Starting and stopping Enclave

The Windows installer creates a lightweight supervisor service (named **Enclave** in the Services MMC snap-in) which automatically runs at system start and is responsible for starting the Enclave fabric. The supervisor service exists to start, stop and restart Enclave fabric in the background as child processes.

The supervisor service responds to the Enclave CLI verbs `start` and `stop` to control the Fabric.

<!--- TODO The supervisor service responds to the Enclave CLI verbs [start](/handbook/fabric/cli/start) and [stop](/handbook/fabric/cli/stop) to control the Fabric. --->

## Updating Enclave

The Windows Tray application will prompt users when an updated version of Enclave is available. Following the `click here` to upgrade link in the yellow bar will terminate any Enclave connections temporarily while the setup installs the latest version.

Enclave should be upgraded in-place and will automatically and re-establish connectivity to peers following an update. Updating Enclave to a new version should not interrupt connectivity for more than 1 minute in total, in most cases an upgrade takes less than 30 seconds before connectivity is restored.

![/images/setup/enclave-tray-icon.png](/images/setup/enclave-update.png)

## Uninstalling Enclave

Enclave can be removed from a system using the Windows Control Panel. Open either **Programs and Features** or **Apps and Features**. Select **Enclave** to remove / uninstall. During uninstallation Enclave will ask if you want to **Remove network fabric configuration and private keys?** Answering yes will empty the following directory:

```
C:\Program Files\Enclave Networks\Enclave\Agent\profiles\
```

Users should remove configuration and private keys when uninstalling if they are not planning to use Enclave again on a that particular system, or want to forcibly deregister.

> **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.

## What to do if the install fails

If an install goes horribly wrong, remove Enclave using the uninstaller and try again. If you're still encountering problems, examine the log files in `C:\Program Files\Enclave Networks\Enclave\Agent\logs`. If an install is interrupted use the Enclave setup file to restart the process.

For troubleshooting and errors, use the site search or visit our [troubleshooting](/kb/#troubleshooting) section to look for information about common error messages.

If your installation fails and you are unable to resolve the problem, please contact <a href="mailto:support@enclave.io">support@enclave.io</a>.


<script type="text/javascript">
  fetch("https://install.enclave.io/manifest/windows/setup.json", { method: 'get' })
    .then(response => response.json())
    .then(jsonResult => {
      var latest = jsonResult.ReleaseVersions.reverse().find(releaseVersion => { return releaseVersion.ReleaseType === 'GA'; });
      var url = latest?.Packages[0].Url;
      var hash = latest?.Packages[0].Hash;
      var hashAlg = latest?.Packages[0].HashAlg;

      document.getElementById("download-windows-setup").href = url;
      document.getElementById("setup-url").innerHTML = url;
      document.getElementById("hash-alg").innerHTML = hashAlg.toLowerCase();
      document.getElementById("checksum").innerHTML = base64ToHex(hash);
    })
    .catch(err => {
      console.log(err);
      document.getElementById("download-windows-setup").href = "https://portal.enclave.io/my/new-system";
    });

  function base64ToHex(str) {
    const raw = atob(str);
    let result = '';
    for (let i = 0; i < raw.length; i++) {
      const hex = raw.charCodeAt(i).toString(16);
      result += (hex.length === 2 ? hex : '0' + hex);
    }
    return result;
  }
</script>
