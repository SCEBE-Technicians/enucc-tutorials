#Simple Neural Network

## Description

This is a barebones machine learning project. It involves getting some data, storing it in an appropriate location, installing packages with conda and running the training on ENUCC.

This tutorial is largely based on a [tutorial on machinelearningmastery.com](https://machinelearningmastery.com/tutorial-first-neural-network-python-keras/). 

---

## Prerequisites

You should be familiar with writing and submitting jobs to ENUCC and also have some knowledge of python. This is not a machine learning tutorial, but meant to show you how to run a machine learning project on ENUCC.

---


We start by getting the data by downloading it using the [wget](https://ftp.gnu.org/old-gnu/Manuals/wget-1.8.1/html_mono/wget.html) program.

```bash
$ mkdir ~/sharedscratch/diabetes-dataset
$ cd ~/sharedscratch/diabetes-dataset
$ wget https://raw.githubusercontent.com/jbrownlee/Datasets/master/pima-indians-diabetes.data.csv
```

Note that I choose to store the data in the `sharedscratch` folder. This is a shared directory which does not have a storage quota. If the speed of loading data is a big factor for your work then you should use `localscratch` instead, but note that it is wiped at regular intervals and should not be used for long-term storage.

We then create a folder to container our analysis

```bash
$ mkdir -p ~/projects/diabetes-analysis
$ cd ~/projects/diabetes-analysis
```

In order to run the analysis we have to have python, numpy and tensorflow installed. We do this in a conda environment called `ml-example`. If you haven't used conda on ENUCC before then you'll have to set it up by running the following.

```
$ flight start
$ flight env activate gridware
$ module load apps/anaconda3
$ conda init bash
```

Once conda is configured, you can create the environment.

```bash
$ conda create -n ml-example
$ conda activate ml-example
$ conda install python=3.11 numpy tensorflow
```

To train the machine learning model we'll use the following script
```python
from numpy import loadtxt
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from pathlib import Path

data_path = Path.home() / "sharedscratch" / "diabetes-dataset" / "pima-indians-diabetes.data.csv"
dataset = loadtxt(data_path, delimiter=',')
x = dataset[:, 0:8]
y = dataset[:, 8]

model = Sequential()
model.add(Dense(12, input_shape=(8,), activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='sigmoid'))

model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

model.fit(x, y, epochs=50, batch_size=10)

_, accuracy = model.evaluate(x, y)
print('Accuracy: %.2f' % (accuracy*100))
```

The batch file to submit the job is quite straightforward

```bash
#!/bin/bash

python model.py
```

And that's it! Sin é.
