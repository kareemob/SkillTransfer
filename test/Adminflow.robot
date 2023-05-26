*** Settings ***
Library    Browser
Library    OperatingSystem
Library    Collections
Library    String
Library    Process
Library    DebugLibrary
Library    FakerLibrary

*** Variables ***
${base_url}        https://skilltransfers.com
${randomEmail}    #Find it on "Register as a new community" in Keywords
${random_name}    #Find it on "Register as a new community" in Keywords
${randomName}    #Find it on "Register as a new community" in Keywords
${CourseName}    #Find it on "Add an Available Course" in Keywords
${courseURL}    #Find it on "Add an Available Course" in Keywords
${question}    #Find it on "Create a quiz " in Keywords
${levelalert}    #Find it on "Add level to a course" in Keywords
${price}    #Find it on "Add price to existing course" in Keywords
${deleteMessage}    #Find it on "Delete course" in Keywords
${CourseMessage}    #Find it on "Add a course without url" in Keywords
${Cname_alert}    #Find it on "Add a course with an empty name" in Keywords
${helptext}    #Find it on "Add a course with a name that contain special characters" in Keywords
${Updatealert}    #Find it on "Edit course details" in Keywords
${newName}    #Find it on "Edit course details" in Keywords
${quizmessage}    #Find it on "Edit quiz" in Keywords
${validEmail}    kareem@gmail.com
${invalidEmail}    example.com
${validPassword}    Test123!
${invalidPassword}    teest12
${EmptyEmail}
${course_count}
${course_num}
${homepagetitle}
${subtitle}
${Button_Count}   80


*** Test Cases ***


Test the login functionality (admin should be able to login with valid email and password)
    [Tags]    login
    Login as a admin    ${validEmail}    ${validPassword}
    ${Cursussen}    Get Text    css=[data-cy="Course_Lavel"]
    Should Be Equal As Strings    ${Cursussen}      Cursussen  

Test the login functionality (admin should not be able to login with invalid email and valid password)
    [Tags]    fail
    Login as a admin    ${invalidEmail}    ${validPassword}
    ${emailAlert}    Get Text    id=email-helper-text
    Should Be Equal As Strings    ${emailAlert}    Invalid email address

#Test the login functionality (admin should not be able to login with valid email and invalid password) BUG
    #[Tags]    invalidP
    #Login as a admin    ${validEmail}    ${invalidPassword}
    
Test the login functionality (admin should not be able to login with empty email and valid password)
    [Tags]    empty
    Login as a admin    ${EmptyEmail}    ${validPassword}
    ${ErrorAlert}    Get Text    id=email-helper-text
    Should Be Equal As Strings    ${ErrorAlert}    Please add your email address

Test course creation message appearance
    [Tags]    createCourse
    Login as a admin    ${validEmail}    ${validPassword} 
    Add an Available Course
    Sleep    1s
    ${CourseMessage}    Get Text    xpath=//*[@id="root"]/div[2]/div/div/div/div/div
    Should Be Equal As Strings    De cursus is succesvol gemaakt!      ${CourseMessage}  

Admin should not be able to create a course without adding a url  #BUG
    [Tags]    courseurl
    Login as a admin    ${validEmail}    ${validPassword}
    Add a course without a url
    Should Be Equal As Strings    De cursus is succesvol gemaakt!      ${CourseMessage} 

Admin should not be able to create a course with empty name
    [Tags]    name
    Login as a admin    ${validEmail}    ${validPassword}
    Add a course with an empty name
    Should Be Equal As Strings    ${Cname_alert}    Voeg een cursusnaam toe

Admin should not be able to put special characters with course name
    [Tags]    chn
    Login as a admin    ${validEmail}    ${validPassword}
    Add a course with a name that contain special characters
    Should Be Equal As Strings    ${helptext}    Alleen cijfers, letters, punt (.), spatie ( ) en onderstrepingsteken (_)

