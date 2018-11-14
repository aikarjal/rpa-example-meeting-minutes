*** Settings ***
Library     SeleniumLibrary
Resource    variables.robot

*** Keywords ***
Do Suite Setup
    [Arguments]
    Set Selenium Timeout  15
    
Do Suite Teardown
    Close Browser

Avaa selain
    [Arguments]  ${url}
    Open browser  ${url}  browser=chrome

Avaa pöytäkirja-arkisto
    Avaa selain  ${ARKISTO_URL}
    Odota tekstiä  Toimielimet

Avaa kaupunginhallituksen pöytäkirjat
    Click element  (//a[.='Kaupunginhallitus'])[3]
    Wait until page contains element  link:Pöytäkirja

Avaa uusin pöytäkirja
    Click link  Pöytäkirja
    Wait until page contains element  class:lnk
    Click element  class:lnk
    Vaihda välilehti
    Sleep  10

Ota näyttökuva
    Capture page screenshot

Odota tekstiä
    [Arguments]  ${teksti}
    Wait Until Page Contains  ${teksti}

Vaihda välilehti
    @{list}=  Get Window Handles
    Select Window  @{list}[1]