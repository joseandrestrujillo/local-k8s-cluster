## Installation

To install the tool, it is recommended to clone the project from GitHub into the `/opt/local-k8s-cluster` directory:

```bash
git clone https://github.com/joseandrestrujillo/local-k8s-cluster.git /opt/local-k8s-cluster
```

Once the project is cloned, you must create a symbolic link to the `local-k8s-cluster` script so that it can be executed from anywhere on the system:

```bash
sudo ln -s /opt/local-k8s-cluster/local-k8s-cluster /usr/local/bin/local-k8s-cluster
```

## Usage

The tool provides the following commands:

- `deploy`: Deploys the Kubernetes cluster.
- `configure-kubectl`: Configures the `.kube/config` file to point to the local cluster.
- `stop`: Stops the Kubernetes cluster.
- `clear`: Deletes the Kubernetes cluster.

### Deploy

To deploy the cluster, you must run the following command

```bash
local-k8s-cluster deploy
```

This command will create two virtual machines with Vagrant and deploy the Kubernetes cluster with Ansible. The virtual machines will be created in the `/opt/local-k8s-cluster` directory with the names `master` and `worker`.

The `k8s-cluster.yml` file specifies the cluster configuration. The format of this file is as follows:

```yml
---
monitoring_tools: true
nodes:
  - name: master
    master: true
    memory: 2048
    cpus: 2
  - name: worker
    master: false
    memory: 2048
    cpus: 2
```

The `monitoring_tools` option specifies whether to install monitoring tools in the cluster.

The `nodes` section specifies the nodes in the cluster. Each node has the following attributes:

- `name`: The name of the node.
- `master`: Indicates whether the node is a master node.
- `memory`: The amount of memory allocated to the node.
- `cpus`: The number of CPUs allocated to the node.

### Configure kubectl

To configure the `.kube/config` file to point to the local cluster, you must run the following command:

```bash
local-k8s-cluster configure-kubectl
```

This command will copy the `kubeconfig` file from the local cluster to the `~/.kube` directory.

### Stop

To stop the cluster, you must run the following command:

```bash
local-k8s-cluster stop
```

This command will stop the virtual machines that make up the cluster.

### Delete

To delete the cluster, you must run the following command:

```bash
local-k8s-cluster clear
```

This command will delete the virtual machines that make up the cluster and the configuration files.

## Monitoring tools

To run the weave scope monitoring tool, you can run the following:

```bash
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
```

This command will open a local port on port 4040 that will connect to the weave scope monitoring server. You can access the monitoring server at the address http://localhost:4040.