Admin should be able to upload a course photo
    [Tags]    cph
    Login as a admin    ${validEmail}    ${validPassword}
    Add a course with a photo

Test quiz message 
    [Tags]    quiz
    Add an Available Course
    Edit quiz
    Should Be Equal As Strings    Quiz created Successfully!!    ${quizmessage}

Test adding level to a course
    [Tags]    level
    Login as a admin    ${validEmail}    ${validPassword} 
    Add a level to a course
    Sleep    1s
    Should Be Equal As Strings    ${levelalert}    Level created successfully!!

Editing course price
    [Tags]    price
    Login as a admin    ${validEmail}    ${validPassword} 
    Add price to existing course
    Should Be Equal As Strings    ${price}    € 15

Editing course functionality
    [Tags]    edit
    Login as a admin    ${validEmail}    ${validPassword}
    Edit course details
    Should Be Equal As Strings    ${Updatealert}    Cursus succesvol bijgewerkt!
    Should Be Equal As Strings    ${newName}    Appium

Deleting course
    [Tags]    delete
    Delete course
    Should Be Equal As Strings    ${deleteMessage}    Cursus succesvol verwijderd!
    Should Not Exist    css=[data-cy="Course_name_0"]

Verifying number of Courses in admin page is the same in dashboard page   
    [Tags]    Verify
    Login as a admin    ${validEmail}    ${validPassword}
    Getting course number
    Should Be Equal As Integers    ${course_num}    ${course_count}

Verify home page title and home page subtitle
    [Tags]   title
    Login as a admin    ${validEmail}    ${validPassword}
    Input title and subtitle
    Should Be Equal As Strings    ${homepagetitle}    QAcart
    Should Be Equal As Strings    ${subtitle}    innovative quality solutions

Test sorting courses by Avalability    #need to be improved
    [Tags]    
    Login as a admin    ${validEmail}    ${validPassword}
    ${randomIndex}    Evaluate    random.randint(1, ${Button_Count})
    ${buttonxpath}    Set Variable    //*[@id="root"]/main/div/div/div[2]/div/table/tbody/tr[${randomIndex}]/td[1]/div/div/span/span/input
    Click    ${buttonxpath}
    Click    "Ja"
    Sleep     2s
    ${Beforeclick}    Get Element Count    css=[type="checkbox"] 
    #Need improvment
    
    Click    //*[@id="root"]/div[1]/div/div/div/div/ul/div[2]/div
    ${AfterClick}    Get Element Count    .MuiButton-sizeSmall
    Should Be Equal As Integers    ${Beforeclick -1}    ${AfterClick}
    Go Back
    Click    ${buttonxpath}
    Click    "Ja"
    

    

    
    
    
    



    
    










*** Keywords ***
Register as a new community
    Open Browser    ${base_url}     chromium
    Click    "Start je cursus"
    ${random_name}    FakerLibrary.First Name
    ${randomName}    Convert To Lower Case    ${random_name}
    Fill Text    id=domainname    ${randomName}
    Click    css=[type="submit"]
    ${randomEmail}    FakerLibrary.Email
    Set Global Variable    ${randomEmail}
    Fill Text    id=email    ${randomEmail}
    Click    css=[type="submit"]
    Fill Text    id=password    Test!123
    Fill Text    id=password2    Test!123
    Click    xpath=//*[@id="root"]/main/div[2]/div/div/div[2]/div[2]/form/div[7]/div[2]/button/span[1]
    Click    css=button[type='submit'] span[class='MuiTouchRipple-root']
    Fill Text     id=email      ${randomEmail}
    Fill Text      id=password   Test!123
    Click    css=[type="submit"]
    
Login as a admin
    [Arguments]     ${loginEmail}     ${loginPassword}
    Open Browser    https://kareem.skilltransfers.com/login    chromium
    Fill Text    id=email        ${loginEmail}
    Fill Text    id=password     ${loginPassword}
    Click    "LOGIN"

