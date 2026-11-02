# MPI Pi Calculation Example

This guide demonstrates how to compile and run a simple MPI application on ENUCC using OpenMPI and Slurm.

## 1\. Create a Working Directory

```bash
mkdir -p \~/projects/pi-calculation
cd \~/projects/pi-calculation
```

## 2\. Load the MPI Module

Load one of the available OpenMPI modules:

```bash
module load mpi/openmpi/4.0.7/gcc-12.3.0
```

Alternatively:

```bash
module load mpi/openmpi/4.0.7/gcc-8.5.0
```

Verify the MPI tools are available:

```bash
which mpicc
which mpirun
```

Example:

```text
<gridware{+}> \[40021234@login1\[enucc] pi-calculation]$ module load mpi/openmpi/4.0.7/gcc-12.3.0

mpi/openmpi/4.0.7/gcc-12.3.0
 | -- libs/gcc/12.3.0
 |    \* --> OK
 |
 OK

<gridware{+}> \[40021234@login1\[enucc] pi-calculation]$ which mpirun
/opt/gridware/depots/9d06fe54/el8/pkg/mpi/openmpi/4.0.7/gcc-12.3.0/bin/mpirun

<gridware{+}> \[40021234@login1\[enucc] pi-calculation]$ mpirun --version
mpirun (Open MPI) 4.0.7
```

## 3\. Create the Source File

```bash
vi pi\_mpi.c
```

Paste the following code:

```c
#include <stdio.h>
#include <mpi.h>

int main(int argc, char \*argv\[])
{
    long long n = 100000000;
    long long i;

    int rank, size;

    double h, x;
    double local\_sum = 0.0;
    double global\_sum = 0.0;
    double pi;

    MPI\_Init(\&argc, \&argv);

    MPI\_Comm\_rank(MPI\_COMM\_WORLD, \&rank);
    MPI\_Comm\_size(MPI\_COMM\_WORLD, \&size);

    h = 1.0 / (double)n;

    for (i = rank; i < n; i += size) {
        x = h \* ((double)i + 0.5);
        local\_sum += 4.0 / (1.0 + x \* x);
    }

    MPI\_Reduce(
        \&local\_sum,
        \&global\_sum,
        1,
        MPI\_DOUBLE,
        MPI\_SUM,
        0,
        MPI\_COMM\_WORLD);

    if (rank == 0) {
        pi = h \* global\_sum;
        printf("PI = %.15f\\n", pi);
    }

    MPI\_Finalize();

    return 0;
}
```

## 4\. Compile the Application

```bash
mpicc -O3 -o pi\_mpi pi\_mpi.c
```

Verify:

```bash
ls -l pi\_mpi
```

## 5\. Create a Slurm Batch Script

```bash
vi ajpi.slurm
```

```bash
#!/bin/bash
#SBATCH --job-name=pi
#SBATCH --mem=4G
#SBATCH --partition=nodes
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=00:05:00
#SBATCH --output=ajpi-%j.out

module load mpi/openmpi/4.0.7/gcc-12.3.0

echo "Host: $(hostname)"
echo "Tasks: $SLURM\_NTASKS"

mpirun --mca btl ^openib -np $SLURM\_NTASKS ./pi\_mpi
```
Available Partitions
---

```bash
sinfo -s
```

```text
PARTITION AVAIL TIMELIMIT NODES(A/I/O/T) NODELIST
nodes\*       up 3-00:00:00 8/0/0/8      node\[01-08]
short        up 1-00:00:00 8/0/0/8      node\[01-08]
long         up 7-00:00:00 8/0/0/8      node\[01-08]
himem        up 3-00:00:00 0/2/0/2      himem\[01-02]
gpu          up 3-00:00:00 4/0/0/4      gpu\[01-04]
```

## 6\. Submit the Job

```bash
sbatch ajpi.slurm
```

Example:

```text
Submitted batch job 123456
```

## 7\. Check the Queue

```bash
squeue -u $USER
```

## 8\. Wait for Completion

```bash
watch squeue -u $USER
```

or:

```bash
squeue -u $USER
```

## 9\. View the Output

```bash
cat ajpi-123456.out
```

Example output:

```text
mpi/openmpi/4.0.7/gcc-12.3.0 ... SKIPPED (already loaded)
Host: node02.enucc.enu.alces.network
Tasks: 4
PI = 3.141592653590217
Elapsed MPI time = 0.000059 seconds
```

