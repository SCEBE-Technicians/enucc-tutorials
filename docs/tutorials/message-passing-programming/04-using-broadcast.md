# Using Broadcast

##Description

---

## Prerequisites

You should have completed the other parts of this series.

---

Broadcast is another useful operation which is frequently used. It is useful for synchronising values across all processes. Hopefully you're getting used to the syntax of MPI commands and this example should be enough to understand how broadcast works. As always you can check the [relevant documentation](https://www.mpich.org/static/docs/v3.1.3/www3/MPI_Bcast.html) and see the [example on github](https://github.com/SCEBE-Technicians/message-passing-programming/tree/main/tutorials/04-using-broadcast).

```
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv) {
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
