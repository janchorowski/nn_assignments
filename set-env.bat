REM The directory where the script is
set NN=%~dp0

set FUEL_DATA_PATH=%NN%\datasets

REM python modules
SET PYTHONPATH=%NN%;%NN%\libs\Theano;%NN%\libs\fuel;%NN%\libs\picklable-itertools;%PYTHONPATH%
