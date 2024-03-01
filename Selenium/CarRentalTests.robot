*** Settings ***
Suite Setup    Run Keywords    Open Chrome browser and maximize
...    AND    Set date variables as suite variables
Suite Teardown    Close All Browsers
Test Teardown    Run Keywords    Cancel all bookings
...    AND      Logout user

Library    SeleniumLibrary
Library    DateTime
Library    Collections

*** Variables ***
${browser}    chrome
${infotivCarRentalUrl}    http://rental14.infotiv.net/webpage/html/gui/
${carSelectionUrl}    http://rental14.infotiv.net/webpage/html/gui/showCars.php

${emailInputElement}    //input[@id='email']
${passwordInputElement}    //input[@id='password']
${loginButtonElement}    //button[@id='login']
${invalidLoginLabel}    //label[@id='signInError' and text()='Wrong e-mail or password ']

${signedInTextElement}    //label[@id='welcomePhrase']
${logoutButtonElement}    //button[@id='logout']
${myPageButtonElement}    //button[@id='mypage']

${startDateInputElement}    //input[@id='start' and @type='date']
${endDateInputElement}    //input[@id='end' and @type='date']
${continueButtonElement}    //button[@id='continue']
${resetDateSelectorButton}    //button[@id='reset']

${carRentalHeaderElement}    //h1[@id='questionText' and text()='What would you like to drive?']
${carSelectionElement}    //div[@id='carSelection']
${carTableCarRow}    //table[@id='carTable']//tr[@class='carRow']
${carToSelect}    //table[@id='carTable']//tr[@class='carRow'][1]
${carMakeFilterButton}    //div[@id='filterMakeHolder']//button
${passengerFilterButton}    //div[@id='filterPassHolder']//button
${noCarsMatchFilterLabel}    //div[@id='carSelection']//label[text()='No cars with selected filters. Please edit filter selection.']

${cardNumberInput}    //input[@id='cardNum']
${cardHolderInput}    //input[@id='fullName']
${monthSelectElement}    //select[@title='Month']
${yearSelectElement}    //select[@title='Year']
${cvcInput}    //input[@id='cvc']
${confirmButton}    //button[@id='confirm']

${myPageMakeElement}    //td[@id='make1']
${myPageModelElement}    //td[@id='model1']

${loginUserEmail}    testuser@test.com
${loginPassword}    TestPassword

${invalidDateBeforeToday}    2024-01-02

${carBookingWithoutSignInAlertMessage}    You need to be logged in to continue.

${carMakeToFilter}    Audi

${confirmBookingHeader}    //h1[@id='questionText']
${confirmBookingHeaderPattern}    Confirm booking of *

${validCardNumber}    1584333531329997
${invalidCardNumber}    12345
${nameOfCardHolder}    Test Testsson
${cardExpirationDate}    2025-02
${cvcCode}    123

${myPageUrl}    http://rental14.infotiv.net/webpage/html/gui/myPage.php

*** Test Cases ***
End-to-end car rental
    [Documentation]    Test case for the entire flow from start page to renting a car
    [Tags]    end-to-end    car-rental    VG_test
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    AND User selects a car to book
    AND User enters valid confirmation information
    AND User clicks confirm button
    THEN Page should display successful booking information
    AND My booking page should display booked car
    

Invalid user login should display error
    [Documentation]    Negative test for testing invalid user credentials
    [Tags]    login    invalid-login    header    negative-test
    Given User is on Infotiv Car Rental website
    When User logs in with invalidUser and invalidPassword
    Then Page should display login error message

Valid user login
    [Documentation]    Test case for testing valid login credentials
    [Tags]    login    valid-login    header
    Given User is on Infotiv Car Rental website
    When User logs in with ${loginUserEmail} and ${loginPassword}
    Then Page should display user information    
    And Page should display logout button
    And Page should display My page button

