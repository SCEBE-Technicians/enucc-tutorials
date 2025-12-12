# Slurm Scheduling and FairShare

From December 2025 Alces Flight have initiated a new scheduling system (The Run Length Partitions scheduler configuration set) based on a [Fair Tree Fairshare algorithm](http://focus.m.alces-flight.com/c/eJwUyrFuwyAQANCvga0IDgzcwNDFvxFhfARUSKMzrtS_r7q_MyHCJimZ4B24gFbLlny1aLcaXSBvtDnIBf_vCiKCsVr25BGiw5DDAcE9jD-jrybCFuIhnK6jP9v6KPRaxGrmPuRIba33JeyngF3Afo2bp7pKo3OeqnxPAXvNnR-LiVRbc0hOQ83yzMy_wulXfndilYu6v-RPgr8AAAD__761N_w).

## Changes to the Slurm system
---
1. Fairshare scheduling
    Jobs are now scheduled using the Fair Tree Fairshare Algorithm rather than simple first-come, first-served queueing.

2. Required job run times
    All job submissions must now include an estimated run time ( e.g. --time:00:20:00). This helps the scheduler allocate resources more efficiently.

3. Updated time limits for existing partitions
    - Node, GPU and Himem partitions now have a maximum run time of 3 days.
    Jobs exceeding this limit will be terminated, so users running long simulations should employ appropriate checkpointing.

4. ‎New partitions: short and long 
    Short: up to 1 day maximum run time
    Long: up to 7 days maximum run time
    Scheduling priority is: short > nodes > long, helping shorter jobs complete faster.

5. Per-user resource limits (standard compute nodes)
    long partition: up to 3 nodes per user (≈37.5% of standard compute capacity – 192 cores, 1506 GiB RAM).
    nodes partition: up to 6 nodes per user (≈75% of capacity – 384 cores, 3012 GiB RAM).
    These limits prevent individuals from monopolising the cluster for extended periods.

6. GPU and Himem resource limits unchanged
    There are no usage limits on these partitions.

## How to Assign a partition

In order to best utilise the new system you will need to explicitly assign one of these partitions (short,long,nodes) when submitting a job.

Your Fairshare score is the score assigned to your account based on your usage from 0.01 (high usage) to 1.0 (low usage). Users with lowest usage will have higher priorities when jobs are queued. You can check your Fairshare score with the sshare -l command. Your score will improve if you submit less jobs.
 
In terms of partition type, short have the highest priority (max 1 day), nodes medium priority (max 3 days) and long lowest priority (max 7 days). You can check your job status and the partition with the squeue command. 
 
If you have a job that you expect to be finished in under one day you can increase the priority by running it on the short partition with these options, though be aware that the time limit is 1 day: 
```
#SBATCH --time=00:01:20
#SBATCH --nodelist=node07
#SBATCH --partition=short
```
