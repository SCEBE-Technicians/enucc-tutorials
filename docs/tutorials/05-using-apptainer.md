# Using Apptainer

## Description

We look at how to run a script using apptainer, a containerisation platform for HPC workloads.

## Prerequisites

None.

---

Containerisation is a software development process which allows software developers to create a reproducible and cross-platform environment in which their software can run. It is an excellent tool for research as it allows results to be recreated regardless of system differences. It is also useful when running code on ENUCC as it allows you to run software which is not readily available in one of the installed modules.

As an example, let's say we have a [node.js](https://nodejs.org/en) script which we want to run. Here is an example script called `hello.js`.
```
console.log("Hello")
```

This example simply prints the word hello. Normally we'd run it with `node hello.js`, but on ENUCC, node isn't installed. We could install it using [anaconda](https://anaconda.org/conda-forge/nodejs), but here we're going to take a different approach.

We first need to build an apptainer container based on the [node docker container](https://hub.docker.com/_/node).

```bash
$ module load apps/apptainer
$ apptainer build node.sif docker://node
```

You can see that the image is stored in a file in your current directory called node.sif. We now need to run our application on the container.

```bash
$ srun apptainer run node.sif hello.js
```
