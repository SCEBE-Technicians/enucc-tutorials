# Message Passing Programming

## Description

Compute nodes on ENUCC each have 64 cores which have access to shared memory. When looking to run a job with more than 64 cores, we have to use multiple nodes, but separate nodes do not have shared memory. We need to use message passing programming to send information between nodes. We will be exploring the basics of message passing programming with [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface).

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

## Next steps

##Acknowledgements
