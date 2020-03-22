*** Settings ***
Library     SeleniumLibrary
Library     KeywordLibrary
Library     String
Resource    config.robot

*** Keywords ***
Do Suite Setup
    [Arguments]
    Set Selenium Timeout  15
    
Do Suite Teardown
    Close Browser

Avaa selain
    [Arguments]  ${url}
    Open browser  ${url}  browser=${BROWSER}

Open minutes archive
    Avaa selain  ${ARKISTO_URL}
    Wait for text to appear  Toimielimet

Goto municipality minutes
    Click element  (//a[.='Kaupunginhallitus'])[3]
    Wait until page contains element  link:Pöytäkirja
    # TODO find minutes based on year

Open the lates minutes
    Click link  Pöytäkirja
    Wait until page contains element  class:lnk
    Click element  class:lnk
    Change to another tab in browser

Download page content
    ${url}=  Get Location
    ${ret}=  Verify that the document is a PDF  ${url}
    Run Keyword If  ${ret}==True  Download PDF document  ${url}
    ...  ELSE  Handle exception  Cannot read PDF file from  ${url}

Verify that the document is a PDF
    [Arguments]  ${url}
    ${ret}=  Run Keyword And Return Status  Should Match Regexp  ${url}  (?i)pdf$
    [Return]  ${ret}

Handle exception
    [Arguments]  ${message}
    Pass Execution  ${message}

Download PDF document
    [Arguments]  ${url}
    ${resp}=  KeywordLibrary.download_document  ${url}
    Run Keyword If  ${resp} == False  Handle exception  Failed to download document ${url}

Wait for text to appear
    [Arguments]  ${teksti}
    Wait Until Page Contains  ${teksti}

Change to another tab in browser
    @{list}=  Get Window Handles
    Select Window  @{list}[1]

