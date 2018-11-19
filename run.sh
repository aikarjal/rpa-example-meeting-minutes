#!/bin/bash
. ./venv/bin/activate
python3 -m robot -d ./output -P ./resources -P ./libraries --logtitle "Task log" ./tasks/*.robot