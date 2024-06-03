# Message Passing Programming

<span style="color:red"> This is a work in progress. </span>

## Description

Compute nodes on ENUCC each have up to 64 cores which have access to shared memory. When looking to run a job with more than 64 cores, we have to use multiple nodes, but separate nodes do not have shared memory. We need to use message passing programming to send information between nodes. We will be exploring the basics of message passing programming with [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface). The goal with this tutorial is to give you a taste of MPI programming along with an understanding of its capabilities so that you can understand whether it will be useful for future applications. This is not a comprehensive course.

---

## Prerequisites

You should be comfortable using slurm to submit batch scripts. You should have a basic knowledge of the C programming language. Here is a [quick reference](https://quickref.me/c.html) in case you aren't used to programming in C. If have strong programming skills in a higher level programming language such as python you will probably still be able to follow along but some concepts in C such as pointers do not have an analogue in python.

---

Message passing programming allows us to run a program with a very large number of cpus which do not necessarily have access to shared memory. Our program runs on several processes which can communicate with each other by passing messages. Let's start with a basic hello world program. Create a `hello_world.c` file with the following contents

```c
#include <stdio.h>
#include <mpi.h>

int main (int argc, char **argv) {
    MPI_Init(NULL, NULL);
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    printf("Hello world from rank %d\n", world_rank);

    return MPI_Finalize();
}
```

in order to compile mpi programs we use the `mpicc` compile rather than `gcc`. You'll also have to load the mpi module.

```
$ module load mpi
$ mpicc hello_world.c -o hello_world
```
 We use the `mpirun` command to run it. As per usual, we need to use either `sbatch` or `srun` to run programs on the compute nodes. Here's a batch file which will run the compiled `hello_world` binary.

```
#!/bin/bash -l
#SBATCH --export=ALL
#SBATCH -o hello_world.output
#SBATCH -J mpi-test
#SBATCH --time=0-1
#SBATCH --mem=1024
#SBATCH --nodes=1
#SBATCH --ntasks=4

# module load mpi/openmpi

mpirun hello_world
```

After submitting the script with `sbatch` we can inspect the output.

```
$ cat hello_world.output
Hello world from rank 0
Hello world from rank 1
Hello world from rank 2
Hello world from rank 3
```

We have run the task with four processes (by specifying `ntasks`) and it has printed a line on each of those processes.

So now we have four processes running simultaneously, how can we get them to talk to each other? We send and receive messages!

## Passing a message

Let's write a very basic program which will send an integer from rank 0 to rank 1. Let's look at the program first and then we'll look at what's going on.

```c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    MPI_Init(NULL, NULL);

    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        int send = 5;
        printf("Sending the number %d.\n", send);
        MPI_Send(&send, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } else if (rank == 1) {
        int rec;
        MPI_Recv(&rec, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Received the number %d.\n", rec);
    }
    MPI_Finalize();
}
```

Here we've used a few new methods, `MPI_Send` and `MPI_Recv`. All MPI methods typically follow a similar pattern. You can see the method definitions in the appendix. 

We call `MPI_Send` when we want to send data from one process to another. Then from the receiving process we need to call `MPI_Recv`. Since the same code will run for every process, we use `if` statements to send the message only on rank 0 and receive only on rank 1. There are some examples at the end of this tutorial which illustrate more interesting ways to use blocking communication.

## Using probe to get the message size

Let's say we want to send a string, but we don't know what size it's going to be. We can use `MPI_Probe` to get the size of the message.

```
#include <stdio.h>
#include <string.h>
#include <mpi.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv) {

    MPI_Init(NULL, NULL);

    // Initialise rank and world size
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Need at least 2 processes
    if (world_size < 2) {
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

        if (rank == 0) {
        // Choose one of four animals
        srand(time(NULL));
        char animals[4][10] = {"dog", "cat", "rat", "gorilla"};
        char animal[10];
        int index = rand() % 4;
        strcpy(animal, animals[index]);

        printf("\033[31mSending %s, of size %d\n", animal, strlen(animal));

        MPI_Send(animal, strlen(animal), MPI_CHAR, 1, 0, MPI_COMM_WORLD);
    } else if (rank == 1) {
        // Get message status
        MPI_Status stat;
        MPI_Probe(0, 0, MPI_COMM_WORLD, &stat);

        // Get message length from status
        int message_length;
        MPI_Get_count(&stat, MPI_CHAR, &message_length);
        printf("\033[32mReceiving message of length %d\n", message_length);

        // Receive message
        char message[message_length];
        MPI_Recv(&message, message_length, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Received %s from sender\033[0m\n", message);
    }

    MPI_Finalize();
}

```

## Broadcast

The broadcast is one of the collective communication methods. The method is called on all processes. You provide the method a data buffer and specify the root process (by rank id). Broadcast will send a message to all other processes so that the variable is synchronised between processes. Here is an example where a random number is generated on process 0 and this is sent to all other processes.

```c
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int arg, char** argv) {
    srand(time(NULL));

    MPI_Init(NULL, NULL);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int i;
    if (rank == 0) {
            i = rand();
        printf("sending %d to all processes\n", i);
    }

    MPI_Bcast(&i, 1, MPI_INT, 0, MPI_COMM_WORLD);
    printf("%d\n", i);
    MPI_Finalize();
}
```

## Scatter and Gather

## Asynchronous message passing

## Examples
### Ping Pong

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

- [MPI Tutorial](https://mpitutorial.com/tutorials/) - if you are looking to get into message passing programming then doing this course in its entirety is almost certainly the best place to start.
- [Microsoft MPI Reference](https://learn.microsoft.com/en-us/message-passing-interface/mpi-reference) - a nice reference guide.

## Appendix
### Method definitions
```
MPI_Send(
	void *buf, 
	int count, 
	MPI_Datatype datatype,
	int dest, 
	int tag, 
	MPI_Comm comm
);
```
- `buf` - a **pointer** to the data to be sent.
- `count` - the number of elements in the buffer. If sending an array, it would be the length of the array.
- `datatype` - the type of the data being sent. Must be one of the [predefined datatypes](https://learn.microsoft.com/en-us/message-passing-interface/mpi-datatype-enumeration).
- `dest` - the **rank** of the receiver.
- `tag` - a tag for distinguishing message types - set to 0 for most normal usage.
- `comm` - the mpi communicator. Set to `MPI_COMM_WORLD` for most normal usage.

```
MPI_Recv(
    void *buf,
    int count,
    MPI_Datatype datatype,
    int source,
    int tag,
    MPI_Comm comm,
    MPI_Status *status
);
```

- `buf` - a **pointer** to the location where the received data will be stored.
- `count` - the number of elements in the buffer. If sending an array, it would be the length of the array.
- `datatype` - the type of the data being sent. Must be one of the [predefined datatypes](https://learn.microsoft.com/en-us/message-passing-interface/mpi-datatype-enumeration).
- `source` - the **rank** of the sender.
- `tag` - a tag for distinguishing message types - set to 0 for most normal usage.
- `comm` - the mpi communicator. Set to `MPI_COMM_WORLD` for most normal usage.
- `status` - contains a pointer to an [MPI_Status](https://learn.microsoft.com/en-us/message-passing-interface/mpi-status-structure).
