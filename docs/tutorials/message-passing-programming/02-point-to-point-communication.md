# Point to Point Communication

## Description

This tutorial looks at how to send a message containing some data from one process to another.

## Prerequisites

Complete [part one](../01-hello-mpi) of this series if you haven't already.

---

Now that we've got an idea on how to compile and run a trivial program using MPI, let's try and do something a bit more useful. One of the central concepts of message passing programming is of course passing messages. This means that we send some data from one process to another. We're going to look at a ping-pong program which sends a message back and forth between two processes. Let's start with the usual MPI boilerplate. Put this in a file called `ping_pong.c`.

```c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    MPI_Init(NULL, NULL);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    if (size != 2) {
        printf("World size must be 2. Exiting...\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    printf("Hello from %d\n", rank);
    MPI_Finalize();
}
```

Compile it with

```bash
$ module load mpi
$ mpicc ping_pong.c -o ping_pong
```

and the following batch file can be used to run it on ENUCC

```bash
#!/bin/bash
#SBATCH -o ping_pong.output
#SBATCH -J 
#SBATCH --time=5
#SBATCH --mem=128
#SBATCH --ntasks=2

mpirun -n 2 ping_pong
```

Now let's try and send a message from process 0 to process 1. Here we'll be sending an integer called ping_pong_count and later we'll increment it by one and send it back. For now we just send it from process 0 to process 1.

```
int main(int argc, char** argv) {
    ...
    int ping_pong_count;
    int partner_rank = (rank + 1) % 2;
    if (rank == 0) {
        ping_pong_count = 0;
        MPI_Send(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD);
        printf("Sent %d from process %d to process %d\n", ping_pong_count, rank, partner_rank);
    } else {
        MPI_Recv(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Received %d on process %d from process %d\n", ping_pong_count, rank, partner_rank);
    }
    ...
}
```

If everything has gone right so far then when you run this you'll see the following in the output file

```
Sent 0 from process 0 to process 1
Received 0 on process 1 from process 0
```

So how did we send the message? The function signature for MPI_Send is
```c
MPI_Send(
    void *buf,
    int count,
    MPI_Datatype datatype,
    int dest,
    int tag,
    MPI_Comm comm
)
```
This is fairly complicated and it might take a while before you fully understand it. Here is a brief outline of the arguments

- buf - A pointer to the data to be sent. In our program we sent ping_pong_count.
- count - The size of the array to be sent. Since we are only sending one number, we set this to be 1.
- datatype - The type of data to be sent. Since we are sending an integer we used MPI_Int. See the list of [MPI datatypes](https://www.mpich.org/static/docs/latest/www3/Constants.html) for more info.
- dest - The rank of the receiving process. Here we sent our message to `partner_rank`.
- tag - An identifier for this message. We don't use this, so set it to 0.
- comm - The communicator. We set this to `MPI_COMM_WORLD`.

The receive message has an almost identical signature
```c
MPI_Recv(
    void *buf,
    int count,
    MPI_Datatype datatype,
    int source,
    int tag,
    MPI_Comm comm,
    MPI_status *status
)
```
The only difference is that we also have the status argument. This can be used to determine whether an error occurred while sending the message but for now we set this to be `MPI_STATUS_IGNORE` since we aren't using the status.

Hopefully it is quite clear now how we send an integer from one process to another. We call `MPI_Send` on the sending process and `MPI_Recv` on the receiving process.

We now have all the knowledge we need to implement the ping pong program. Here it is in full.

```c
#include <mpi.h>
#include <stdio.h>
#define PING_PONG_LIMIT 5

int main(int argc, char** argv) {
    MPI_Init(NULL, NULL);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 2) {
        printf("World size must be 2. Exiting...\n");
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    int ping_pong_count = 0;
    int partner_rank = (rank + 1) % 2;

    while(ping_pong_count < PING_PONG_LIMIT) {
        if (rank == ping_pong_count % 2) {
            ping_pong_count ++;
            MPI_Send(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD);
            printf("ping\n");
        } else {
            MPI_Recv(&ping_pong_count, 1, MPI_INT, partner_rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("pong\n");
        }
    }

    MPI_Finalize();
}
```

Running this, you'll see the following in the output file:
```
ping
pong
ping
pong
ping
pong
ping
pong
ping
pong
```

## Exercises

- Implement a ring-pong program. Send a counter in a ring around an arbitrary number of processes, incrementing the counter after each send. Terminate once every process has sent a message.
- Send a string from one process to another. Hint - a string is an array for chars.

