#!/usr/bin/env bash

# The directory where the script is
export NN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ \( "`which ipython`" != /pio/os/anaconda/bin/ipython \) -a \( -e /pio/os/anaconda/set-env.sh \) ]
then
    echo "Adding Anaconda Python from /pio/os to your environment"
    source /pio/os/anaconda/set-env.sh
    source /pio/os/cuda-8.0_cudnn-5.1/set-env.sh
fi


#python modules
export PYTHONPATH=$NN:$PYTHONPATH
