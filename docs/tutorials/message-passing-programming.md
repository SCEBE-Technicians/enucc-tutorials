# Message Passing Programming

<span style="color:red"> This is a work in progress. </span>

## Description

Compute nodes on ENUCC each have 64 cores which have access to shared memory. When looking to run a job with more than 64 cores, we have to use multiple nodes, but separate nodes do not have shared memory. We need to use message passing programming to send information between nodes. We will be exploring the basics of message passing programming with [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface). The goal with this tutorial is to give you a taste of MPI programming along with an understanding of its capabilities so that you can understand whether it will be useful for future applications. This is not a comprehensive course.

---

## Prerequisites

You should be comfortable using slurm to submit batch scripts. You should have a basic knowledge of the C programming language. Here is a [quick reference](https://quickref.me/c.html) in case you aren't used to programming in C. If have strong programming skills in a higher level programming language such as python you will probably still be able to follow along but some concepts in C such as pointers do not have an analogue in python.

---

Message passing programming allows us to run a program with a very large number of cpus which do not necessarily have access to shared memory. Our program runs on several processes which can communicate with each other by passing messages. Let's start with a basic hello world program. Create a `hello_world.c` file with the following contents

```c
#include <stdio>
#include <mpi.h>

int main (int argc, char **argv) {
    int ierr = MPI_Init(&argc, &argv);
    printf("Hello world\n");

    return MPI_Finalize();
}
```

## Ping Pong

```c
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
    const int PING_PONG_LIMIT = 10;

    MPI_Init(NULL, NULL);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    if (world_size != 2) {
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    int ping_pong_count = 0;
    int partner_rank = (world_rank + 1) % 2;

    while(ping_pong_count < PING_PONG_LIMIT) {
        if (world_rank == ping_pong_count % 2) {
            ping_pong_count++;

            MPI_Send(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD);
            printf("%d sent from %d to %d\n", ping_pong_count, world_rank, partner_rank);
        } else {
            MPI_Recv(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("%d received from %d on %d\n", ping_pong_count, world_rank, partner_rank);
        }
    }
    MPI_Finalize();
}
```

Challenge: implement a ring-pong program where instead of two processes, you have an arbitrary number of processes which pass a value around in a ring.

## 1D Ising Model



## Next steps

## Useful resources

- [MPI Tutorial](https://mpitutorial.com/tutorials/)
- [Intro to MPI](http://condor.cc.ku.edu/~grobe/docs/intro-MPI-C.shtml)
- [Introduction to slurm and mpi](https://batchdocs.web.cern.ch/linuxhpc/introduction.html)
