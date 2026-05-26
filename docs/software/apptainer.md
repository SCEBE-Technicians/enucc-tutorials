---

# Using Apptainer

## Description

Apptainer allows you to run software inside containers on ENUCC. Containers package applications together with their dependencies, making it possible to run software that may not be available through Gridware modules or that requires a newer operating system environment.

A common use case is running software that requires newer versions of libraries, Python packages that are not available on the cluster, or applications distributed as Docker containers.

Containers run as your own user account and integrate cleanly with the Slurm scheduler.

---

## Prerequisites

Before using Apptainer you should:

* Have an ENUCC account
* Be familiar with submitting Slurm jobs using `srun` or `sbatch`
* Have sufficient storage available in your home directory or scratch space

If you are new to Slurm, complete the introductory hello world tutorial first. 

---

## Activating Gridware

Most software on ENUCC is provided through Gridware modules.

Check whether Gridware is active by looking at your shell prompt. If the prompt does not contain:

```text
<gridware{+}>
```

activate it using:

```bash
flight env activate gridware
```

---

## Loading the Apptainer Module

Load the Apptainer module:

```bash
module load apps/apptainer
```

Verify the installation:

```bash
apptainer --version
```

Example output:

```text
apptainer version 1.2.4
```

---

## Downloading a Container

Before a container can be used on nodes it must be downloaded locally.

Containers are stored as `.sif` (Singularity Image Format) files.

### Downloading from Docker Hub

The most common method is pulling directly from Docker Hub:

```bash
apptainer pull ubuntu-22.04.sif docker://ubuntu:22.04
```

This creates:

```text
ubuntu-22.04.sif
```

in the current directory.

### Choosing a Storage Location

Container images can be large. It is recommended that you store them in:

```text
~/sharedscratch
```

For example:

```bash
mkdir ~/sharedscratch/containers

apptainer pull \
    ~/sharedscratch/containers/ubuntu-22.04.sif \
    docker://ubuntu:22.04
```

---

## Inspecting a Container

You can view information about a container image:

```bash
apptainer inspect ubuntu-22.04.sif
```

To see the operating system inside the container:

```bash
apptainer exec ubuntu-22.04.sif cat /etc/os-release
```

Example output:

```text
PRETTY_NAME="Ubuntu 22.04.05 LTS"
```

---

## Running Commands Inside a Container

To execute multiple commands, start a shell inside the container.

### Using Bash

```bash
apptainer exec ubuntu-22.04.sif bash -lc '
hostname
whoami
'
```

The single quotes (`'`) mark the beginning and end of the commands that will run inside the container.

The `-l` option starts a login shell and `-c` tells Bash to execute the supplied commands.

### Using sh

Some minimal containers do not include Bash.

In that case:

```bash
apptainer exec alpine.sif sh -c '
uname -a
cat /etc/os-release
'
```

---

## Using Apptainer in a Slurm Job

Containers should be run inside Slurm jobs rather than on login nodes.

Example batch script:

```bash
#!/bin/bash
#SBATCH --job-name=apptainer-test
#SBATCH --partition=short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00

module load apps/apptainer

apptainer exec \
    ~/sharedscratch/containers/ubuntu-22.04.sif \
    bash -lc '
echo "Hostname: $(hostname)"'
```

Submit the job:

```bash
sbatch apptainer-test.sh
```

---

## Using Software Inside a Container

Applications installed inside the container can be executed directly.

!!! warning

    Only use this for testing. Do not run jobs on the login node.

For example, if Python is installed in the image:

```bash
apptainer exec ubuntu-22.04.sif python3 --version
```

Or to run a script:

```bash
apptainer exec ubuntu-22.04.sif python3 myscript.py
```

---

## Troubleshooting

### Container Will Not Download

Container downloads require internet access.

If compute nodes do not have internet access, download the container from the login node:

```bash
apptainer pull ubuntu-22.04.sif docker://ubuntu:22.04
```

and then use the resulting `.sif` file within your Slurm jobs.

### Command Not Found

Check whether the software exists inside the container:

```bash
apptainer exec ubuntu-22.04.sif which python3
```

---

## Summary

Apptainer provides a convenient way to run software in a portable, reproducible environment on ENUCC. The general workflow is:

1. Activate Gridware.
2. Load the Apptainer module.
3. Download a container image.
4. Run commands using `apptainer exec`.
5. Submit containerised workloads through Slurm.

For most users, a typical workflow looks like:

```bash
flight env activate gridware
module load apps/apptainer

apptainer pull \
    ~/sharedscratch/containers/ubuntu-22.04.sif \
    docker://ubuntu:22.04

apptainer exec \
    ~/sharedscratch/containers/ubuntu-22.04.sif \
    bash -lc 'ldd --version'
```

This provides an isolated environment while still using ENUCC resources and Slurm scheduling.
