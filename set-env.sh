#!/usr/bin/env bash

# The directory where the script is
export NN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ \( "`which ipython`" != /pio/os/anaconda/bin/ipython \) -a \( -e /pio/os/anaconda/set-env.sh \) ]
then
    echo "Adding Anaconda Python from /pio/os to your environment"
    source /pio/os/anaconda/set-env.sh
fi

export FUEL_DATA_PATH=/pio/data/data/fuel/

#python modules
export PYTHONPATH=$NN:$NN/libs/fuel:$NN/libs/picklable-itertools:$PYTHONPATH
export PATH=$ASCOPE/libs/fuel/bin:$PATH
