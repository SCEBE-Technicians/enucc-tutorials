This site contains tutorials for mini-projects which are to be run on the Edinburgh Napier University Compute Cluster (ENUCC). These tutorials aim to be

- Small - the projects are toy-projects meant to illustrate a single concept.
- Self contained - the projects should be able to be run from start to finis, with no steps left implicit.
- Useful - by completing the tutorial you will develop skills which will be useful in a more complex piece of work.

### Want a tutorial run as an interactive session?
If you want a tutorial to be run as an interactive session for multiple people, email l.headley@napier.ac.uk.

### Problems
If you encounter any problems then please either [raise an issue](https://github.com/SCEBE-Technicians/enucc-tutorials/issues) on the github page or contact l.headley@napier.ac.uk.

## Quickstart

If you have a fresh account and are looking to get started as quickly as possible then follow these steps

```bash
# Activate the flight environment
$ flight env activate gridware

# Load Anaconda
$ module load apps/anaconda3

## Run a quick script on a compute node, time limits are required by the scheduling policy
$ srun --time=00:01:20 ./script

## Submit a batch file
$ sbatch batch_file.sh

```
