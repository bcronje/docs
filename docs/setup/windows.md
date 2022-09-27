# Windows

<small>This guide applies to Windows 7, 8, 10, 11 and Windows Server 2012, 2016, 2019 and 2022 (all editions). Packages are available for the x64 architecture.</small>

## Installation

1. Download and run the latest Windows installer
    <div class="download-container" id="download-primary"> 
      <a class="download-button" target="_blank" rel="noopener noreferer"><button>Download Enclave for Windows</button></a>
      <p class="download-url"></p>
      <div class="checksum-container">
      <p>Package checksum (<span class="hash-alg">loading ...</span>)</p>
      <p><code class="checksum">----------------------------------------------------------------</code></p>
      </div>
    </div>

2. Run the installer. Administrator privileges are required, but the installer will prompt for privilege elevation if necessary.

3. You will need to provide a valid Enrolment Key from your [Portal](https://portal.enclave.io/) account to complete installation.

4. Once installed, Enclave will start and add a new tray icon to your system tray. If the Enclave tray icon is not visible, click the up arrow to find it in the hidden system tray overflow area.

    ![/images/setup/enclave-tray-icon.png](/images/setup/enclave-tray-icon.png)

5. Right click on the tray icon when you need to open Enclave.

6. Depending on the type of enrolment key you used to enrol your new system, it might be held waiting for an Administrator to provide enrolment approval in your account [Portal](https://portal.enclave.io/). Log in to authorise the enrolment of your new system if you need to and configure additional options like DNS.

**You're all set!** You've successfully enrolled a new system to your Enclave account.

### Starting and stopping Enclave

The Windows installer creates a lightweight supervisor service (named **Enclave** in the Services MMC snap-in) which automatically runs at system start and is responsible for starting the Enclave fabric. The supervisor service exists to start, stop and restart Enclave fabric in the background as child processes.

The supervisor service responds to the Enclave CLI verbs `start` and `stop` to control the Fabric.

<!--- TODO The supervisor service responds to the Enclave CLI verbs [start](/handbook/fabric/cli/start) and [stop](/handbook/fabric/cli/stop) to control the Fabric. --->

### Updating Enclave

The Windows Tray application will prompt users when an updated version of Enclave is available. Following the `click here` to upgrade link in the yellow bar will terminate any Enclave connections temporarily while the setup installs the latest version.

Enclave should be upgraded in-place and will automatically and re-establish connectivity to peers following an update. Updating Enclave to a new version should not interrupt connectivity for more than 1 minute in total, in most cases an upgrade takes less than 30 seconds before connectivity is restored.

![/images/setup/enclave-tray-icon.png](/images/setup/enclave-update.png)

### Uninstalling Enclave

Enclave can be removed from a system using the Windows Control Panel. Open either **Programs and Features** or **Apps and Features**. Select **Enclave** to remove / uninstall. During uninstallation Enclave will ask if you want to **Remove network fabric configuration and private keys?** Answering yes will empty the following directory:

```
C:\Program Files\Enclave Networks\Enclave\Agent\profiles\
```

Users should remove configuration and private keys when uninstalling if they are not planning to use Enclave again on a that particular system, or want to forcibly deregister.

> **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.

### What to do if the install fails

If an install goes horribly wrong, remove Enclave using the uninstaller and try again. If you're still encountering problems, examine the log files in `C:\Program Files\Enclave Networks\Enclave\Agent\logs`. If an install is interrupted use the Enclave setup file to restart the process.

For troubleshooting and errors, use the site search or visit our [troubleshooting](/kb/#troubleshooting) section to look for information about common error messages.

If your installation fails and you are unable to resolve the problem, please contact <a href="mailto:support@enclave.io">support@enclave.io</a>.

## Unattended installation

To support unattended installation, suitable for deployment through Group Policy, Configuration Manager, or some other automated deployment system, we recommend the use of our separate "unattended" installers, optimised for bulk distribution and silent running.

For most use-cases, you should use the 'exe' form of the unattended installer.  To deploy, follow these steps.

1. Retrieve the latest version of the unattended installer:
  
    <div class="download-container" id="download-unattended-exe">
      <a class="download-button" target="_blank" rel="noopener noreferer"><button>Download Unattended EXE Installer</button></a>
      <p class="download-url"></p>
      <div class="checksum-container">
      <p>Package checksum (<span class="hash-alg">loading ...</span>)</p>
      <p><code class="checksum">----------------------------------------------------------------</code></p>
      </div>
    </div>

2. Distribute as needed via Group Policy, Configuration Manager, or any other deployment method that allows installers to run with elevated permissions on the machine.

    To run the installer in silent mode (with no UI), you pass the `-q` command line argument, like so:

    ```
    ./enclave-setup-unattended-<version>.exe -q
    ```

    You can also provide the Enclave enrolment key to the unattended installer to automatically enrol Enclave during installation, so no end-user interaction is required
    to get set up:

    ```
    ./enclave-setup-unattended-<version>.exe -q ENROLMENT_KEY=XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
    ```

    Providing an invalid enrolment key will cause the installation to fail (and roll back).

> **Note:** If providing an enrolment key to the installer, at the time of install the system will require an internet connection to perform the enrolment. If you need to deploy on a machine with no current internet connection, deploy the installer without the `ENROLMENT_KEY` property, then use the CLI `enclave enrol` command later to enrol the system.

### Updating Enclave 

To update an unattended installation, distribute the new version of the unattended installer via the same method as you used when deploying originally; existing enrolled systems will have their configuration and identity preserved during the upgrade.

The running instance of Enclave will stop and then restart with the new version automatically.

### Uninstalling Enclave

Removing Enclave from a system (when Enclave was installed via unattended mode) can either be done by normal Windows uninstall mechanisms (i.e. via Apps and Features), or by running the unattended installer with the `-uninstall` argument. For example, to perform a silent uninstall:

### Distributing Enclave as an MSI file

Enclave's unattended installer is also available as an MSI file. This can be useful if your tooling requires `.msi` files, or if you want to embed the Enclave installer into an existing package.

> The downside of the MSI file is that it does not bundle the Visual C++ Redistributable with it, so you will need to ensure that your packaging process includes the VC++ redistributable as well; see [this Microsoft document](https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170) for details, and where to download the redistributable.

You can download the last MSI installer here:

  <div class="download-container" id="download-unattended-msi">
    <a class="download-button" target="_blank" rel="noopener noreferer"><button>Download Unattended MSI Installer</button></a>
    <p class="download-url"></p>
    <div class="checksum-container">
    <p>Package checksum (<span class="hash-alg">loading ...</span>)</p>
    <p><code class="checksum">----------------------------------------------------------------</code></p>
    </div>
  </div>

Then run it using `msiexec`:

```
msiexec /i enclave-setup-unattended-<version>.exe /quiet ENROLMENT_KEY=XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

<script type="text/javascript">

  function populateDownload(manifest, releaseType, containerId)
  {
    fetch(manifest, { method: 'get' })
      .then(response => response.json())
      .then(jsonResult => {
        var latest = jsonResult.ReleaseVersions.reverse().find(releaseVersion => { return releaseVersion.ReleaseType === releaseType });
        var url = latest?.Packages[0].Url;
        var hash = latest?.Packages[0].Hash;
        var hashAlg = latest?.Packages[0].HashAlg;

        var container = document.getElementById(containerId);

        container.querySelector('.download-button').href = url;
        container.querySelector('.download-url').innerHTML = url;
        container.querySelector('.hash-alg').innerHTML = hashAlg.toLowerCase();
        container.querySelector('.checksum').innerHTML = base64ToHex(hash);
      })
      .catch(err => {
        console.log(err);
        var container = document.getElementById(containerId);      
        container.querySelector('.download-button').href = "https://portal.enclave.io/my/new-system";
      });
  }

  populateDownload("https://install.enclave.io/manifest/windows/setup.json", 'GA', 'download-primary');
  populateDownload("https://install.enclave.io/manifest/windows/setup-unattended-exe.json", 'GA', 'download-unattended-exe');
  populateDownload("https://install.enclave.io/manifest/windows/setup-unattended-msi.json", 'GA', 'download-unattended-msi');

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
