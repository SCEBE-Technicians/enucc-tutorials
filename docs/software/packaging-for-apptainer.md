# Packaging Software for Apptainer

This is a short outline for turning a software installation into an Apptainer container, using RASPA3 as an example.

You can find the raspa3 example here: [https://github.com/SCEBE-Technicians/apptainer/tree/main/raspa3](https://github.com/SCEBE-Technicians/apptainer/tree/main/raspa3).

## 1. Locate a supported OS

Check the software's installation instructions for supported Linux distributions, versions and build tools. For example, the [RASPA3 installation guide](https://github.com/iRASPA/RASPA3/blob/main/INSTALLATION.md) includes an Ubuntu 24.04 build. Use instructions and compiler/CMake versions that match your chosen software release. 

## 2. Pull the Docker image

Download the corresponding base OS image:

```bash
docker pull ubuntu:24.04
```

## 3. Try the installation with Docker

Start an interactive container:

```bash
docker run --rm --name raspa3-install -it ubuntu:24.04 bash
```

!!! warning

    `--rm` will remove the container on exit.
    Record all install commands outside of the container.
    

Inside it, run `apt-get update`, then follow the software's installation commands. You are already root, so omit `sudo`. Check that a small example works and record the successful commands before typing `exit`.

## 4. Create a Dockerfile from the commands

Turn the working installation into a file named `Dockerfile`. Start with `FROM ubuntu:24.04`, put package installation and build commands in `RUN` instructions, use `WORKDIR` for directory changes, and `ENV` for required runtime variables.

For RASPA3, this means installing the dependencies, downloading a specific release or commit, then running the matching CMake preset, build and install commands. Keep the software version fixed so future builds use the same source. See the [Dockerfile reference](https://docs.docker.com/reference/dockerfile/) for syntax.

## 5. Build the Docker image

From the directory containing your Dockerfile:

```bash
docker build -t raspa3:local .
```

This repeats the installation from the Dockerfile; it does not include changes made only in the interactive container.

## 6. Convert to Apptainer

Save the built image:

```bash
docker save -o raspa3.tar raspa3:local
```

Transfer `raspa3.tar` to the HPC, then convert it to a SIF file:

```bash
module load apps/apptainer
apptainer build raspa3.sif docker-archive:raspa3.tar
```

Test a small workload through Slurm using the [Using Apptainer guide](apptainer.md). See also Apptainer's [Docker archive documentation](https://apptainer.org/docs/user/latest/docker_and_oci.html#containers-in-docker-archive-files).
