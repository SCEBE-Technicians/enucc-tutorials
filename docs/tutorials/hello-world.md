# Hello World

## Description
In this project we will run a script which will write "Hello world!" to stdout. We look at running this script using `srun` and `sbatch`.

## Prerequisites
All you need to follow is this tutorial is an account and a way of sshing to the server. If you do not yet have an account [please request one](https://staff.napier.ac.uk/services/cit/Pages/ENU-Compute-Cluster.aspx). To ssh from windows, we recommend using
---  
> Code blocks in this document represent what you'll type into the terminal and show you what you should see. Lines starting with a `$` are what you'll type (no need to type the `$`, it just represents the prompt) and lines which don't start with `$` are what you should see.

Let's start by logging in to ENUCC.
```bash
$ ssh USERNAME@login.enucc.napier.ac.uk
```

Organising your home directory is important. I recommend you make a projects directory which will contain all of your projects. 
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

In order to make this more reproducible, we'll put it in a bash script. A bash script is a file which contains a series of bash commands, just like you would type into the terminal. To create a new file using the command line:
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

## How is this useful?

The process you used to run this simple script on the cluster is exactly the same as the process you'd use to run any script which would run on a single node. You can change the bash script to run python scripts, organise files or otherwise automate your computational workloads.

Looking for a next step? Try running some python analysis on the cluster.

