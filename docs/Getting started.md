### 1.1. Overview
*   **Getting an Account:** Users must apply via [the form](https://napier.unidesk.ac.uk/tas/public/ssp/content/serviceflow?unid=fc74f7a8354d430889c09b2b5dad37af).
*   **Access/Login:** `ssh 40XXXXXX@login.enucc.napier.ac.uk`
*   **Transferring Data:** Recommend using `rsync` or `scp`. It is also possible to create a virtual desktop by visiting [login.enucc.napier.ac.uk](https://login.enucc.napier.ac.uk) through a web browser.
*   **Important:**
    *   **Do not run jobs on the login node.** Always submit jobs to the scheduler.
    *   **local scratch and shared scratch** Local scratch should only be used to store data created during a run. It is much faster than any other storage, but it will not persist between runs and is not replicated across nodes. Shared scratch is accessible across nodes and therefore is excellent for storing large datasets or conda environments.

### 1.2. Module System
*   **Environment:** ENUCC uses gridware and Lmod (module system).
*   **Common Commands to Advise:**
    *   `module avail` - list available software
    *   `module load [software/version]` - load a software environment (e.g., `module load anaconda/3`)
    *   `module purge` - unload all modules

### 1.3. Job Scheduling (SLURM)
*   **Key Partitions :** `nodes`, `himem`, `gpu`
*   **How to Submit a Job:** `sbatch my_job_script.sh`
*   **How to Check Job Status:** `squeue -u username`
