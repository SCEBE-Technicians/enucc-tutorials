# Running Python Analysis

## Description

This project covers how to move long-running scripts from running on your local machine to running on ENUCC. We will learn how to run a series of unconnected jobs in parallel using `sbatch` and `srun` and then we'll use the array flag to supply a range of values which will be parameters supplied to the script we're running.

---

## Prerequisites

Ideally you should have run scripts using `srun` and `sbatch` before (if not check out the [hello world](/tutorials/hello-world/) project). 

---

### Initial script

Let's say we have some python analysis that runs on a laptop, but takes some time to run. We want to run it 20 times with different parameters. Ideally we would set up a script to submit all 20 runs to ENUCC. We then come back in a few day and check our results.

As a simple example, let's say we want to calculate some statistics about the product of the outcomes of two dice rolls. We also want to see how these statistics change depending on how many sides the dice have. Here is a simple script that takes the number of sides of the dice and the number of trials as command line arguments and prints the mean, mode and standard deviation of the product of the two dice rolls.

```python
import sys
import random
import statistics

n_sides = int(sys.argv[1])
n_trials = int(sys.argv[2])

first_die_outcomes = []
second_die_outcomes = []

for i in range(n_trials):
first_die_outcomes.append(random.randint(1, n_sides))
second_die_outcomes.append(random.randint(1, n_sides))

products = [a * b for a, b in zip(first_die_outcomes, second_die_outcomes)]

output = (f"------------------------------------------------\n"
      f"Product of two {n_sides} sided dice. {n_trials} trials\n"
      f"------------------------------------------------\n"
      f"Mean: {statistics.mean(products)}\n"
      f"Median: {statistics.median(products)}\n"
      f"Mode: {statistics.mode(products)}\n")

print(output)
```

### Getting files onto ENUCC

The first thing we need to do is get the files from our local computer to enucc. Ideally you should be using git to manage your projects, with a remote repository on a hosting site such as github or gitlab. If you already have this setup it's a simple matter to clone the repository. I have put all of the code we need into a [git repository](https://github.com/SCEBE-Technicians/python-analysis-tutorial) so you should try cloning this now.

```
$ git clone git@github.com:SCEBE-Technicians/python-analysis-tutorial.git
```

If you aren't using git you can transfer files from either Linux or MacOS using either [scp](https://www.man7.org/linux/man-pages/man1/scp.1.html) or [rsync](https://man7.org/linux/man-pages/man1/rsync.1.html). The syntax is as follows:

```
$ scp /path/to/local/file 400XXXXX@login.enucc.napier.ac.uk:/path/to/server/file
```
or

```
$ rsync /path/to/local/file 400XXXXX@login.enucc.napier.ac.uk:/path/to/server/file
```

You can also use these programs to copy files from the server to your local machine. If you are on windows you can use scp from powershell.

```
> scp \path\to\local\file 400XXXXX@login.enucc.napier.ac.uk:/path/to/server/file
```

#### Where should I put data files?

This will be covered more thoroughly in a future project but the short answer is that you want to put large data files in `sharedscratch` for long term-storage or in `localscratch` for short-term access. `localscratch` is faster but will get wiped after 30 days.


### Using Anaconda

On ENUCC, python is managed with anaconda and so we have to first load the anaconda module
```bash
$ module load apps/anaconda3
```

If this is the first time you've tried to use anaconda it will ask you to run a setup script.
```
TODO: FIND OUT WHAT GOES HERE
```
To run the script for 1000 trials of 6 sided dice we simply run

```bash
$ python product_of_two_dice_analysis.py 6 1000
------------------------------------------------
Product of two 10 sided dice. 10 trials
------------------------------------------------
Mean: 29.4
Median: 23.5
Mode: 30
```

### Running the script

To run the same script on ENUCC we can use `srun`. Here we run it for a reasonably large number of trials.
```bash
$ srun python product_of_two_dice_analysis.py 10 10000000
srun: job 27947 queued and waiting for resources
srun: job 27947 has been allocated resources
------------------------------------------------
Product of two 10 sided dice. 10000000 trials
------------------------------------------------
Mean: 30.2445156
Median: 24.0
Mode: 6
```

So now we want to run it many times, for different number of sides and different numbers of trials. For this we'll have to write a batch script.

```bash
#!/bin/bash

start_time=`date +%s.%N`

python product_of_two_dice_analysis.py 6 10000000


end_time=`date +%s.%N`
runtime=$(echo "$end_time - $start_time" | bc)
printf "This job ran in %s seconds\n\n" $runtime
```

Here I've used [date](https://www.man7.org/linux/man-pages/man1/date.1.html) and [bc](https://www.man7.org/linux/man-pages/man1/bc.1p.html) to calculate the runtime of the of the program. This will be important later when we're trying to guage how well our script will scale.

