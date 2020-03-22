
@REM Windows script to be configured as command triggered from cloud
@REM prepares environment and executes task

echo environment dump when starting
set

py -m venv venv
call venv\Scripts\activate

python -m pip install --upgrade pip
pip install -r requirements.txt
webdrivermanager chrome

python -m robot -d output -P resources -P libraries --logtitle "Task log" tasks/

call venv\Scripts\deactivate