Add a course with a photo
    Click    "Creëer Cursus"
    Upload File By Selector    xpath=/html/body/div[2]/div[3]/div/form/div/div[1]/span/label/div     download.png 
    Fill Text    id=course    SeleniumCourse
    Fill Text    id=videoUrl    ${courseURL}
    Fill Text    id=description    the best course
    Click    css=[type="submit"]

Add a course with a name that contain special characters
    browser.Click    "Creëer Cursus"
    Fill Text    id=course    N@me
    Fill Text    id=description    the best course
    Click    "Opslaan"
    ${helptext}    Get Text    id=course-helper-text
    Set Global Variable    ${helptext}

Add a course with an empty name
    Click    "Creëer Cursus"
    Fill Text    id=description    the best course
    Click    "Opslaan"
    ${Cname_alert}    Get Text    id=course-helper-text
    Set Global Variable    ${Cname_alert}

Add a course without a url
    Click    "Creëer Cursus"
    ${CourseName}    FakerLibrary.Name
    Fill Text    id=course    ${CourseName}
    Fill Text    id=description    the best course
    Click    "Opslaan"
    Wait For Elements State    xpath=//*[@id="root"]/div[2]/div/div/div/div/div
    ${CourseMessage}    Get Text    xpath=//*[@id="root"]/div[2]/div/div/div/div/div 
    Set Global Variable   ${CourseMessage} 

Add an Available Course
    Login as a admin    ${validEmail}    ${validPassword} 

    Click    "Creëer Cursus"
    ${CourseName}    FakerLibrary.Name
    Set Global Variable    ${CourseName}
    Fill Text    id=course    ${CourseName}
    ${courseURL}    FakerLibrary.Url
    Set Global Variable    ${courseURL}
    Fill Text    id=videoUrl    ${courseURL}
    Fill Text    id=description    the best course
    Click    css=[type="submit"]

Add Non-available Course
    Register as a new community
    Click    "Creëer Cursus"
    Click    xpath=//*[@id="status"]
    Click    css=[data-value="Unavailable"]    
    Fill Text    id=course    ${CourseName}
    Fill Text    id=videoUrl    ${courseURL}
    Fill Text    id=description    the best course
    Click    css=[type="submit"]

Create a quiz   
    Add an Available Course
    Click    "Create Quiz"
    Fill Text    id=quizTitle    rate your skills
    Fill Text    id=description    50% or higher to pass
    ${question}    FakerLibrary.Text
    Set Global Variable    ${question}
    Fill Text    id=questions[0].name       ${question}
    Fill Text    id=questions[0].options[0].name    True
    Fill Text    id=questions[0].options[1].name    False
    Fill Text    id=questions[0].options[2].name    False
    Click    id=questions[0].options[0].isAnswer
    Click    css=[data-value="true"]
    Click    id=questions[0].options[1].isAnswer
    Click    css=[data-value="false"]
    Click    id=questions[0].options[2].isAnswer
    Click    css=[data-value="false"]
    Click    "PUBLISH NOW"

add 4th answer and delete it
    Create a quiz
    Click    xpath=//*[@id="root"]/main/div/div/div[3]/div/form/div/div[3]/div/div/div[1]/div[3]/div[2]/button/span[1]/img
    debug
    Fill Text    id=questions[0].options[3].name    False
    Click    id=questions[0].options[3].isAnswer
    Click    css=[data-value="false"]
    Click    xpath=//*[@id="root"]/main/div/div/div[3]/div/form/div/div[3]/div/div/div[2]/div/div[4]/div[3]/button/span[1]/img
    Click    "PUBLISH NOW"

Add a level to a course
    Click    //*[@id="root"]/main/div/div/div[2]/div/table/tbody/tr[45]/td[7]/button[1]/span[1]/img
    Sleep    3s
    Fill Text    id=level    Beginner
    Click    [data-cy="Level_Order"]   
    Click    [data-value="2"] 
    Fill Text    id=skill    level2
    Click    id=preview
    Fill Text    id=youtubeLink        https://www.youtube.com/watch?v=r-uOLxNrNk8
    Click    "Opslaan"
    Sleep    1s
    ${levelalert}    Get Text    css=[class="MuiAlert-message"]
    Set Global Variable    ${levelalert}   

