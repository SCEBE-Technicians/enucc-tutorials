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

Here is a function which will estimate the integral of sin(x) from 0 to pi.

```
double integrate_sin(int ntrials) {
    double sum = 0;
    for (int i = 0; i < ntrials; i++) {
        double rand_int = (double)(rand()) / (double)(RAND_MAX) * M_PI;
        sum += sin(rand_int);
    }
    return sum * M_PI / ntrials;
}
```

Since this is effectively an averaging process, we can get estimates of the integration on each process and then average all of the estimates to get a more accurate estimate. 

```
// Get a different estimate on each process
double sin_estimate = integrate_sin(1000000000);

double *results;
MPI_Barrier(MPI_COMM_WORLD);
if (rank == 0) {
	results = malloc(sizeof(double) * world_size);
}

MPI_Gather(
	&sin_estimate,  // Send `sin_estimate`
	1,              // which is of length 1
	MPI_DOUBLE,     // and is type double.
	results,        // Receive messages to `results`.
	1,              // Each message consists of 1
	MPI_DOUBLE,     // double.
	0,              // Gather to rank 0
	MPI_COMM_WORLD  // on COMM_WORLD.
);

if (rank == 0) {
	double aggregate_estimate = 0;
	for (int i = 0; i < world_size; i++) {
		aggregate_estimate += results[i];
	}
	aggregate_estimate /= world_size;
	printf("Aggregate estimate = %f \n", aggregate_estimate);
}
```

Finally, it is quite common to use scatter and then gather together to parallelise a task. As an example, we'll look at calculating the sum of an array. Here is a simple function to sum an array of integers.

```c
double sum_array(double *arr, int arr_size) {
    double sum = 0;
    for (int i = 0; i<arr_size; i++) {
        sum += arr[i];
    }
    return sum;
}
```

To parallelise this we can distribute the array across all processes and calculate the sum of each subarray. We can then sum those results. We could use the `MPI_Gather` routine, but `MPI_Reduce` is better suited for the task here.

```
int main(int argc, char** argv) {
    int rank, world_size;
    mpi_setup(&world_size, &rank);

    if (rank == 0) {
        fill_array(array);
    }

    int elements_per_proc = ARRAY_SIZE/world_size;
    int *sub_array = malloc(sizeof(int) * elements_per_proc);

    MPI_Scatter(array, elements_per_proc, MPI_INT, sub_array, elements_per_proc, MPI_INT, 0, MPI_COMM_WORLD);

    int sub_sum = sum_array(sub_array, elements_per_proc);

    int *sub_sums;
    if (rank==0) {
        sub_sums = (int *)malloc(sizeof(int) * world_size);
    }
    int total_sum;
    MPI_Reduce(
        &sub_sum,       // Send sub_sum
        &total_sum,     // Put the result in total_sum
        1,				// One element from each proc
        MPI_INT,        // of type int.
        MPI_SUM,        // Sum the results.
        0,			    // Store the output on rank 0
        MPI_COMM_WORLD  // on COMM_WORLD.
    );

    if (rank==0) {
        printf("%d\n", total_sum);
        free(sub_sums);
    }
    free(sub_array);
    MPI_Finalize();
}
```

One new concept from this is the use of `MPI_SUM` which is of type [`MPI_Op`](https://learn.microsoft.com/en-us/message-passing-interface/mpi-op-enumeration). There are a few other MPI_Ops which are useful when used with `MPI_Reduce`, particularly `MPI_MAX` and `MPI_MIN`. You can read a more complete discussion on the [mpi tutorial site](https://mpitutorial.com/tutorials/mpi-reduce-and-allreduce/).


