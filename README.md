# Slurm Kube

Full credit to
[Slurm Docker Cluster](https://github.com/giovtorres/slurm-docker-cluster).
**Slurm Kube** borrows heavily in implementing a multi-container Slurm cluster
designed for rapid deployment using
[podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube-play.1.html).
This repository simplifies the process of setting up a robust Slurm environment for
development, testing, or lightweight usage.

## 🏁 Getting Started

To get up and running with Slurm in Podman, make sure you have
[Podman installed](https://podman.io/docs/installation).

Clone the repository:

```bash
git clone https://github.com/brian-mcclune-nnl/slurm-kube.git
cd slurm-kube
```

## 📦 Containers and Volumes

This setup consists of the following deployments:

- **mariadb**: Stores job and cluster data.
- **slurmdbd**: Manages the Slurm database.
- **slurmctld**: The Slurm controller responsible for job and resource management.
- **compute1, compute2**: Compute nodes (running `slurmd`).

### Persistent Volumes:

- `etc_munge`: Mounted to `/etc/munge`
- `etc_slurm`: Mounted to `/etc/slurm`
- `slurm_jobdir`: Mounted to `/data`
- `var_lib_mysql`: Mounted to `/var/lib/mysql`
- `var_log_slurm`: Mounted to `/var/log/slurm`
- `mariadb-data` : for MariaDB data
- `slurmdbd-logs` : for slurmdbd logs
- `slurmctld-logs` : for slurmctld logs
- `compute1-logs` : for compute1 logs
- `compute2-logs` : for compute2 logs
- `slurm-data` : for job data, mounted to `slurmctld` and `compute1`, `compute2`

## 🛠️  Building the Image

Podman will build the image if it is not detected locally. To build it manually:

```sh
cd slurm-kube
podman build -t slurm-kube .
```

## 🚀 Starting the Cluster

Deploy the cluster using `podman kube play`:

```sh
podman kube play kube-play.yaml
```

This will start up all containers in detached mode. You can view the running
containers using:

```sh
podman container ls
```

## 🖥️  Accessing the Cluster

To interact with the Slurm controller, open a shell inside the `slurmctld`
deployment:

```sh
podman exec -it slurmctld-pod-slurmctld bash
```

Now you can run any Slurm command from inside the container:

```sh
[root@slurmctld-pod /]# sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug*       up   infinite      2   idle compute1-pod,compute2-pod
```

## 🧑‍💻 Submitting Jobs

The cluster mounts the `slurm-data` volume across `slurmctld` and `compute`
nodes, making job files accessible from the `/data` directory. To submit a job:

```sh
[root@slurmctld-pod /]# cd /data/
[root@slurmctld-pod data]# sbatch --wrap="cat /etc/hostname"
Submitted batch job 2
```

Check the output of the job:

```sh
[root@slurmctld-pod data]# cat slurm-2.out
compute1-pod
```

### Running as another user:

The cluster contains two users, `alice` and `bob`. To submit a job as `alice`:

```sh
[root@slurmctld-pod /]# su - alice
[alice@slurmctld-pod ~]$ cd /data/
[alice@slurmctld-pod data]$ sbatch --wrap="cat /etc/hostname"
Submitted batch job 3
```

## 🔄 Cluster Management

### Stopping and Restarting:

Stop the cluster without removing the persistent volumes:

```sh
podman kube play --down kube-play.yaml
```

Restart it later:

```sh
podman kube play kube-play.yaml
```

### Deleting the Cluster:

To completely remove the deployments and associated volumes:

```sh
podman kube play --down --force kube-play.yaml
```
