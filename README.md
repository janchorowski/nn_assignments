This is the starter code for assignments. To begin please clone it to your computer:

1. on **Linux** execute `git clone --recursive https://github.com/janchorowski/nn_assignments.git`
2. on **Windows** first install a `git` client, such as [TortoiseGIT](https://tortoisegit.org/). Alternatively, you may want the console tools [MSysGit](https://git-for-windows.github.io/). Then clone the repository either using the GUI (remember to check the **recursive**) option, or from the Git bash shell using  `git clone --recursive https://github.com/janchorowski/nn_assignments.git`.

After downloading the code you need to set some environment variables:

1. On **Linux** fire up a shell and `source set-env.sh`.
2. On **Windows** fire up the python shell, then execute `set-env.bat`.

To run the notebook, execute

`$ jupyter notebook`

or `ipython notebook` in the case of older version. You will interact with the notebook through your web browser.

Finally you need the datasets:

1. On **Lab computers** they are already downloaded to `/pio/data/data/fuel`, just make sure that the `FUEL_DATA_PATH` variable is set (it should be set by the `set-env` scripts).
2. On your own computer, please download the datasets into the `datasets` folder, see its README for details. Also, make sure that the `datasets` folder is on the 
`FUEL_DATA_PATH` (it should be set by the `set-env` scripts).
