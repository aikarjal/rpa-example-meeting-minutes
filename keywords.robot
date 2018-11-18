*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     String
Library     OperatingSystem
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

Lataa sivun sisältö
    ${url}=  Get Location
    ${ret}=  Tarkista että dokumentti on pdf  ${url}
    Run Keyword If  ${ret}==True  Lataa pdf asiakirja  ${url}
    ...  ELSE  Poikkeuskäsittely  Ei voitu lukea pdf-tiedostoa kohteesta ${url}

Tarkista että dokumentti on pdf
    [Arguments]  ${url}
    ${ret}=  Run Keyword And Return Status  Should Match Regexp  ${url}  (?i)pdf
    [Return]  ${ret}

Poikkeuskäsittely
    [Arguments]  ${message}
    Pass Execution  ${message}

Lataa pdf asiakirja
    [Arguments]  ${url}
    @{substrings}=  Split String From Right  ${url}  /  1
    ${base_url}=  Set Variable  @{substrings}[0]
    ${document_name}=  Set Variable  @{substrings}[1]
    Create Session  session  ${base_url}
    ${resp}=  Get Request  session  /${document_name}
    Run Keyword If  ${resp.status_code} == 200  Tallenna tiedosto  ${resp}  ${document_name}
    ...  ELSE  Poikkeuskäsittely  Asiakirjan ${document_name} lataaminen epäonnistui

Tallenna tiedosto
    [Arguments]  ${resp}  ${document_name}
    Create Directory  .${/}pdf
    Create Binary File  .${/}pdf${/}${document_name}  ${resp.content}

Odota tekstiä
    [Arguments]  ${teksti}
    Wait Until Page Contains  ${teksti}

Vaihda välilehti
    @{list}=  Get Window Handles
    Select Window  @{list}[1]

Ota näyttökuva
    Capture Page Screenshot