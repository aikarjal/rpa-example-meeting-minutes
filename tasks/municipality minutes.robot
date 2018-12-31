*** Settings ***
Resource          keywords.robot
Suite setup       Do Suite Setup
Suite teardown    Do Suite Teardown


*** Tasks ***
Fetch the lates minutes from municipality archive
    Open minutes archive
    Goto municipality minutes
    Open the lates minutes
    Download page content
    Capture page screenshot