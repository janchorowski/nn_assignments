#!/usr/bin/env bash

# The directory where the script is
export NN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ \( "`which ipython`" != /pio/os/anaconda/bin/ipython \) -a \( -e /pio/os/anaconda/set-env.sh \) ]
then
    echo "Adding Anaconda Python from /pio/os to your environment"
    source /pio/os/anaconda/set-env.sh
fi

if [ -z ${CUDA_DIR+x} ]; then
    echo "Adding CUDA to your environment"
    source /pio/os/cuda-8.0_cudnn-6.0/set-env.sh
fi

#python modules
export PYTHONPATH=$NN:$PYTHONPATH

# Torchvision
if [ \( -e /pio/data/data/torchvision \) ]; then
    export PYTORCH_DATA_PATH="/pio/data/data/kursy/nnets"
else
    export PYTORCH_DATA_PATH="$NN/data"
fi
echo "Using $PYTORCH_DATA_PATH as data path."
