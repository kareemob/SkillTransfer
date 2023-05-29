*** Settings ***
Library    Browser
Library    OperatingSystem
Library    Collections
Library    String
Library    Process
Library    DebugLibrary
Library    FakerLibrary

*** Variables ***
${ValidEmail}    Kareemobaidat9@gmail.com
${ValidPassword}    Test123!
${INvalidEmail}    Example.com
${INvalidPassword}    1234567
${Emptyemail}
${EmptyPassword}
${BUTTON_COUNT}   80
${Cmessage}    #Find it "Register to a Course" in Keywords



*** Test Cases ***

User should be able to login with valid email and password
    [Tags]    login
    Login as user    ${ValidEmail}    ${ValidPassword}
    ${Titletext}    Get Text    .MuiTypography-h3
    Should Be Equal As Strings    ${Titletext}    QAcart

User should not be able to login with invalid email and valid password
    [Tags]    inlog
    Login as user    ${INvalidEmail}    ${ValidPassword}
    ${invalidalert}    Get Text    id=email-helper-text
    Should Be Equal As Strings    ${invalidalert}    Ongeldig e-mailadres

#User should not be able to login with valid email and invalid password    BUG
    #[Tags]    vel
    #Login as user    ${ValidEmail}    ${INvalidPassword}

User should not be able to login with empty email and valid password
    [Tags]    Epm
    Login as user    ${Emptyemail}    ${ValidPassword}
    ${Addalert}    Get Text    id=email-helper-text
    Should Be Equal As Strings    ${Addalert}    Voeg uw e-mailadres toe

User should not be able to login with valid email and empty password
    [Tags]    pem
    Login as user    ${ValidEmail}    ${EmptyPassword}
    ${passalert}    Get Text    id=password-helper-text
    Should Be Equal As Strings    ${passalert}    Geen wachtwoord opgegeven
    
User should be able to enroll any course
    [Tags]    enroll
    Login as user    ${ValidEmail}    ${ValidPassword}
    Enroll to a Course
    Should Be Equal As Strings    ${Cmessage}     Hoerraa!\nJij bent ingeschreven voor   

User should not be able to enroll in the same course multiple times.
    [Tags]    mul
    Login as user    ${ValidEmail}    ${ValidPassword}
    ${Rcourse}    Get Text    //*[@id="root"]/main/div/div/div[2]/div[8]/div/div[3]/a/span[1]
    Should Be Equal As Strings    ${Rcourse}    GA NAAR CURSUS





    

*** Keywords ***

Login as user
    [Arguments]    ${Email}    ${Password}
    Open Browser    https://kareem.skilltransfers.com/    chromium
    Click    "Inloggen"
    Fill Text    id=email    ${Email}
    Fill Text    id=password    ${Password}
    Click    "INLOGGEN"

Enroll to a Course
    ${random_index}    Evaluate    random.randint(1, ${BUTTON_COUNT})
    ${button_xpath}    Set Variable    (//*[@id="root"]/main/div/div/div[2]/div)[${random_index}]/div/div[3]/button/span[1]
    Click    ${button_xpath}
    Click    "schrijf je nu gratis in"
    Click    "ja, schrijf mij in"
    ${RegisterM}    Get Text    .MuiTypography-alignCenter
    ${Cmessage}    Get Substring    ${RegisterM}    0    35
    Set Global Variable    ${Cmessage}