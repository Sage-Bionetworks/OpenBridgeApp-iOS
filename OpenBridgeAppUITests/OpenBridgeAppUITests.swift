// Created 3/28/23
// swift-tools-version:5.0

import XCTest

final class OpenBridgeAppUITests: XCTestCase {
    
    let timeoutLaunch: TimeInterval = 5
    let timeoutServiceCall: TimeInterval = 5
    let timeoutScreenChange: TimeInterval = 2

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAll() throws {
        try loginStartUp()
        try runSurvey()
        try runFlanker()
    }
    
    func loginStartUp() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        // Add an interruption handler to accept all system permissions.
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert -> Bool in
            let okButton = alert.buttons["OK"]
            let allowButton = alert.buttons["Allow"]
            if okButton.exists {
                okButton.tap()
            }
            else if allowButton.exists {
                allowButton.tap()
            }
            return true
        }
        
        // Enter Study ID
        let logoImage = app.images["AppLogo"]
        XCTAssertTrue(logoImage.waitForExistence(timeout: timeoutLaunch))
        let studyIdNextButton = app.buttons["Next"]
        XCTAssertTrue(studyIdNextButton.waitForExistence(timeout: timeoutLaunch))
        let studyIdTextField = app.textFields["login"]
        studyIdTextField.tap()
        studyIdTextField.typeText("not-a-real-study")
        studyIdNextButton.tap()
        
        // Enter Participant ID
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: timeoutServiceCall))
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText("not-a-real-id")
        loginButton.tap()
        
        // Welcome screen
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: timeoutServiceCall))
        continueButton.tap()
        
        // Privacy Notice
        let weWillButton = app.buttons["We will"]
        let weWontButton = app.buttons["We won’t"]
        let youCanButton = app.buttons["You can"]
        XCTAssertTrue(weWillButton
            .waitForExistence(timeout: timeoutScreenChange))
        
        //  - We will
        XCTAssertTrue(weWontButton.exists)
        XCTAssertTrue(youCanButton.exists)
        XCTAssertTrue(app.findLabel(with: "Collect the data you give us when you register and when you use the App. This may include sensitive data like your health information.").exists)
        XCTAssertTrue(app.findLabel(with: "Collect standard usage data or log information.").exists)
        XCTAssertTrue(app.findLabel(with: "Protect your privacy and store the data in a secure cloud server in the US.").exists)
        XCTAssertTrue(app.findLabel(with: "Share de-identified data with other researchers in the US and abroad.").exists)
        XCTAssertTrue(app.findLabel(with: "Retain your data as long as we need it unless you request deletion.").exists)
        XCTAssertTrue(app.findLabel(with: "Delete your data when you ask us to.").exists)
        XCTAssertTrue(app.findLabel(with: "Tell you if we make changes to our privacy policy.").exists)
        let nextButton = app.buttons["Next"]
        nextButton.tap()
        
        //  - We won't
        XCTAssertTrue(app.findLabel(with: "Access your contacts, photos or other personal information stored on your phone.")
            .waitForExistence(timeout: timeoutScreenChange))
        XCTAssertTrue(app.findLabel(with: "Sell or rent your data.").exists)
        XCTAssertTrue(app.findLabel(with: "Track your browsing activities on other Apps.").exists)
        XCTAssertTrue(app.findLabel(with: "Use your data for advertising.").exists)
        nextButton.tap()
        
        //  - You can
        XCTAssertTrue(app.findLabel(with: "Ask to access, download or delete your data.")
            .waitForExistence(timeout: timeoutScreenChange))
        XCTAssertTrue(app.findLabel(with: "Decide if we can collect passive data from your device, like how much time you use your device each day.").exists)
        XCTAssertTrue(app.findLabel(with: "Decide what optional information to give us. For example, giving us your zipcode will tell us about the weather or air quality where you are.").exists)
        XCTAssertTrue(app.findLabel(with: "Allow us to turn on your phone camera or microphone when it is necessary to use the App.").exists)
        XCTAssertTrue(app.findLabel(with: "Choose to share your data for future research.").exists)
        nextButton.tap()
        
        // Note: This test won't work on a fresh install where the participant hasn't
        // accepted the notifications or motion activity. Can't get the alert to
        // recognize consistently. - syoung 03/29/2022
        
        // Notifications
        XCTAssertTrue(app.findLabel(with: "Notifications")
            .waitForExistence(timeout: timeoutScreenChange))
        nextButton.tap()
        // This line is used to trigger that "yes, we are interrupted (by a notification)
        // If the permission was previously accepted (and won't display again b/c we've
        // already given permission), then tapping on the "app" won't do anything.
        app.tap()
        
        // Wait for the app to show the current screen
        XCTAssertTrue(app.findLabel(with: "Current activities")
            .waitForExistence(timeout: timeoutScreenChange))
        
        app.buttons["Study Info"].tap()
        XCTAssertTrue(app.findLabel(with: "Mobile Integration Tests Study")
            .waitForExistence(timeout: timeoutScreenChange))
        XCTAssertTrue(app.findLabel(with: "Notareal Investigator").exists)
        XCTAssertTrue(app.findLabel(with: "Principal Investigator").exists)
        
        app.buttons["Contact & Support"].tap()
        XCTAssertTrue(app.findLabel(with: "General Support")
            .waitForExistence(timeout: timeoutScreenChange))
        XCTAssertTrue(app.findLabel(with: "For general questions about the study or to withdraw from the study, please contact:").exists)
        XCTAssertTrue(app.findLabel(with: "Notareal Person").exists)
        XCTAssertTrue(app.findLabel(with: "Study Support").exists)
        XCTAssertTrue(app.findLabel(with: "(206) 555-1234").exists)
        XCTAssertTrue(app.findLabel(with: "not_real_person@example.org").exists)
        XCTAssertTrue(app.findLabel(with: "To withdraw from this study, you’ll need the following info:").exists)
        XCTAssertTrue(app.findLabel(with: "Study ID: bfwfhn").exists)
        XCTAssertTrue(app.findLabel(with: "Participant ID: ios001").exists)
        XCTAssertTrue(app.findLabel(with: "Your Participant Rights").exists)
        XCTAssertTrue(app.findLabel(with: "For questions about your rights as a research participant, please contact:").exists)
        XCTAssertTrue(app.findLabel(with: "Not a real IRB").exists)
        XCTAssertTrue(app.findLabel(with: "IRB/Ethics Board of Record").exists)
        XCTAssertTrue(app.findLabel(with: "(206) 555-1212").exists)
        XCTAssertTrue(app.findLabel(with: "not_real_irb@example.org").exists)
        
        app.buttons["Account"].tap()
        XCTAssertTrue(app.findLabel(with: "To withdraw from this study, please contact your Study Contact from the Study Info page.")
            .waitForExistence(timeout: timeoutScreenChange))
        
        app.buttons["Home"].tap()
        XCTAssertTrue(app.findLabel(with: "Current activities")
            .waitForExistence(timeout: timeoutScreenChange))
    }
    
    func runSurvey() throws {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let syoungTestSurveyaButton = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Current activities")/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "syoung-test-surveyA").element(boundBy: 0)/*[[".children(matching: .button).matching(identifier: \"Shannon's Test Survey\").element(boundBy: 0)",".children(matching: .button).matching(identifier: \"syoung-test-surveyA\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        syoungTestSurveyaButton.tap()
        XCTAssertTrue(app.findLabel(with: "Example Survey A")
            .waitForExistence(timeout: timeoutScreenChange))
        app.buttons["Start"].tap()
        
        XCTAssertTrue(app.findLabel(with: "Choose which question to answer")
            .waitForExistence(timeout: timeoutScreenChange))
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.switches["Birth year"].tap()
        
        let nextButton = elementsQuery.buttons["Next"]
        nextButton.tap()
        
        XCTAssertTrue(app.findLabel(with: "Enter a birth year")
            .waitForExistence(timeout: timeoutScreenChange))
        let birthYeatTextField = elementsQuery.textFields["YYYY"]
        birthYeatTextField.tap()
        birthYeatTextField.typeText("1999")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        nextButton.tap()
        
        XCTAssertTrue(app.findLabel(with: "Are you happy with your choice?")
            .waitForExistence(timeout: timeoutScreenChange))
        elementsQuery.switches["Yes"].tap()
        nextButton.tap()
        
        XCTAssertTrue(app.findLabel(with: "What are you having for dinner next Tuesday after the soccer game?")
            .waitForExistence(timeout: timeoutScreenChange))
        elementsQuery.switches["Sushi"].tap()
        nextButton.tap()

        XCTAssertTrue(app.findLabel(with: "What are your favorite colors?")
            .waitForExistence(timeout: timeoutScreenChange))
        elementsQuery.switches["Blue"].tap()
        elementsQuery.switches["Red"].tap()
        elementsQuery.buttons["Submit"].tap()
        
        XCTAssertTrue(app.findLabel(with: "You're done!")
            .waitForExistence(timeout: timeoutScreenChange))
        app.buttons["Exit"].tap()
        
        XCTAssertTrue(app.findLabel(with: "Current activities")
            .waitForExistence(timeout: timeoutScreenChange))
    }
    
    func runFlanker() throws {
        let app = XCUIApplication()
        let flankerButton = app.scrollViews.otherElements.containing(.staticText, identifier:"Current activities")/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "flanker").element(boundBy: 0)/*[[".children(matching: .button).matching(identifier: \"Arrow Matching\").element(boundBy: 0)",".children(matching: .button).matching(identifier: \"flanker\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        flankerButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["exit_black"]/*[[".buttons[\"exit black\"]",".buttons[\"exit_black\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.findLabel(with: "Current activities")
            .waitForExistence(timeout: timeoutScreenChange))
                
    }
}

extension XCUIApplication {
    func findLabel(with text: String) -> XCUIElement {
        let predicate = NSPredicate(format: "label LIKE %@", text)
        return staticTexts.element(matching: predicate)
    }
}
