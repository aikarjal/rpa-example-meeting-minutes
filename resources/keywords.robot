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

Lataa sivun sisältö
    ${url}=  Get Location
    ${ret}=  Tarkista että dokumentti on pdf  ${url}
    Run Keyword If  ${ret}==True  Lataa pdf asiakirja  ${url}
    ...  ELSE  Poikkeuskäsittely  Ei voitu lukea pdf-tiedostoa kohteesta ${url}

Tarkista että dokumentti on pdf
    [Arguments]  ${url}
    ${ret}=  Run Keyword And Return Status  Should Match Regexp  ${url}  (?i)pdf$
    [Return]  ${ret}

Poikkeuskäsittely
    [Arguments]  ${message}
    Pass Execution  ${message}

Lataa pdf asiakirja
    [Arguments]  ${url}
    ${resp}=  KeywordLibrary.lataa_asiakirja  ${url}
    Run Keyword If  ${resp} == False  Poikkeuskäsittely  Asiakirjan ${url} lataaminen epäonnistui

Odota tekstiä
    [Arguments]  ${teksti}
    Wait Until Page Contains  ${teksti}

Vaihda välilehti
    @{list}=  Get Window Handles
    Select Window  @{list}[1]

Ota näyttökuva
    Capture page screenshot