*** Settings ***
Resource          keywords.robot
Suite setup       Do Suite Setup
Suite teardown    Do Suite Teardown


*** Tasks ***
Hae uusin kaupunginhallituksen pöytäkirja
    Avaa pöytäkirja-arkisto
    Avaa kaupunginhallituksen pöytäkirjat
    Avaa uusin pöytäkirja
    Lataa sivun sisältö
