REM The directory where the script is
set NN=%~dp0

set FUEL_DATA_PATH=%NN%\datasets

set BLOCKS_CONFIG=%NN%\config\blocks.yaml
set THEANORC=%NN%\config\theano.rc;%HOME%\.theanorc

REM python modules
SET PYTHONPATH=%NN%;%NN%\libs\Theano;%NN%\libs\fuel;%NN%\libs\picklable-itertools;%PYTHONPATH%
