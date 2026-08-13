# Slurm Cheat Sheet

## Queue - `squeue`

```bash
# All jobs
squeue

# Just my jobs
squeue --me

# My jobs plus estimated start time
squeue --me --start

# Jobs on a particular node
squeue -w gpu01

# Pending jobs
squeue -t PD

# Running jobs
squeue -t R

# Refresh continuously
watch -n 1 squeue --me

# Watch estimated start time
watch -n 1 squeue --me --start
```

`--me` and `--me --start` are useful everyday queue views.

## Detailed Job Info - `scontrol`

```bash
# Detailed job information
scontrol show job <jobid>

# More verbose job information
scontrol show jobid -dd <jobid>

# Node information
scontrol show node gpu01

# Cluster Slurm configuration
scontrol show config
```

Useful fields to scan first:

```text
JobState=       Reason=         Partition=      NodeList=
ReqTRES=        AllocTRES=      MinMemoryNode=  TimeLimit=
StartTime=      SubmitTime=     Priority=
```

## Interactive Jobs - `srun`

```bash
# Basic shell
srun --time=00:05:00 --pty bash

# Short partition
srun --partition=short --time=00:05:00 --pty bash

# High-memory partition
srun --partition=himem --time=00:05:00 --pty bash

# GPU shell
srun --partition=gpu --time=00:05:00 --gres=gpu:1 --pty bash

# Request CPUs
srun -c 2 --time=00:02:00 --pty bash

# Request RAM
srun --mem=4G --time=00:02:00 --pty bash

# Specific node
srun --partition=gpu --nodelist=gpu03 --time=00:05:00 --pty bash

# Enter an existing allocation
srun --jobid=<jobid> --pty bash
```

`--nodelist` is useful when testing a specific node, but it can keep the job pending if that exact node is not free. `srun --jobid=<jobid> --pty bash` starts another job step inside an existing allocation; it does not attach to an already-running process.

## Submit Batch Jobs - `sbatch`

```bash
sbatch job.sbatch
squeue --me
scontrol show job <jobid>
srun --jobid=<jobid> --pty bash
```

Minimal GPU batch script:

```bash
#!/bin/bash
#SBATCH --job-name=test
#SBATCH --partition=gpu
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err

module load apps/<application>
python3 program.py
```

Useful filename substitutions:

```text
%j    Job ID
%x    Job name
%A    Array master job ID
%a    Array task ID
```

## Job History and Accounting - `sacct`

```bash
# Basic finished-job check
sacct -j <jobid>

# Compact useful version
sacct -j <jobid> --format=JobID,State,Elapsed,MaxRSS,ReqMem,ExitCode

# Everyday debugging version
sacct -j <jobid> -o JobID,State,ExitCode,Elapsed,NodeList,ReqMem,MaxRSS,AllocCPUS

# Deeper debugging
sacct -j <jobid> --format=JobID,JobName,State,ExitCode,NodeList,ReqCPUS,AllocCPUS,ReqMem,Elapsed,TotalCPU,UserCPU,SystemCPU,MaxRSS,MaxVMSize,MaxDiskRead,MaxDiskWrite,Start,End

# Pipe-separated output, easier to align
sacct -j <jobid> --format=All -P | column -s'|' -t
```

Fields to check first: `State`, `ExitCode`, `Elapsed`, `NodeList`, `ReqMem`, `MaxRSS`, `AllocCPUS`, and `TotalCPU`.

## Cluster and Node Status - `sinfo`

```bash
# Partition overview
sinfo

# Individual nodes
sinfo -N -l

# Continuously monitor
watch sinfo
```

Handy node-debug trio:

```bash
scontrol show node gpu01
squeue -w gpu01
sinfo -N -l
```

## Cancel Jobs - `scancel`

```bash
# Cancel one job
scancel <jobid>

# Cancel several jobs
scancel 12345 12346 12347

# Cancel all your own jobs - use carefully
scancel -u "$USER"
```

## Pending Job Priority - `sprio`

```bash
sprio -j <jobid>
```

Use this when `squeue --me` shows `PD (Priority)` rather than a concrete reason like `Resources`. It breaks priority into factors such as `AGE`, `FAIRSHARE`, `JOBSIZE`, `PARTITION`, and `QOS`.

## Modules

### Find Modules

```bash
module avail
```

### Load Modules

```bash
module load apps/<application>
```

### Inspect, List, Unload, and Reset

```bash
# Show what a module changes
module show apps/<application>

# Currently loaded modules
module list

# Unload one module
module unload apps/<application>

# Clear everything
module purge
```

`module show` is useful for seeing changes to `PATH`, `LD_LIBRARY_PATH`, `MANPATH`, and environment variables.