Valid date selection
    [Documentation]    Test case for testing valid date selection for trip according to valid dates
    ...    from the documentation.
    [Tags]    date-selection    valid-date-selection
    Given User is on Infotiv Car Rental website
    When User selects valid start and end date
    Then Start Date and End Date inputs should display correct dates

Valid date selection and continue
    [Documentation]    Test case for selecting valid dates and continuing to car selection page
    [Tags]    date-selection    valid-date-selection
    Given User is on Infotiv Car Rental website
    When User selects valid start and end date
    AND User clicks continue button
    Then Website should display car rental page

Page displays error when selecting start date before today
    [Documentation]    Test case for checking that the date selector displays an error message
    ...    when selecting a start date before todays date in accordance with the documentation.
    [Tags]    date-selection    invalid-date-selection    negative-test
    Given User is on Infotiv Car Rental website
    When User selects start date    ${invalidDateBeforeToday}
    AND User clicks continue button
    Then Start Date selector should display error

Page displays error when selecting start date over one month from today
    [Documentation]    Test case for checking that the date selector displays an error when
    ...    selecting a start date that is over one month from today.
    [Tags]    date-selection    invalid-date-selection    negative-test
    Given User is on Infotiv Car Rental website
    When User selects start date over month from today
    And User clicks continue button
    Then Start Date selector should display error

Page displays error when selecting end date over one month from today
    [Documentation]    Test case for checking that the date selector displays an error message
    ...    when selecting an end date that is over one month from today in accordance with
    ...    the documentation.
    [Tags]    date-selection    invalid-date-selection
    Given User is on Infotiv Car Rental website
    When User selects start date    ${today}
    AND User selects end date over month from today
    AND User clicks continue button
    Then End Date selector should display error

Page displays error when selecting end date before start date
    [Documentation]    Test case for checking that the date selector displays an error message
    ...    when selecting an end date that is before the start date.
    [Tags]    date-selection    invalid-date-selection
    Given User is on Infotiv Car Rental website
    When User selects start date    ${tomorrow}
    AND User selects end date    ${today}
    And User clicks continue button
    Then End Date selector should display error

Date selector resets to todays date when clicking reset button
    [Documentation]    Test case for checking that the date selector resets the start and end date when
    ...    the user clicks the reset button.
    [Tags]    date-selection    reset-date-selection
    Given User is on Infotiv Car Rental website
    When User selects start date    ${tomorrow}
    And User selects end date    ${dayAfterTomorrow}
    And User clicks reset button
    Then Date selector should display todays date as start and end date

Valid Car booking
    [Documentation]    Test case for booking a car on the car rental page
    [Tags]    car-selection    valid-car-selection
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    When User selects a car to book
    Then Page should display booking confirmation

Booking a car without signing in should give error
    [Documentation]    Test case for making sure website displays error when attempting to book
    ...    a car without signing in according to the documentation.
    [Tags]    car-selection    invalid-car-selection    negative-test
    Given User is on Infotiv Car Rental website
    AND User selects valid start and end date
    AND User clicks continue button
    When User selects a car to book
    Then Car selection page should display an error

Filtering cars on make should display filtered cars
    [Documentation]    Test case for filtering available cars on make
    [Tags]    car-selection    filter-car-selection    expected-fail
    Given User is on Infotiv Car Rental website
    And User selects valid start and end date
    And User clicks continue button
    When User filters car on make    ${carMakeToFilter}
    Then Page should display correct number of filtered cars

Filtering cars on passengers should display filtered cars
    [Documentation]    Test case for filtering available cars on passengers
    [Tags]    car-selection    filter-car-selection    expected-fail
    Given User is on Infotiv Car Rental website
    And User selects valid start and end date
    And User clicks continue button
    When User filters car on passengers    5
    Then Page should display correct number of filtered cars

