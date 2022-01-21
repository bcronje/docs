
# Kubernetes

## Sidecar

1. Add Enclave as a sidecar to your pod yaml file under the `containers:` section. For example, if your pod contains an nginx container:

    ```yaml
    spec:
      containers:
      - name: nginx-container
        image: nginx:1.7.9
        ports:
          - containerPort: 80
    ```

      Add the following `enclave-sidecar` and `volumes` definitions to the `containers` section in your existing yaml deployment:

    ```yaml
    spec:
      containers:
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

    > See [deployment.yaml](https://github.com/enclave-networks/kubernetes/blob/main/examples/nginx-enclave-sidecar/deployment.yaml) for a complete example. 

2. Replace `XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` with your `Default Enrolment Key`

3. Push your changes to the cluster using `kubectl apply` or your preferred method

## What to do if the install fails

For troubleshooting and errors, use the site search or visit our [troubleshooting](/kb/#troubleshooting) section to look for information about common error messages. If your installation fails and you are unable to resolve the problem by retrying, please contact <a href="mailto:support@enclave.io">support@enclave.io</a>.