# Huggingface

Install the Hugging Face Python API and command-line tool, log in, and download a model on ENUCC.

## 1. Install the Python API

Use a dedicated Python virtual environment for the API and command-line tool. This keeps the packages in your own account and avoids changing the shared Python installation. No administrator access is needed.

If Gridware is not already active (your prompt does not show `<gridware{+}>`), activate it first:

```bash
flight env activate gridware
```

Load the Anaconda module to make its Python interpreter available:

```bash
module load apps/anaconda3/2024.10/bin
python3 --version
```

Here Anaconda supplies Python; package installation uses Python's built-in `venv` and `pip`. You do not need to run `conda init` or create a Conda environment. The current `huggingface_hub` requires Python 3.10 or newer.

Create the environment in `~/venvs/huggingface`, separate from your project and model downloads:

```bash
mkdir -p ~/venvs
python3 -m venv ~/venvs/huggingface
source ~/venvs/huggingface/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade huggingface_hub
hf --help
```

Activation makes this environment's Python and `hf` commands available in your current shell. Using `python -m pip` ensures packages are installed into that environment.

Keep the module loaded while using the environment. A virtual environment still depends on the Python installation used to create it; unloading a module may also remove environment settings needed by that Python. Packages installed here remain separate from Anaconda's shared packages.

## 2. Log in

```bash
hf auth login
```

Follow the prompts to sign in to your Hugging Face account. If prompted for an access token, create one in your [Hugging Face token settings](https://huggingface.co/settings/tokens) with read access to the model you want to download.

## 3. Download a model

```bash
hf download [model] --local-dir [model]
```

Replace the first `[model]` with the model's repository ID (usually `owner/model-name`) and the second with the folder where you want to save it. For example:

```bash
hf download openai-community/gpt2 --local-dir gpt2
```

This downloads the repository's files into the chosen folder. For a gated model, first obtain access through its Hugging Face model page.

## 4. Use it again later

In a new login session, activate Gridware if needed, then load the same module and activate the existing environment:

```bash
module load apps/anaconda3/2024.10/bin
source ~/venvs/huggingface/bin/activate
```

You can now use `hf` from any working directory. You do not need to recreate the environment or reinstall the package each time.

When finished:

```bash
deactivate
module unload apps/anaconda3/2024.10/bin
```

For more options, see the [Hugging Face command-line guide](https://huggingface.co/docs/huggingface_hub/guides/cli) and [installation guide](https://huggingface.co/docs/huggingface_hub/installation).