Selecting a filter with no cars should display message
    [Documentation]    Test case for checking that the page displays a message when selecting a
    ...    filter that doesn't match any cars
    [Tags]    car-selection    filter-car-selection
    Given User is on Infotiv Car Rental website
    And User selects valid start and end date
    And User clicks continue button
    When User filters car on make    ${carMakeToFilter}
    And User filters car on passengers    9
    Then Page should display message for filter with no cars

Resetting make filter should display original number of cars
    [Documentation]    Test case for making sure the page displays the original number of cars
    ...    after setting and resetting the make filter.
    [Tags]    car-selection    filter-car-selection    expected-fail
    Given User is on Infotiv Car Rental website
    And User selects valid start and end date
    And User clicks continue button
    And User filters car on make    ${carMakeToFilter}
    When User unselects make filter    ${carMakeToFilter}
    Then Page should display original number of cars

Valid Booking Confirmation
    [Documentation]    Test case for making a valid booking confirmation
    [Tags]    booking-confirm    valid-booking-confirm
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    AND User selects a car to book
    AND User enters valid confirmation information
    AND User clicks confirm button
    THEN Page should display successful booking information

Entering invalid card number should display error
    [Documentation]    Test case for making a valid booking confirmation
    [Tags]    booking-confirm    invalid-booking-confirm    negative-test
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    AND User selects a car to book
    AND User enters card number    111
    AND User clicks confirm button
    THEN Card number input should display error

Entering empty card holder name should display error
    [Documentation]    Test case for attempting to confirm a booking with an empty name
    [Tags]    booking-confirm    invalid-booking-confirm    negative-test
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    AND User selects a car to book
    AND User enters card number    ${validCardNumber}
    AND User enters card holder name    ${EMPTY}
    AND User clicks confirm button
    THEN Card holder name input should display error

Entering empty cvc code should display error
    [Documentation]    Test case for attempting to confirm a booking with an empty cvc code
    [Tags]    booking-confirm    invalid-booking-confirm    negative-test
    Given User is on Infotiv Car Rental website
    AND User logs in with ${loginUserEmail} and ${loginPassword}
    AND User selects valid start and end date
    AND User clicks continue button
    AND User selects a car to book
    AND User enters card number    ${validCardNumber}
    AND User enters card holder name    ${nameOfCardHolder}
    AND User enters cvc code    ${EMPTY}
    AND User clicks confirm button
    THEN Cvc input should display error

*** Keywords ***
Open Chrome browser and maximize
    [Documentation]    Suite setup keyword for opening and maximizing chrome and setting selenium speed
    [Tags]    suite-setup
    Set Selenium Speed    0.2
    Open Browser    browser=${browser}
    Maximize Browser Window

User is on Infotiv Car Rental website
    [Documentation]    Keyword for navigating to the main car rental website
    [Tags]    car-rental-website
    Go To    ${infotivCarRentalUrl}

# Login keywords
User logs in with ${username} and ${password}
    [Documentation]    Checks for login elements and fills them with username and password argument before submitting
    [Tags]    login
    Wait Until Page Contains Element    ${emailInputElement}
    Wait Until Page Contains Element    ${passwordInputElement}
    Input Text    ${emailInputElement}    ${username}
    Input Password    ${passwordInputElement}    ${password}
    Click Button    ${loginButtonElement}

Page should display login error message
    [Documentation]    Checks that page displays invalid login label
    [Tags]    login    invalid-login
    Wait Until Page Contains Element    ${invalidLoginLabel}

Page should display user information
    [Documentation]    Checks that page displays the signed in user
    [Tags]    login
    Wait Until Page Contains Element    ${signedInTextElement}
    
Page should display logout button
    [Documentation]    Checks that the page displays a logout button
    [Tags]    login
    Wait Until Page Contains Element    ${logoutButtonElement}

Page should display My page button
    [Documentation]    Checks that the page displays the MyPage button
    [Tags]    login
    Wait Until Page Contains Element    ${myPageButtonElement}

