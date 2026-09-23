# Ollama

## Description

Install Ollama under `~/sharedscratch` and run a local model on ENUCC's GPU partition, either interactively with `srun` or as a batch job with `sbatch`.

## 1. Install Ollama

On the login node, run:

```bash
mkdir -p ~/sharedscratch/ollama
cd ~/sharedscratch/ollama
wget https://ollama.com/download/ollama-linux-amd64.tar.zst
tar --zstd -xf ollama-linux-amd64.tar.zst
mkdir -p models logs tmp
```

This downloads and extracts Ollama, then creates folders for its model store, logs and temporary files. You can use another installation folder, provided it is under `~/sharedscratch`.

## 2. Set up the environment and model

Create a setup file:

```bash
cat > env.sh <<'EOF'
export OLLAMA_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$OLLAMA_HOME/bin:$PATH"
export OLLAMA_MODELS="$OLLAMA_HOME/models"
export TMPDIR="$OLLAMA_HOME/tmp"
export OLLAMA_HOST="127.0.0.1:11434"
EOF
```

This tells your shell where to find Ollama and store its models. It uses the location of `env.sh`, so you can move the installation folder later.

For the examples below, use an existing GGUF model supported by Ollama. See the [Huggingface tutorial](huggingface.md) for model downloads. Create a `Modelfile` in the installation folder:

```bash
printf 'FROM ./model.gguf\n' > Modelfile
```

Replace `./model.gguf` with the path to your local model file. Keep the model under `~/sharedscratch` too. The following steps import it into Ollama under the name `my-model`.

## 3. Import the model and test with srun

Request an interactive GPU session:

```bash
srun --partition=gpu --gres=gpu:1 --cpus-per-task=4 \
  --mem=32G --time=00:30:00 --pty bash
```

This requests an interactive session with one GPU for 30 minutes. Wait for the new shell prompt, then run:

```bash
cd ~/sharedscratch/ollama
source env.sh
nvidia-smi
```

`source env.sh` loads the settings into this shell. `nvidia-smi` shows the GPU available to your job. Start Ollama in the same shell:

```bash
ollama serve > "$OLLAMA_HOME/logs/ollama.log" 2>&1 &
OLLAMA_PID=$!
```

This starts Ollama in the background, saves its output to a log and records its process ID for stopping it later.

```bash
ollama list
```

This checks that the server is ready. An empty model list is expected on the first run. If it cannot connect, wait a few seconds and run `ollama list` again.

Once the server is ready, import the model:

```bash
ollama create my-model -f Modelfile
```

Do this once before submitting batch jobs. The imported model stays in `OLLAMA_MODELS` and can be reused by later jobs that source the same `env.sh`. Repeat `ollama create` only if you change the model or `Modelfile`, or remove the imported model.

Run a test prompt:

```bash
ollama run my-model "Explain what a GPU does in two sentences."
ollama ps
```

`ollama run` waits for the answer and then returns. `ollama ps` is an optional check of where the model is loaded; look for `100% GPU` in the `PROCESSOR` column. The model normally stays in memory briefly after the answer finishes.

When finished:

```bash
kill "$OLLAMA_PID"
exit
```

This stops your Ollama server and releases the GPU session.

## 4. Run a batch job with sbatch

Complete step 3 once to import your model, then save this as `ollama.sbatch` in the installation folder. Each batch job reuses the imported model:

```bash
#!/bin/bash
#SBATCH --job-name=ollama
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --output=logs/%x-%j.out

set -e
cd "$SLURM_SUBMIT_DIR"
source env.sh

ollama serve > "$OLLAMA_HOME/logs/server-$SLURM_JOB_ID.log" 2>&1 &
OLLAMA_PID=$!
trap 'kill "$OLLAMA_PID" 2>/dev/null || true' EXIT

# Wait up to 30 seconds for the server to start.
for attempt in {1..30}; do
    kill -0 "$OLLAMA_PID"
    if ollama list > /dev/null 2>&1; then
        break
    fi
    sleep 1
done
ollama list > /dev/null

ollama show my-model > /dev/null
ollama run my-model "Explain what a GPU does in two sentences."
```

This requests one GPU, starts Ollama and checks that `my-model` exists before running the prompt.

`ollama run` is the last command. With a prompt supplied, it waits for the answer and then exits. The script reaches its end, the `EXIT` trap stops the background server, and the job finishes. `set -e` also stops the script if a command such as `ollama show` or `ollama run` fails. The 30-minute limit is the maximum runtime, not a delay before finishing.

From the login node, submit it from the installation folder:

```bash
cd ~/sharedscratch/ollama
sbatch ollama.sbatch
squeue --me
```

`sbatch` returns a job ID. `squeue --me` shows whether your job is queued or running.

```bash
cat logs/ollama-JOBID.out
```

Replace `JOBID` with the number returned by `sbatch`. After the job runs, this file contains the model's answer.

## Troubleshooting

- **`ollama: command not found`**: run `source env.sh` from your installation folder in the GPU shell.
- **Ollama will not start**: check `logs/ollama.log` for an interactive run or `logs/server-JOBID.log` for a batch job. If it says `address already in use`, change the port in `env.sh` to another unused port, for example `11435`. This is just an alternative to Ollama's default `11434`; it has no special meaning. Source `env.sh` again and restart the server, or resubmit the batch job. The server and client must use the same port.
- **The model cannot be imported**: check that the path in `Modelfile` points to your existing GGUF file. Relative paths are measured from the folder containing `Modelfile`.

Further details: [Ollama installation](https://docs.ollama.com/linux), [importing models](https://docs.ollama.com/import) and [Slurm batch jobs](https://slurm.schedmd.com/sbatch.html).
