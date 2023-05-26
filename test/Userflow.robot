*** Settings ***
Library    Browser
Library    OperatingSystem
Library    Collections
Library    String
Library    Process
Library    DebugLibrary
Library    FakerLibrary



*** Test Cases ***

Login as user
    Open Browser    https://skilltransfers.com/    chromium
    Click    "Communities"
    Click    "kareem"
    Click    xpath=/html/body/div/main/div/div/div/div[1]/div/div[3]/button/span[1]
    Click    "SCHRIJF JE NU IN"
    Debug