# Date selection keywords
User selects start date
    [Documentation]    Selects a start date. Takes a start date as an argument.
    [Tags]    date-selection
    [Arguments]    ${startDate}
    ${startDateDateTime}=    Convert Date To DateTime    ${startDate}
    Press Keys    ${startDateInputElement}    ${startDateDateTime.month}
    Press Keys    ${startDateInputElement}    ${startDateDateTime.day}

User selects end date
    [Documentation]    Selects an end date. Takes an end date as an argument.
    [Tags]    date-selection
    [Arguments]    ${endDate}
    ${endDateDateTime}=    Convert Date To DateTime    ${endDate}
    Press Keys    ${endDateInputElement}    ${endDateDateTime.month}
    Press Keys    ${endDateInputElement}    ${endDateDateTime.day}

User selects valid start and end date
    [Documentation]    Selects a valid start and end date by adding 1 day and 3 days to todays date.
    [Tags]    date-selection
    ${startDate}=    Add Time To Date    ${today}    1 day    result_format=%Y-%m-%d
    ${endDate}=    Add Time To Date    ${today}    3 days    result_format=%Y-%m-%d
    User selects start date    ${startDate}
    User selects end date    ${endDate}

User selects end date over month from today
    [Documentation]    Selects a date over a month from today. Adds 32 days to today.
    [Tags]    date-selection
    ${endDate}=    Add Time To Date    ${today}    32 days    result_format=%Y-%m-%d
    User selects end date    ${endDate}

User selects start date over month from today
    [Documentation]    Selects a start date over a month from today. Adds 32 days to today.
    [Tags]    date-selection
    ${startDate}=    Add Time To Date    ${today}    32 days    result_format=%Y-%m-%d
    User selects start date    ${startDate}

Convert Date To DateTime
    [Documentation]    Utility keyword for converting a date from YYYY-mm-dd to python datetime object.
    [Tags]    utility
    [Arguments]    ${inputDate}
    ${dateTime}=    Convert Date    ${inputDate}    date_format=%Y-%m-%d    result_format=datetime
    RETURN    ${dateTime}

Start Date Input Should Display Correct Date
    [Documentation]    Compares the value of start date input element to the argument startDate
    [Tags]    date-selection
    [Arguments]    ${startDate}
    ${startDateValue}=    Get Value    ${startDateInputElement}
    Should Be Equal    '${startDate}'    '${startDateValue}'

End Date Input Should Display Correct Date
    [Documentation]    Compares the value of end date input element to the argument endDate
    [Tags]    date-selection
    [Arguments]    ${endDate}
    ${endDateValue}=    Get Value    ${endDateInputElement}
    Should Be Equal    '${endDate}'    '${endDateValue}'

Start Date and End Date inputs should display correct dates
    [Documentation]    Makes sure the start and date inputs actually contain the values set by
    ...    the user.
    [Tags]    date-selection
    ${startDate}=    Add Time To Date    ${today}    1 day    result_format=%Y-%m-%d
    ${endDate}=    Add Time To Date    ${today}    3 days    result_format=%Y-%m-%d
    Start Date Input Should Display Correct Date    ${startDate}
    End Date Input Should Display Correct Date    ${endDate}

User clicks continue button
    [Documentation]    Clicks continue button from date selection
    [Tags]    date-selection
    Click Button    ${continueButtonElement}

User clicks reset button
    [Documentation]    Clicks reset button on date selection
    [Tags]    date-selection
    Click Button    ${resetDateSelectorButton}

Start Date selector should display error
    [Documentation]    Makes sure start date selector displays an error message
    [Tags]    date-selection    negative-test
    ${validationMessage}=    Get Element Attribute    ${startDateInputElement}    validationMessage
    Should Match    ${validationMessage}    Value must be *

End Date selector should display error
    [Documentation]    Makes sure end date selector displays an error message.
    [Tags]    date-selection    negative-test
    ${validationMessage}=    Get Element Attribute    ${endDateInputElement}    validationMessage
    Should Match    ${validationMessage}    Value must be *

