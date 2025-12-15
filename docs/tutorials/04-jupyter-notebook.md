# Jupyter Notebook

## Description

Many people use [jupyter notebooks](https://jupyter.org/) for writing and running python code - especially when doing data science tasks. This tutorial will show you how to take a jupyter notebook which is running on your own computer and run it on ENUCC.

---

## Prerequisites

You should know the basics of creating and submitting jobs to ENUCC. You should also know a bit about creating and running jupyter notebooks.

---

I have set up an example notebook which can be [obtained from github](https://github.com/SCEBE-Technicians/ENUCC-jupyter-notebook-example). In a real usage scenario we might expect the notebook to do some heavy number crunchy, or neural network training, but here it simply generates a graph and puts it in the figures subdirectory. We're happy that the notebook works on the local machine, but it takes a long time and so we'd rather offload the effort to ENUCC. The first step is to clone the repository:

```bash
$ cd projects
$ git clone git@github.com:SCEBE-Technicians/ENUCC-jupyter-notebook-example.git
```

If you've never used conda on ENUCC before then you'll need to do some setup. First load the conda module and then initialise it.

```bash
$ module load apps/anaconda3
$ conda init bash
```

You'll have to restart the shell for these changes to take effect (the easiest way is to log out and back in).

Now, in the repository that you cloned previously, there is a conda environment already defined. You can create a new conda environment from an `env.yml` file by running

```
$ cd ~/projects/ENUCC-jupyter-notebook-example
$ conda env create -f env.yml
$ conda activate jupyter-example
```

This environment has all the dependencies you'll need already installed, namely [jupyter](https://jupyter.org/), [numpy](https://numpy.org/) and [matplotlib](https://matplotlib.org/).

We are now in a position to execute the notebook. This is really quite straightforward. If there is a free compute node (run `squeue` to check) then we can run it as follows.

```bash
$ srun --time=00:15:00 jupyter execute NoisySine.ipynb
srun --time=00:15:00 jupyter execute NoisySine.ipynb
[NbClientApp] Executing NoisySine.ipynb
...
```

You can then check in the `./figures` directory to see that a new figure has been added.

As usual, `srun` is handy if there is a free compute node and your script won't take too long to run, but it's better to create a batch script if it is a long-running script, or if you expect it to be queued for a while.

```bash
#!/bin/bash
#SBATCH --ntasks 1
#SBATCH --nodes 1
#SBATCH --cpus-per-task 1
#SBATCH --time=00:15:00

jupyter execute NoisySine.ipynb
```

### Configuring conda

You have some options for using conda with ENUCC. If you find your environments are getting to be too big then you can move your modules to a location within shared scratch

```bash
$ conda config --add pkg_dirs sharedscratch/.conda/pkgs
$ conda config --add envs_dirs sharedscratch/.conda/envs
```

You can also disable the base env being activated upon login.

```bash
$ conda config --set auto_activate_base false
```

