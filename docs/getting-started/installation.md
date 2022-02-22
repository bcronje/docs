# Installation

In this quick start guide we will start your journey with Enclave by showing you how to enrol your first two systems and use policy and tags to establish a private network between them.

![Quick start steps](/images/quick-start/steps.png)

## Prerequisites

To follow this guide, you will need:

1. An Enclave account, it's [free to register](https://portal.enclave.io/register)

2. At least two computers, devices or containers where you can install software

## Get an Enrolment Key

You will need an Enrolment Key from your account to install Enclave. Enrolment Keys allow you to enrol new systems or devices to your Enclave account.

1. Login to your account in the [Enclave Portal](https://portal.enclave.io/)

2. Navigate to the Enrolment Keys page and select the [`Quick Start Key`](https://portal.enclave.io/my/keys) from the table

3. In the details pane, select [`View key`](https://portal.enclave.io/my/keys/1) and make a note of the 30 character Enrolment Key

> **Security note:** Enrolment keys should be treated as secrets; handle, share and store your Enrolment Keys as you would any other organisational secret.

<!-- -->

> **Production use:** This guide uses a `Quick Start Key` which was automatically created when you first registered for an account. You can (and should) create your own Enrolment Keys for use in production. Visit the [Enrolment Keys](/management/enrolment) section of the handbook to learn more about creating and managing Enrolment Keys.

## Install Enclave

You will need to install Enclave on at least two separate devices, systems or containers.

=== "Windows"

    <small>Requires Windows 7, 8, 10 or Windows Server 2012, 2016 and 2019 (any edition). Packages are available for the x64 architecture.</small>

    1. Download and run the latest Windows installer
        <div class="download-container">
          <a id="download-windows-setup" target="_blank" rel="noopener noreferer"><button>Download Enclave for Windows</button></a>
          <p id="setup-url" class="download-url"></p>
          <div class="checksum-container">
          <p>Package checksum (<span id="windows-hash-alg">loading ...</span>)</p>
          <p><code id="windows-checksum" class="checksum">----------------------------------------------------------------</code></p>
          </div>
        </div>

    2. Provide the `Quick Start Key` from your account to complete the installation

=== "MacOS"

    <small>Requires at least OSX 10.10 (Yosemite).</small>

    1. Install the [Homebrew Package Manager](https://brew.sh/) if you don't already have it

    2. Install Enclave, you will likely be prompted to provide local credentials.

            brew install enclave

    3. Once installed, enrol your system with your Enclave Organisation

            sudo enclave enrol

    Provide the `Quick Start Key` from your account to complete the installation

=== "Linux"

    Select your distribution:

    === "Ubuntu / Debian / Raspbian"

        <small>Requires at least Ubuntu 14.04 LTS or Debian 9 or Raspbian 10.</small> 

        1. Install apt-transport-https

                sudo apt install apt-transport-https

        2. Add Enclave’s package signing key and repository to apt sources

                curl -fsSL https://packages.enclave.io/apt/enclave.stable.gpg | sudo gpg --dearmor -o /usr/share/keyrings/enclave.gpg
                echo "deb [signed-by=/usr/share/keyrings/enclave.gpg] https://packages.enclave.io/apt stable main" | sudo tee /etc/apt/sources.list.d/enclave.stable.list
                sudo apt update

        3. Install Enclave

                sudo apt install enclave

        4. Enrol

                sudo enclave enrol

        5. Provide your `Quick Start Key` to complete the installation

    === "CentOS / RHEL / Fedora"

        Select your version:

        === "CentOS / RHEL 7"

            <small>Requires CentOS or RHEL 7.</small>

            1. Install Enclave using our quick-start script

                    bash <(curl -Ss https://install.enclave.io/setup.sh)

            2. Provide your `Quick Start Key` to complete the installation

        === "CentOS / RHEL 8"

            <small>Requires at least CentOS or RHEL 8.</small>

            1. Add Enclave’s repository to rpm sources

                    sudo dnf -y install dnf-plugins-core
                    sudo dnf config-manager --add-repo https://packages.enclave.io/rpm/enclave.repo

            2. Install Enclave

                    sudo dnf install enclave

            3. Enrol

                    sudo enclave enrol

            4. Provide your `Quick Start Key` to complete the installation

        === "Fedora"

            <small>Requires at least Fedora 32.</small>

            1. Add Enclave’s repository to rpm sources

                    sudo dnf -y install dnf-plugins-core
                    sudo dnf config-manager --add-repo https://packages.enclave.io/rpm/enclave.repo

            2. Install Enclave

                    sudo dnf install enclave

            3. Enrol

                    sudo enclave enrol

            4. Provide your `Quick Start Key` to complete the installation

    === "Amazon Linux"

        <small>Requires at least Amazon Linux 2018.03.</small> 
                        
        1. Install Enclave using our quick-start script

                bash <(curl -Ss https://install.enclave.io/setup.sh)

        2. Provide your `Quick Start Key` to complete the installation


    === "OpenSUSE / SLES"

        1. Add Enclave’s repository to rpm sources

                sudo zypper addrepo https://packages.enclave.io/rpm/enclave.repo

        2. Install Enclave

                sudo zypper install enclave

        3. Enrol

                sudo enclave enrol

        4. Provide your `Quick Start Key` to complete the installation

    === "Other"

        === "Arch Linux"

            <small>Requires at least Arch Linux 2020.08.01.</small>

            1. Install Enclave using our quick-start script

                    bash <(curl -Ss https://install.enclave.io/setup.sh)

            2. Provide your `Quick Start Key` to complete the installation

=== "Containers"

    Select your platform:

    === "Docker"

        1. Create a `docker-compose.yml` file:

            ```yaml
            version: '3.1'

            services:
              enclave-fabric:
                container_name: fabric
                image: enclavenetworks/enclave:latest
                restart: always

                cap_add:
                  - NET_ADMIN
                devices:
                  - /dev/net/tun
                environment:
                  ENCLAVE_ENROLMENT_KEY: XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
                volumes:
                  - enclave-config:/etc/enclave/profiles
                  - enclave-logs:/var/log/enclave

            volumes:
              enclave-config:
              enclave-logs:
            ```

        2. Replace `XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` with your `Quick Start Key`

        3. Bring the container up using `docker-compose up -d`

        4. Verify Enclave is running insider the container with `docker exec fabric enclave status`

    === "Kubernetes"

        1. Add the **enclave-sidecar** to your pod yaml file under the `containers:` section. For example, if your pod contains an nginx container:

            ```yaml
            spec:
              containers:
              - name: nginx-container
                image: nginx:1.7.9
                ports:
                  - containerPort: 80
            ```

             Add the **enclave-sidecar** definition to below your existing pod:

            ```yaml
            spec:
              containers:
              - name: nginx-container
                ...
                
              - name: enclave-sidecar
                image: enclavenetworks/enclave:latest
                env:
                  - name: "ENCLAVE_ENROLMENT_KEY"
                    value: "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
                securityContext:
                  capabilities:
                    add: ['NET_ADMIN']
                volumeMounts:
                  - name: tun
                    mountPath: /dev/net/tun
              volumes:
                - name: tun
                  hostPath:
                    type: 'CharDevice'
                    path: /dev/net/tun
            ```

            > See [pod.yaml](https://github.com/enclave-networks/kubernetes/blob/main/examples/nginx-enclave-sidecar/pod.yaml) for a complete example. 

        2. Replace `XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` with your `Quick Start Key`

        3. Push your changes to the cluster using `kubectl apply` or your preferred method

=== "Network Attached Storage"

    Select your device:

    === "Synology NAS"

        1. We have beta support for Synology NAS drives (running on DSM 7.0 or later) via docker. Please follow our guide to [installing Enclave on your Synology NAS drive](/tutorials/how-to-securely-access-your-synology-nas-drive-with-enclave/).

**Congratulations!** You've successfully enrolled a new system to your Enclave account. Once you've enrolled at least two systems, continue by [attaching tags](/getting-started/attach-tags) to your newly enrolled systems.





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
      document.getElementById("windows-hash-alg").innerHTML = hashAlg.toLowerCase();
      document.getElementById("windows-checksum").innerHTML = base64ToHex(hash);
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
