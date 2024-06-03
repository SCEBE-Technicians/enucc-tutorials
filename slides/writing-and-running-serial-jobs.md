# Writing and submitting serial jobs to ENUCC

---

# Introduction

We'll cover submitting a basic python script to ENUCC and use Slurm, the job scheduler, to parallelise multiple runs of the same script.

Check out the [tutorial website](https://scebe-technicians.github.io/enucc-tutorials/).

---

# Log in to ENUCC now 

---

# The python script we'll be running

We'll be calculating statistics on a simple random process.

- We first roll two dice
- We record the product of the two numbers
- We calculate the mean, mode and median for `n` trials.

---

# The python script we'll be running

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

---

# The python script we'll be running

You can clone the script from here:
```bash
$ git clone git@github.com:SCEBE-Technicians/python-analysis-tutorial.git
```

---

# Running the script

```bash
$ module load apps/anaconda3
$ python script.py 10 10
------------------------------------------------
Product of two 10 sided dice. 10 trials
------------------------------------------------
Mean: 20.4
Median: 9.5
Mode: 8
```

---

# Using `srun`

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

---

# Using `sbatch`

```bash
#!/bin/bash

start_time=`date +%s.%N`

python product_of_two_dice_analysis.py 6 10000000


end_time=`date +%s.%N`
runtime=$(echo "$end_time - $start_time" | bc)
printf "This job ran in %s seconds\n\n" $runtime
```

---

# Using `sbatch`

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

---

# Using `sbatch`

```
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

---

# Using `sarray`

```bash
#!/bin/bash
#SBATCH --ntasks 1
#SBATCH --array=2,4,6
#SBATCH --cpus-per-task 1
#SBATCH --output=variable-sided-dice-result.out

python product_of_two_dice_analysis.py $SLURM_ARRAY_TASK_ID 10000000 &
```