Date selector should display todays date as start and end date
    [Documentation]    Makes sure start and end date selector displays todays date
    [Tags]    date-selection
    Start Date Input Should Display Correct Date    ${today}
    End Date Input Should Display Correct Date    ${today}

Get Todays date as DateTime
    [Documentation]    Returns todays date as a python datetime object
    [Tags]    utility
    ${today}=    Get Current Date    result_format=datetime

Set date variables as suite variables
    [Documentation]    Sets todays date as a suite variable in the format YYYY-mm-dd
    [Tags]    suite-setup
    ${todayDate}=    Get Current Date    result_format=%Y-%m-%d
    ${tomorrowDate}=    Add Time To Date    ${todayDate}    1 day    result_format=%Y-%m-%d
    ${dayAfterTomorrowDate}=    Add Time To Date    ${tomorrowDate}    2 days    result_format=%Y-%m-%d
    Set Suite Variable    $today    ${todayDate}
    Set Suite Variable    $tomorrow    ${tomorrowDate}
    Set Suite Variable    $dayAfterTomorrow    ${dayAfterTomorrowDate}

# Car Rental Page keywords
Website should display car rental page
    [Documentation]    Checks that the header and car selection element for the car booking page is displayed
    [Tags]    car-selection
    Wait Until Page Contains Element    ${carRentalHeaderElement}
    Wait Until Page Contains Element    ${carSelectionElement}

User is on car rental page
    [Documentation]    Navigates to car selection page
    [Tags]    car-selection
    Go To    ${carSelectionUrl}
    
User selects a car to book
    [Documentation]    Selects the first car from car selection list and stores the make and model
    ...    as test variables for later use
    [Tags]    car-selection
    ${bookedCarMake}=    Get Text    ${carToSelect}//td[1]
    Set Test Variable    $bookedCarMake    ${bookedCarMake}
    ${bookedCarModel}=    Get Text    ${carToSelect}//td[2]
    Set Test Variable    $bookedCarModel    ${bookedCarModel}
    Click Element    ${carToSelect}//input[@value='Book']

Car selection page should display an error
    [Documentation]    Makes sure the car selection page displays an error
    [Tags]    car-selection
    ${alertMessage}=    Handle Alert    ACCEPT
    Should Be Equal As Strings    ${alertMessage}    ${carBookingWithoutSignInAlertMessage}

User filters car on make
    [Documentation]    Filters cars based on car make passed as an argument, saves the
    ...    number of cars before filtering as a test variable.
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${make}
    ${carCountWithMake}=    Get number of cars with specified make    ${make}
    ${totalCarCount}=    Get total number of cars in rental list
    Set Test Variable    $originalCarCount    ${carCountWithMake}
    Set Test Variable    $totalCarCount    ${totalCarCount}
    Set car make filter    ${make}

User filters car on passengers    
    [Documentation]    Filters cars based on number of passengers. Takes number of passengers as argument.
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${numPassengers}
    ${carCountWithNumPassengers}=    Get number of cars with number of passengers    ${numPassengers}
    Set Test Variable    $originalCarCount    ${carCountWithNumPassengers}
    Set Pasenger Filter    ${numPassengers}

User unselects make filter
    [Documentation]    Clears the car make filter based on make passed as argument
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${make}
    Unselect car make filter    ${make}

Set car make filter
    [Documentation]    Sets the car make passed as an argument to be filtered
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${make}
    Click Button    ${carMakeFilterButton}
    Select Checkbox    //input[@type='checkbox' and @value='${make}']
    Click Button    ${carMakeFilterButton}

Set Pasenger Filter
    [Documentation]    Sets the passenger filter to the number of passengers passed as argument
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${numPassengers}
    Click Button    ${passengerFilterButton}
    Select Checkbox    //input[@type='checkbox' and @value='${numPassengers}']

