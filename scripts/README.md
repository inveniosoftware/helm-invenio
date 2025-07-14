# About scripts

This folders contains a collection of small scripts that might make your live easier when managing a kubernetes deployment.

## console.sh - Terminal Pod Management Script for Kubernetes

This script helps manage terminal pods in your Kubernetes cluster, providing an easy way to:

- Scale up the terminal pod to interact with your application
- Attach to the pod and run a shell or custom command
- Scale down the pod afterward, with an option to keep it running if desired

### Usage

#### Basic Command

Run the script to use the terminal pod in the current namespace with bash:

```sh
./console.sh
```

#### Specify a Namespace

Override the default namespace with --namespace:

```sh
./console.sh --namespace my-namespace
```

#### Specify a Custom Shell Command

Specify a custom shell or command with --shell:

```sh
./console.sh --shell "invenio shell"
```

#### Keep Pod Running After Use

If you want to keep the pod running after exiting the terminal, use the --keep flag:

```sh
./console.sh --keep
```
