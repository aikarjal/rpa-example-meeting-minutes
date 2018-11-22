#!/bin/bash
if [[ $# -eq 0 ]] ; then
    export browser=chrome
else
    export browser=$1
fi

python3 -m venv ./venv
. ./venv/bin/activate
pip install --upgrade pip
pip install -r ./requirements.txt
webdrivermanager $browser