Unselect car make filter
    [Documentation]    Unselects the filter for the car make passed as an argument
    [Tags]    car-selection    car-selection-filter
    [Arguments]    ${make}
    Click Button    ${carMakeFilterButton}
    Unselect Checkbox    //input[@type='checkbox' and @value='${make}']
    Click Button    ${carMakeFilterButton}

Page should display correct number of filtered cars
    [Documentation]    Validates that the filtered number of cars match the number of cars of the filter before filtering
    [Tags]    car-selection    car-selection-filter
    ${filteredCarCount}=    Get total number of cars in rental list
    Should Be Equal As Integers    ${filteredCarCount}    ${originalCarCount}

Page should display original number of cars
    [Documentation]    Verifies that the page currently displays the same total number of cars
    ...    as the original amount before applying any filters
    [Tags]    car-selection    car-selection-filter
    ${currenctCarCount}=    Get total number of cars in rental list
    Should Be Equal As Integers    ${currenctCarCount}    ${totalCarCount}

Page should display message for filter with no cars
    [Documentation]    Verifies that the page displays a message that no cars match the specified filter
    [Tags]    car-selection    car-selection-filter
    Click Button    ${passengerFilterButton}
    Wait Until Page Contains Element    ${noCarsMatchFilterLabel}

Get number of cars with specified make
    [Documentation]    Returns number of cars in the list that has the specified make passed as 
    ...    an argument.
    [Tags]    car-selection
    [Arguments]    ${make}
    ${carsWithMakeElements}=    Get WebElements    //table[@id='carTable']//td[@class='mediumText' and text()='${make}']
    ${carCount}=    Get Length    ${carsWithMakeElements}
    RETURN    ${carCount}

Get number of cars with number of passengers
    [Documentation]    Returns number of cars in the list with the specified number of passengers.
    [Tags]    car-selection
    [Arguments]    ${numPassengers}
    ${carsWithNumPassengers}=    Get WebElements    //table[@id='carTable']//td[@class='mediumText' and text()='${numPassengers}']
    ${carCount}=    Get Length    ${carsWithNumPassengers}
    RETURN    ${carCount}


Get total number of cars in rental list
    [Documentation]    Returns the total number of cars in the list of available cars
    [Tags]    car-selection
    ${carElements}=    Get WebElements    ${carTableCarRow}
    ${carCount}=    Get Length    ${carElements}
    RETURN    ${carCount}

# Booking confirmation keywords
Page should display booking confirmation
    [Documentation]    Verifies that the booking confirmation page is displayed
    [Tags]    confirm-booking
    Wait Until Page Contains Element    ${confirmBookingHeader}
    ${bookingConfirmationText}=    Get Text    ${confirmBookingHeader}
    Should Match    ${bookingConfirmationText}    ${confirmBookingHeaderPattern}

User selects expiration date
    [Documentation]    Selects card expiration date. Takes the expiration date as an argument
    ...    in the format "YYYY-mm"
    [Tags]    confirm-booking
    [Arguments]    ${expirationDate}
    ${expirationDateDateTime}=    Convert Date    ${expirationDate}    date_format=%Y-%m    result_format=datetime
    Select From List By Label    ${monthSelectElement}    ${expirationDateDateTime.month}
    Select From List By Label    ${yearSelectElement}    ${expirationDateDateTime.year}
    ${expirationDateMonthValue}=    Get Value    ${monthSelectElement}
    Should Be Equal As Strings    ${expirationDateMonthValue}    ${expirationDateDateTime.month}
    ${expirationDateYearValue}=    Get Value    ${yearSelectElement}
    Should Be Equal As Strings    ${expirationDateYearValue}    ${expirationDateDateTime.year}

User enters card number
    [Documentation]    Enters card number. Takes card number as an argument.
    [Tags]    confirm-booking
    [Arguments]    ${cardNumber}
    Input Text    ${cardNumberInput}    ${cardNumber}
    ${cardNumberInputValue}=    Get Value    ${cardNumberInput}
    Should Be Equal As Strings    ${cardNumberInputValue}    ${cardNumber}

