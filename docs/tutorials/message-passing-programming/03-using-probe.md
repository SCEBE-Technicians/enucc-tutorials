# Using Probe

## Description
Probe is another MPI routine which allows you to know the size of a message before receiving it. This is particularly useful if receiving arrays of variable size.

## Prerequisites

You should have already completed [part two](../02-point-to-point-communication) of this series.

---

If we want to send a message where the length cannot be known at compile time then how do we handle receiving it? `MPI_Recv` requires that the amount of data be specified. The answer is that we need to use `MPI_Probe` to get the message length before we receive it. 

Here is a snippet illustrating how probe works. See the [full program](https://github.com/SCEBE-Technicians/message-passing-programming/blob/main/tutorials/03-using-probe/send_animal.c) on github.

```c
if (rank == 0) {
	// Choose one of four animals
	srand(time(NULL));
	char animals[4][10] = {"dog", "cat", "rat", "gorilla"};
	char animal[10];
	int index = rand() % 4;
	strcpy(animal, animals[index]);
	printf("Sending %s of size %d\n", animal, strlen(animal));
	MPI_Send(animal, strlen(animal), MPI_CHAR, 1, 0, MPI_COMM_WORLD);
} else {
	// Get status
	MPI_Status stat;
	MPI_Probe(0, 0, MPI_COMM_WORLD, &stat);
	int message_length;
	MPI_Get_count(&stat, MPI_CHAR, &message_length);
	printf("Receiving message of length %d\n", message_length);
	// Receive message
	char message[message_length];
	MPI_Recv(&message, message_length, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	printf("Received %s from sender\n", message);
}
```

For the code executed on rank 0 we just create the message as would normally be expected. On rank 1 we first create an [`MPI_Status`](https://learn.microsoft.com/en-us/message-passing-interface/mpi-status-structure) struct called stat and use [`MPI_Probe`](https://www.mpich.org/static/docs/v3.0.x/www3/MPI_Probe.html) to initialise it. We can then use the method [`MPI_Get_count`](https://www.mpich.org/static/docs/v3.0.x/www3/MPI_Get_count.html) to get the length of the message. Finally we receive the message as we normally would.

## Exercises
- Create a program which sends user input from one process to another.

