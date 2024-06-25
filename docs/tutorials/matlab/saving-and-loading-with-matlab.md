#Saving and Loading your Workspace

## Description

This tutorial shows a simple workflow for doing intensive computations on the server and accessing the results from your local machine.

## Prerequisites

You should have some knowledge of matlab and how to write and submit batch files using slurm.

---

When working with matlab on ENUCC, you will probably want to do all of the intensive computation on the server. However, when exploring the results and producing figures, it is good to be able to work on your own machine. This tutorial will illustrate how to save results from a simulation to a file and then how to load that file from another location in order to access the results.

The example project we'll use will be a program which computes every prime number up to a given integer. The project is split into two separate files. First create a directory to store the project:

```bash
$ mkdir ~/projects/prime-finder
$ cd ~/projects/prime-finder
$ mkdir output
```

We also created a folder to store the output of the program.

In order to use matlab we must load the correct module
```bash
$ module load apps/matlab
```

The code for this project is split into two separate files. The first file is called `is_integer_prime.m` and it contains code to check whether a given integer is prime or not.

```matlab
function result = is_integer_prime(x)
    for i = 2:ceil(sqrt(x))
        if mod(x, i) == 0
            result = false;
            return
        end
    end
    result = true;
end
```

This is quite a simple function which will check if any number below the square root of x divides x exactly. If it does then it returns false. Otherwise it returns true. Note that when putting matlab functions into separate files it is important that the filename and function name are the same.

The other file which we need will use the `is_integer_prime` function to check all numbers up to a given number. This file will be called `prime_finder.m` and have the following code
```matlab
function [] = prime_finder(x)
    list_of_primes = [];
    for i = 1:x
        if is_integer_prime(i)
            list_of_primes = [list_of_primes i];
            fprintf('%d is prime\n', i)
        else
            fprintf('%d is not prime\n', i)
        end
    end
    save(sprintf('output/primes_up_to_%d.MAT', x))
    exit;
end
```
This is a bit more complicated. We have an empty array called `list_of_primes`. We loop through all numbers up to x and if the number is prime we append the value to `list_of_primes`. We also print some information to the console so we can see how the program is running. If efficiency were a big concern then it would be a good idea to remove the print statements.

Finally we call the function `save` which will save all the variables in the workspace to a file called `output/primes_up_to_x.MAT` where it replaces x with the value. 

In order to run this code we create a batch file called `batch.sh`

```bash
#!/bin/bash

matlab -nodesktop -r "prime_finder(1000000)"
```

Queue the batch file to be executed using `sbatch batch.sh`.

You can see the output has been saved by running `ls output`. You can also see the printed statements in a file called `slurm-xxxx.out`.

We can move the output file from the server to the local machine either using the [MobaXTerm](../../../useful-extras/mobaxterm/) file browser or something like rsync or scp. Move the file to a Matlab workspace and you can use the following script to plot a histogram showing the density of primes. 

```matlab
function [] = plot()
    load('output/primes_up_to_1000000.MAT');
    histogram(list_of_primes);
    saveas(gcf, 'figures/histogram_of_primes.svg');
end
```
