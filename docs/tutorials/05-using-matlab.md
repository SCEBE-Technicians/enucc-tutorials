# Using Matlab

## Description

## Prerequisites

It is highly recommended that you do the [Hello World](/tutorials/01-hello-world) tutorial before doing this tutorial. 

---

> In code blocks, lines starting with `$` are lines that you execute. Don't type the dollar since it represents the prompt. Lines that don't start with a `$` are lines that you should see after executing the command.

In order to use matlab the first thing you'll have to do is load the matlab module.

```bash
$ module load apps/matlab
apps/matlab/r2023b
 |
  OK
```

Then let's create a folder to store our work and cd into it
```
$ mkdir -p projects/matlab-example
$ cd projects/matlab-example
```

Create a file called `script.m` with the following contents.

```matlab
x = linspace(0, 10);

y = sin(x);

plot(x, y);

saveas(gcf, 'graph', 'svg');
fprintf('Saved figure as graph.svg\n')
exit
```

The batch script to submit the job is fairly simple. Put the following into a file called `batch.sh`.

```
#!/bin/bash

matlab -nodesktop -r script
```

You can submit the job to the queue by running
```bash
$ sbatch batch.sh
```

We need to pass the `-nodesktop` flag to stop it from starting the GUI and the `-r` flag to specify that we want to run a script.

You'll see the ouput in an file called `job-XXXXX.out`