User enters card holder name
    [Documentation]    Enters card holder name. Takes card holder name as an argument.
    [Tags]    confirm-booking
    [Arguments]    ${name}
    Input Text    ${cardHolderInput}    ${name}
    ${cardHolderInputValue}=    Get Value    ${cardHolderInput}
    Should Be Equal As Strings    ${cardHolderInputValue}    ${name}

User enters cvc code
    [Documentation]    Enters cvc code. Takes cvc code as an argument.
    [Tags]    confirm-booking
    [Arguments]    ${cvc}
    Input Text    ${cvcInput}    ${cvc}
    ${cvcInputValue}=    Get Value    ${cvcInput}
    Should Be Equal As Strings    ${cvcInputValue}    ${cvc}

User enters valid confirmation information
    [Documentation]    Enters valid card and card holder information
    [Tags]    confirm-booking
    User enters card number    ${validCardNumber}
    User enters card holder name    ${nameOfCardHolder}
    User selects expiration date    ${cardExpirationDate}
    User enters cvc code    ${cvcCode}

User clicks confirm button
    [Documentation]    Clicks confirm button on booking confirmation page
    [Tags]    confirm-booking
    Click Button    ${confirmButton}

Card number input should display error
    [Documentation]    Verifies that the card number input displays an error
    [Tags]    confirm-booking
    ${validationMessage}=    Get Element Attribute    ${cardNumberInput}    validationMessage
    Should Match    ${validationMessage}    Please match the requested format*

Card holder name input should display error
    [Documentation]    Verifies that the card holder name input displays an error
    [Tags]    confirm-booking
    ${validationMessage}=    Get Element Attribute    ${cardHolderInput}    validationMessage
    Should Be Equal As Strings    ${validationMessage}    Please fill out this field.

Cvc input should display error
    [Documentation]    Verifies that the cvc code input displays an error
    [Tags]    confirm-booking
    ${validationMessage}=    Get Element Attribute    ${cvcInput}    validationMessage
    Should Be Equal As Strings    ${validationMessage}    Please fill out this field.

Page should display successful booking information
    [Documentation]    Verifies that the successful booking page is displaying
    [Tags]    successful-booking
    Page Should Contain    A ${bookedCarMake} ${bookedCarModel} is now ready for pickup

My booking page should display booked car
    [Documentation]    Verifies that "My page" displays the booked car
    [Tags]    my-page
    Go To    ${myPageUrl}
    Wait Until Page Contains Element    ${myPageMakeElement}
    ${myPageMakeText}=    Get Text    ${myPageMakeElement}
    Should Be Equal As Strings    ${bookedCarMake}    ${myPageMakeText}
    Wait Until Page Contains Element    ${myPageModelElement}
    ${mypageModelText}=    Get Text    ${myPageModelElement}
    Should Be Equal As Strings    ${bookedCarModel}    ${mypageModelText}

Cancel all bookings
    [Documentation]    Cancels all active bookings so that previous test runs don't interfere with
    ...    subsequent runs.
    [Tags]    suite-teardown    my-page
    Go To    ${mypageUrl}
    WHILE    $True
        ${cancelButtonCount}=    Get Element Count    //button[text()='Cancel booking']
        IF    ${cancelButtonCount} > 0
            ${cancelButton}=    Get WebElement    //button[text()='Cancel booking'][1]
            Click Button    ${cancelButton}
            Alert Should Be Present
            Go To    ${myPageUrl}
            Wait Until Page Contains Element   //h1[@id='historyText']
        ELSE
            BREAK
        END
    END

Logout user
    [Documentation]    Clicks the logout button if the user is signed
    [Tags]    logout    test-teardown
    ${logoutButtonCount}=    Get Element Count    ${logoutButtonElement}
    Run Keyword If    ${logoutButtonCount} > 0    Click Button    ${logoutButtonElement}
    Wait Until Page Contains Element    ${loginButtonElement}