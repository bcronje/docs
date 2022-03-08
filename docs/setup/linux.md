# Linux

## Installation

=== "Ubuntu / Debian / Raspbian"

    <small>Requires at least Ubuntu 14.04 LTS or Debian 9 or Raspbian 10.</small> 

    1. Install apt-transport-https
                
            sudo apt install apt-transport-https

    2. Add Enclave’s package signing key and repository to apt sources

            curl -fsSL https://packages.enclave.io/apt/enclave.stable.gpg  | sudo gpg --dearmor -o /usr/share/keyrings/enclave.gpg

            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/enclave.gpg] https://packages.enclave.io/apt stable main" | \
              sudo tee /etc/apt/sources.list.d/enclave.stable.list
              
            sudo apt update

    3. Install Enclave

            sudo apt install enclave

     4. Enrol

            sudo enclave enrol

    5. Provide your `Default Enrolment Key` to complete the installation

=== "CentOS / RHEL / Fedora"

    Select your version:

    === "CentOS / RHEL 7"

        1. Install Enclave using our quick-start script

                bash <(curl -Ss https://install.enclave.io/setup.sh)

        2. Provide your `Default Enrolment Key` to complete the installation

    === "CentOS / RHEL 8"

        <small>Requires at least CentOS or RHEL 8.</small>

        1. Add Enclave’s repository to rpm sources

                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager --add-repo https://packages.enclave.io/rpm/enclave.repo

        2. Install Enclave

                sudo dnf install enclave

        3. Enrol

                sudo enclave enrol

        4. Provide your `Default Enrolment Key` to complete the installation

    === "Fedora"

        <small>Requires at least Fedora 32.</small>

        1. Add Enclave’s repository to rpm sources

                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager --add-repo https://packages.enclave.io/rpm/enclave.repo

        2. Install Enclave

                sudo dnf install enclave

        3. Enrol

                sudo enclave enrol

        4. Provide your `Default Enrolment Key` to complete the installation

=== "Amazon Linux"

    <small>Requires at least Amazon Linux 2018.03.</small> 

    1. Install Enclave using our quick-start script

            bash <(curl -Ss https://install.enclave.io/setup.sh)

    2. Provide your `Default Enrolment Key` to complete the installation
   
=== "OpenSUSE / SLES"

    1. Add Enclave’s repository to rpm sources

            sudo zypper addrepo https://packages.enclave.io/rpm/enclave.repo

    2. Install Enclave

            sudo zypper install enclave

    3. Enrol

            sudo enclave enrol

    4. Provide your `Default Enrolment Key` to complete the installation
   

=== "Other"

    === "Arch Linux"

        <small>Requires at least Arch Linux 2020.08.01.</small>

        1. Install Enclave using our quick-start script

                bash <(curl -Ss https://install.enclave.io/setup.sh)

        2. Provide your `Default Enrolment Key` to complete the installation

## Unattended installation

Enclave supports unattended installations by setting the Enrolment Key in a specially named environment variable: `ENCLAVE_ENROLMENT_KEY`. 

1. Set the Enrolment Key you want to use as an environment variable
    ```
    $ export ENCLAVE_ENROLMENT_KEY=XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
    ```

2. Enrol the system using `enclave enrol`. If you're using `sudo` don't forget to include the `-E` argument (also `--preserve-env`) to preserve environment variables.
    ```
    $ sudo -E enclave enrol
    ```

3. Enclave will automatically enrol and daemonise as a background process.

## Starting and stopping Enclave

The Enclave installer creates a lightweight supervisor service set to run at system start which is responsible for starting the Enclave fabric. The supervisor service exists to start, stop and restart Enclave fabric in the background as daemon child processes.

The supervisor service responds to the Enclave CLI verbs `start` and `stop` to control the Fabric.

## Updating Enclave

=== "Ubuntu / Debian / Raspbian"

    Enclave is updated using the standard apt package manager.

        sudo apt install enclave
 
    > **Warning:** During updates, the Enclave service will restart. This can cause SSH sessions established over the Enclave tunnel to disconnect and the apt operation to terminate prior to completion. To avoid this, we suggest launching apt install using nohup so even if the SSH session disconnects, the upgrade operation will continue in the background. `sudo nohup apt install enclave`

=== "Fedora / CentOS 8 / RHEL 8"

    Enclave is updated using the standard apt package manager.

        sudo dnf update enclave
 
    > **Warning:** During updates, the Enclave service will restart. This can cause SSH sessions established over the Enclave tunnel to disconnect and the apt operation to terminate prior to completion. To avoid this, we suggest launching dnf update using nohup so even if the SSH session disconnects, the upgrade operation will continue in the background. `sudo nohup dnf update enclave`

=== "OpenSUSE / SLES"

    Enclave is updated using the standard apt package manager.

        sudo zypper install enclave
 
    > **Warning:** During updates, the Enclave service will restart. This can cause SSH sessions established over the Enclave tunnel to disconnect and the apt operation to terminate prior to completion. To avoid this, we suggest launching zypper install  using nohup so even if the SSH session disconnects, the upgrade operation will continue in the background. `sudo nohup zypper install enclave`

=== "Other OS"

    Upgrade to the latest version of Enclave by running our quick-start script.

        bash <(curl -Ss https://install.enclave.io/setup.sh)

## Uninstalling Enclave

=== "Ubuntu / Debian / Raspbian"

    Remove the Enclave package while leaving configuration files on the system.

        sudo apt remove enclave

    Remove the Enclave package and any configuration files (including private any keys generated during enrolment).

        sudo apt purge enclave

    > **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.

=== "Fedora / CentOS 8 / RHEL 8"

    Remove the Enclave package while leaving configuration files on the system.

        sudo dnf remove enclave
 
    > **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.

=== "OpenSUSE / SLES"

    Remove the Enclave package while leaving configuration files on the system.

        sudo zypper remove enclave
    
    > **Note:** Enclave does not backup a system's private keys. Lost or deleted private keys are not recoverable. If a system's configuration and private keys are lost, to use that system with Enclave again it must be re-enrolled.

## What to do if the install fails

If an install goes horribly wrong or is interrupted, try re-running the Enclave `setup.sh` script to restart the process. If your installation fails and you are unable to resolve the problem by retrying, please contact <a href="mailto:support@enclave.io">support@enclave.io</a>.

For troubleshooting and errors, use the site search or visit our [troubleshooting](/kb/#troubleshooting) section to look for information about common error messages.