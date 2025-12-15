# Hello World

## Description

In this project we will run a script which will write "Hello world!" to stdout. We look at running this script using `srun` and `sbatch`.

---  

## Prerequisites

All you need to follow this tutorial is an account and a way of sshing to the server. If you do not yet have an account [please request one](https://napier.unidesk.ac.uk/tas/public/ssp/content/detail/service?unid=d9e5b57bcd5748ad88cb09322905c9a6). To ssh from windows, we recommend using [PuTTY](https://putty.org/) (available through AppsAnywhere).

---  

> Code blocks in this document represent what you'll type into the terminal and also show you what you should see. Lines starting with a `$` are what you'll type (no need to type the `$`, it just represents the prompt) and lines which don't start with `$` are what you should see.

Let's start by logging in to ENUCC. If you are using Linux, you can log in using the following command in a terminal:
```bash
$ ssh USERNAME@login.enucc.napier.ac.uk
```

If you are on windows, check out [logging in with PuTTY](/useful-extras/logging-in-with-putty).

Organising your home directory is important. I recommend you make a projects directory which will contain all of your different projects. 
```bash
$ mkdir projects
$ cd projects
```

Then you can make a directory which will contain the code for this tutorial.
```bash
$ mkdir hello-world
$ cd hello-world
```

To print text to stdout (which will make it visible in your terminal) we will be using the `echo` command. Let's try it out.
```bash
$ echo Hello world!
Hello world!
```

In order to make this more reusable, we'll put it in a bash script. A bash script is a file which contains a series of bash commands, just like you would type into the terminal. To create a new file using the command line:
```
$ touch hello_world.sh
```

To edit your file you'll need to use a text editor. You have several options for editing a file on ENUCC. You can use either [nano](https://www.nano-editor.org/), [vim](https://www.vim.org/) or [emacs](https://www.gnu.org/software/emacs/). nano is the easiest to get started with. Open a file with `nano filename`, edit it, using the arrow keys to navigate, "ctrl + O" to write the file (it will ask for the name, press enter to accept) and "ctrl + X" to exit the editor. Check out [this cheetsheet](https://www.nano-editor.org/dist/latest/cheatsheet.html) for more info.

Edit your `hello_world.sh` file and put the following into it:

```
#!/bin/bash

echo Hello world!
```

At this point you might be asking yourself why we've added an extra line at the top of the file. This is called a [shebang interpreter directive](https://en.wikipedia.org/wiki/Shebang_%28Unix%29) and it is used to tell the operating system what interpreter to use to run the script. The shebang we've used says to use the [bash shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), installed at `/bin/bash`. Don't worry if this is a bit confusing, just know that you need that line at the top of the script for it to run correctly.

In order to execute the file, you'll need to make it executable. We edit the file permissions using the `chmod` command.

```
$ chmod u+x hello_world.sh
```
This makes it executable for the current user only (hence the u+x). Now let's run the file.

```
$ ./hello_world.sh
Hello world!
```

We've just run our first bit of code on ENUCC! Well done! But don't get too excited yet - we've only run it on the login node. ENUCC consists of several nodes which you can think of as separate computers with a very fast network connection between them. There are different types of node with different properties and here we'll talk about two such nodes: compute and login. There is one login node, which is used by all users as the entrypoint to the system. Login nodes however are quite minimally provisioned - they have only 4 cpus and 8gb of RAM. If lots of people were to run computationally intensive tasks on the login node it would lead to the system being unusable.

Compute nodes on the other hand are built to deal with computationally intensive tasks. They have 64 cpus and 512gb of RAM. However you cannot use them directly like you used the login node. We use a program called [slurm](https://slurm.schedmd.com/) as our cluster management and job scheduling system. Slurm provides a program called `srun` which can be used to run your scripts on the compute nodes. Let's run this now.

```
$ srun --ntasks 1 --cpus-per-task 1 --time=00:00:30 ./hello_world.sh
srun: job 27870 queued and waiting for resources
srun: job 27870 has been allocated resources
Hello world!
```

Here we've used the srun command with two flags. The first flag says we only have one task to run and the second indicates that we only want one cpu for this task, the third flag is a required time limit for the job. Specifying these flags means that other users will be able to run programs on the unused cpus on the same node. There are many more flags for srun which might be useful for your work. Check out [the docs](https://slurm.schedmd.com/srun.html) for more information.

It's great that we can now run programs on the compute nodes, but what if we want to leave a job running for a long time and don't want to stay logged in while it's running? This is where the `sbatch` command comes in. `sbatch` lets you submit a job to ENUCC and slurm will run it when the resources become available. Once you submit a job with `sbatch` you do not need to stay logged in. A batch file is just like a regular bash file with some special directives. Let's edit `hello_world.sh` to convert it to a batch script.

```
#!/bin/bash
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --time=00:00:30

echo Hello world!
```

Now all we need to do is use the `sbatch` command to submit it to the job queue. The script has a time limit of 30 seconds, though it should be finished nearly instantly. Time limits are required to run jobs using the scheduler, you can assign any limit you like but there may be upper limits depending on the partition (24 hours for the short partition, 7 days for the long partition and 3 days for the rest).

```
$ sbatch hello_world.sh
Submitted batch job 27872
```

It's been submitted, but where is our output? Since we might not be logged in when it runs, slurm will not allow the job to print to our terminal. Instead it will redirect any output to a file. That file will be in the working directory from which you call the `sbatch` command. We can see our output by using the cat command on the output file, which by default is called `slurm-<JOB_ID>.out`.

```
$ cat slurm-27872.out
Hello world!
```

## How is this useful?

The process you used to run this simple script on the cluster is exactly the same as the process you'd use to run any script which would run on a single node. You can change the bash script to run python scripts, organise files or otherwise automate your computational workloads.

Looking for a next step? Try running some scripts you'd normally run locally on ENUCC instead. Use a batch script to run them overnight.

