# Using Scatter and Gather

## Description

## Prerequisites

---

A very common use for message passing programming is in parallelising loops. Often if we are looping over an array we want to distribute the array across all processes. In order to do this, we use the `MPI_Scatter` routine. 

Let's say we have some code which iterates over an array.

```c
for (int i =0; i < array_length; i++) {
    printf("Array value is %d\n", array[i]);
}
```

The equivalent, using `MPI_Scatter` would be

```c
int subarray_length = array_length / world_size;
int subarray[subarray_length];
MPI_Scatter(
    array,               // Scatter `array`
    subarray_length,     // Put this number on each process
    MPI_INT,             // We are sending integers
    subarray,            // Receive to `subarray`
    subarray_length,     // Receive this many
    MPI_INT,             // integers.
    0,                   // Send from process 0
    MPI_COMM_WORLD       // On COMM_WORLD.
);

for (int i = 0; i < subarray_length; i++) {
    printf("Array value is %d on rank %d\n", array[i], rank);
}
```

This simply puts a chunk of the array on each of the processes. Note that it is important that the array is divisible by the number of processes. If this is not the case then you have to use [`MPI_Scatterv`](https://www.mpich.org/static/docs/v3.0.x/www3/MPI_Scatterv.html) instead.

There is an inverse process to `MPI_Scatter` which rather than send data out to all processes will instead gather data from each process onto a single process. Let's take [monte-carlo integration](https://en.wikipedia.org/wiki/Monte_Carlo_integration) as an example.



