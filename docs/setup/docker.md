
# Docker

## Docker-compose

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

2. Replace `XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` with your `Default Enrolment Key`

3. Bring the container up using `docker-compose up -d`

4. Verify Enclave is running insider the container with `docker exec fabric enclave status`

## What to do if the install fails

For troubleshooting and errors, use the site search or visit our [troubleshooting](/kb/#troubleshooting) section to look for information about common error messages. If your installation fails and you are unable to resolve the problem by retrying, please contact <a href="mailto:support@enclave.io">support@enclave.io</a>.