As usual, we submit it with sbatch and see our output in the output file.

```bash
$ sbatch job_script.sh
Submitted batch job 27949

$ cat slurm-27949.out
------------------------------------------------
Product of two 6 sided dice. 1000 trials
------------------------------------------------
Mean: 12.493
Median: 10.0
Mode: 6

This job ran in 11.822068605 seconds
```

Great. We're now in a position that we can modify our script to run our job a few times. Let's start by running 10 identical copies of it. Modify the bash script like so:

```bash
#!/bin/bash

start_time=`date +%s.%N`

python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000
python product_of_two_dice_analysis.py 6 10000000

end_time=`date +%s.%N`
runtime=$(echo "$end_time - $start_time" | bc)
printf "This job ran in %s seconds\n\n" $runtime
```

The output of the job script is quite long this time, so let's just see how long it ran for this time.
```bash
$ cat slurm-27951.out
...
This job ran in 120.238923031 seconds
```

This has taken around 10 times longer than running the analysis once which is more or less what might be expected. ENUCC has a great deal of resources, but the script as we've written it requests only one CPU on one node and then runs the python script steps one after the other. There is no reason why we shouldn't run the python steps all at once, but we don't want to submit 10 different job. Instead we can run each python step as a separate task and assign one cpu to each task. We also have to specify how much memory each task should use since the default would request all available memory.

### Parallelising the job

```bash
#!/bin/bash
#SBATCH --ntasks 10
#SBATCH --nodes 1
#SBATCH --cpus-per-task 1

start_time=`date +%s.%N`

srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &

wait

end_time=`date +%s.%N`
runtime=$(echo "$end_time - $start_time" | bc)
printf "This job ran in %s seconds\n\n" $runtime
```

To shorten the script and make it more readable we can also put our execution tasks in a loop.

```bash
#!/bin/bash
#SBATCH --ntasks 10
#SBATCH --nodes 1
#SBATCH --cpus-per-task 1

start_time=`date +%s.%N`

for x in {1..10}
do
  srun --exclusive --ntasks 1 python product_of_two_dice_analysis.py 6 10000000 &
done

wait

end_time=`date +%s.%N`
runtime=$(echo "$end_time - $start_time" | bc)
printf "This job ran in %s seconds\n\n" $runtime
```

Things are getting quite complicated now so let's take stock of what's happening. In the first few lines we specify that we'll be running 10 tasks on one node with one cpu per task. Instead of simply executing our code with `python script.py` now we use `srun` which is part of the slurm ecosystem. We use `srun` because we can specify what resources we want to use by passing in different flags. The `--exclusive` flag says that this job will have exclusive access to the requested resources. `--ntasks` says that this is only a single task. Then we supply the commands to run. Finally we add the `&` character which runs the `srun` command in the background. This is necessary so that it can execute the next command before the current one has finished.

When we run this script we can see the runtime is massively improved.

```bash
$ sbatch job_script.sh
...
This job ran in 12.563785716 seconds 
```

Note that as long as we have free resources on which to run the scripts, we can easily expand beyond running 10 copies and it will still take around 12 seconds. If we go beyond 64 tasks we will require more than one node.

### Using job array

Now let's say we want to run this same script but change the number of sides each dice take, running it for 2, 4, 6 sides. Yes we could just use bash loops, but there is a simpler way to do this using the `--array` flag. Let's see what it looks like:

```bash
#!/bin/bash
#SBATCH --ntasks 1
#SBATCH --array=2,4,6
#SBATCH --cpus-per-task 1
#SBATCH --output=variable-sided-dice-result.out

python product_of_two_dice_analysis.py $SLURM_ARRAY_TASK_ID 10000000 &
```

This is much simpler than the previous script. Using the `--array` flag we specify what values we want to run the job for and we use `$SLURM_ARRAY_TASK_ID` to access those values in the script. When we submit this job it creates 3 versions of the job. We can see that the job id has an array appended with the specified values.

```
$ squeue
         JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
 27995_[2,4,6]     nodes job_scri 40019142 PD       0:00      1 (Priority)
```

The `--array` flag is not limited to specifying individual values. There are a few different options for specifying values depending on your needs.

| `--array` | description                                 |
| ----------|---------------------------------------------|
| 1,2,3     |  1,2,3                                      |
| 1-100     |  1,2 ... 100                                |
| 1-100:2   |  1, 3, 5 ... 99                             |
| 1-100%5   |  1,2 ... 100, running 5 jobs simultaneously |

### Conclusion

We've seen a few different ways that we can launch jobs. While launching multiple jobs with the array flag will likely be the most common usage, it is good to know how to launch individual jobs within a batch file so that we can have finer control over what scripts are running.