Add price to existing course
    Click    css=[data-cy="Edit_Course_0"]
    browser.Click    id=isPriceEnable
    browser.Click    id=isPriceEnable
    
    
    
    Fill Text    id=price    15
    Click    "Opslaan"
    ${price}    Get Text    //*[@id="root"]/main/div/div/div[2]/div/table/tbody/tr[1]/td[6]
    Set Global Variable    ${price} 

Delete course
    Login as a admin    ${validEmail}    ${validPassword}
    Click    css=[data-cy="Delete_Course_0"]
    Click    "Ja"
    Sleep    1s
    ${deleteMessage}    Get Text    .MuiAlert-message
    Set Global Variable    ${deleteMessage}

Edit course details
    Click    css=[data-cy="Edit_Course_1"]
    Fill Text    id=course    Appium
    Fill Text    id=description    the best appium course
    Upload File By Selector    xpath=/html/body/div[2]/div[3]/div/form/div/div[2]/span/label/div     appium.png
    Click    "Opslaan"
    Wait For Elements State    css=[class="MuiAlert-message"]
    ${Updatealert}    Get Text    css=[class="MuiAlert-message"]
    Set Global Variable    ${Updatealert}
    ${newName}    Get Text    css=[data-cy="Course_name_1"]
    Set Global Variable    ${newName}

Edit quiz
    ${Create_Quiz_Button}    Get Element Count    .MuiButton-label
    Set Global Variable    ${Create_Quiz_Button}
    Click    xpath=//*[@id="root"]/main/div/div/div[2]/div/table/tbody/tr[${Create_Quiz_Button -2}]/td[8]/button/span[1]
    Fill Text    id=quizTitle    rate your skills
    Fill Text    id=description    50% or higher to pass
    ${question}    FakerLibrary.Text
    Set Global Variable    ${question}
    Fill Text    id=questions[0].name       ${question}
    Fill Text    id=questions[0].options[0].name    True
    Fill Text    id=questions[0].options[1].name    False
    Fill Text    id=questions[0].options[2].name    False
    Click    id=questions[0].options[0].isAnswer
    Click    css=[data-value="true"]
    Click    id=questions[0].options[1].isAnswer
    Click    css=[data-value="false"]
    Click    id=questions[0].options[2].isAnswer
    Click    css=[data-value="false"]
    Click    "PUBLISH NOW"
    Sleep     1s
    ${quizmessage}    Get Text    css=[class="MuiAlert-message"]
    Set Global Variable    ${quizmessage}

Getting course number
    ${course_count}    Get Element Count    css=[alt="bin"]
    Set Global Variable    ${course_count}
    #${course_count}    Get Element Count    css=.MuiAvatar-circle
    Click    xpath=//*[@id="root"]/div[1]/div/div/div/ul/a[1]
    ${course_num}    Get Text    xpath=//*[@id="root"]/main/div/div/div[2]/div[2]/div/div/div[2]
    Set Global Variable    ${course_num}

Input title and subtitle
    Click    xpath=//*[@id="root"]/div[1]/div/div/div/ul/li/div/div/div[2]/button/span/div/img
    Click    "Instellingen"
    Fill Text    id=homePageTitle    QAcart
    Fill Text    id=homePageSubtitle    innovative quality solutions
    Fill Text    id=linkWebsite    https://qacart.com/
    Click    "Opslaan"
    Click    xpath=//*[@id="root"]/div[1]/div/div/div/div/ul/div[2]/div
    ${homepagetitle}    Get Text    .MuiTypography-h3 
    Set Global Variable    ${homepagetitle}
    ${subtitle}    Get Text    .MuiTypography-subtitle1
    Set Global Variable    ${subtitle}