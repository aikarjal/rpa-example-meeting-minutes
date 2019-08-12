#!/bin/bash

# MacOS script to be configured as command triggered from cloud
# prepares environment and executes task

if [[ $# -eq 0 ]] ; then
    export browser=chrome
else
    export browser=$1
fi

echo environment dump when starting
set

python3 -m venv ./venv
. ./venv/bin/activate
pip install --upgrade pip
pip install -r ./requirements.txt
webdrivermanager $browser

python -m robot -d output -P resources -P libraries --logtitle "Task log" tasks/

