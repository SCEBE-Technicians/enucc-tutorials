# Hello MPI!

## Description

This is the first tutorial in a series which covers message passing programming. This tutorial looks at getting started with compiling and running an MPI program. All code can be found in [this repository](https://github.com/SCEBE-Technicians/message-passing-programming).


## Prerequisites

You should have a good understanding of C. If not then I recommend "The C Programming Language" by Ritchie and Kernighan.

---

Message passing programming allows us to run a program with a very large number of cpus which do not necessarily have access to shared memory. Our program runs on several processes which can communicate with each other by sending messages which contain data. We will be using the [OpenMPI](https://www.open-mpi.org/) implementation of the [Message Passing Interface (MPI)](https://en.wikipedia.org/wiki/Message_Passing_Interface) standard to implement algorithms and run them on the cluster. Let's start with a basic hello world program. Create a `hello_world.c` file with the following contents

```c
#include <stdio.h>
#include <mpi.h>

int main (int argc, char **argv) {
    MPI_Init(NULL, NULL);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    printf("Hello world from rank %d of %d\n", rank, world_size);

    return MPI_Finalize();
}
```

Hopefully this program is fairly self explanatory but let's see what is included. Most of what is included here is boilerplate that needs to be included in any MPI program. We first need to include the mpi header file. Then we initialise MPI with the `MPI_Init(NULL, NULL)` command. MPI works by running several copies of the same process concurrently. We can differentiate each process by its rank - a number which acts as a unique identifier for each process. We find the rank by calling `MPI_Comm_rank(MPI_COMM_WORLD, &rank)`. The first argument specifies that we are addressing all processes. The second argument is a pointer to an int where the rank will be stored. It is a very common pattern with MPI functions that we first initialize a variable and then pass a pointer to that variable to a function which will initialise it.

The exact same pattern is used to get `world_size` which tells how many processes the program is running on. Finally we have to run `MPI_Finalize()` at the end of the program to ensure that the process exits correctly.

in order to compile mpi programs we use the `mpicc` compiler rather than `gcc`. You'll also have to load the mpi module.

```
$ module load mpi
$ mpicc hello_world.c -o hello_world
```

We use the `mpirun` command to run it. As per usual, we need to use either `sbatch` or `srun` to run programs on the compute nodes. Here's a batch file which will run the compiled `hello_world` binary.

```
#!/bin/bash -l
#SBATCH -o hello_world.output
#SBATCH -J mpi-test
#SBATCH --time=5
#SBATCH --mem=256
#SBATCH --nodes=1
#SBATCH --ntasks=4

mpirun hello_world
```

## Exercises

Here are some simple ideas for getting practice with MPI:

- Write a program which prints a different message on each process.
- Write a program which uses MPI_Abort to exit gracefully unless there are 4 processes running.

