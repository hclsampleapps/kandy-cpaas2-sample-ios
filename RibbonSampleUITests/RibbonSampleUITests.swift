import XCTest

@testable import RibbonSample

class RibbonSampleUITests: XCTestCase {
  var app:XCUIApplication!
    
  let clientID = "PUB-project.name"
  let email = "user@domain.com"
  let password = "Test@123"
  let baseUrl = "baseurl.domain.com"
  let callee = "janedow@somedomain.com"
    
  let senderNo = "+1223334444"
  let destinationNo = "+1223334444"
  let chatID = "janedow@somedomain.com"

  var txtclient:XCUIElement!
  var txtemail:XCUIElement!
  var txtpass:XCUIElement!
  var txtbase:XCUIElement!
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.vbx
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app = XCUIApplication()
    app.launch()
    txtclient = app.textFields["clientid"]
    txtemail = app.textFields["email"]
    txtpass = app.secureTextFields["password"]
    txtbase = app.textFields["baseurl"]
  }
  func testLoginWithValidCredential() {
    txtclient.tap()
    txtclient.typeText(clientID)
    txtemail.tap()
    txtemail.typeText(email)
    txtpass.tap()
    txtpass.typeText(password)
    txtbase.tap()
    txtbase.typeText(baseUrl)
    txtbase.typeText("\n")
    if app.buttons["login"].exists {
      app.buttons["login"].tap()
      sleep(10)
    }
    XCTAssertTrue(app.collectionViews.cells.element.exists)
  }
  func testVideoCall(){
    var isDashboardScreenAppeared = false
    txtclient.tap()
    txtclient.typeText(clientID)
    txtemail.tap()
    txtemail.typeText(email)
    txtpass.tap()
    txtpass.typeText(password)
    txtbase.tap()
    txtbase.typeText(baseUrl)
    txtbase.typeText("\n")
    if app.buttons["login"].exists {
      app.buttons["login"].tap()
      isDashboardScreenAppeared = app.collectionViews.cells.element.waitForExistence(timeout: 10)
    }
    if isDashboardScreenAppeared {
      app.collectionViews.cells.element(boundBy:2).tap()
      sleep(1)
      app.buttons["video"].tap()
      let txtcallee = app.textFields["txtCallee"]
      txtcallee.tap()
      txtcallee.typeText(callee)
      txtcallee.typeText("\n")
      app.buttons["btnCall"].tap()
      sleep(5)
      XCTAssertTrue(app.buttons["endbtn"].exists)
    }
  }
  func testVAudioCall(){
    var isDashboardScreenAppeared = false
    txtclient.tap()
    txtclient.typeText(clientID)
    txtemail.tap()
    txtemail.typeText(email)
    txtpass.tap()
    txtpass.typeText(password)
    txtbase.tap()
    txtbase.typeText(baseUrl)
    txtbase.typeText("\n")
    if app.buttons["login"].exists {
      app.buttons["login"].tap()
      isDashboardScreenAppeared = app.collectionViews.cells.element.waitForExistence(timeout: 10)
    }
    if isDashboardScreenAppeared {
      app.collectionViews.cells.element(boundBy:2).tap()
      sleep(1)
      app.buttons["audio"].tap()
      let txtcallee = app.textFields["txtCallee"]
      txtcallee.tap()
      txtcallee.typeText(callee)
      txtcallee.typeText("\n")
      app.buttons["btnCall"].tap()
      sleep(5)
      XCTAssertTrue(app.buttons["endbtn"].exists)
    }
  }
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }


    func testInValidEmail() {
        txtclient.tap()
        txtclient.typeText(clientID)
        txtemail.tap()
        txtemail.typeText("invalidEmailAddress")
        txtemail.typeText("\n")
        if app.buttons["login"].exists {
            app.buttons["login"].tap()
            sleep(1)
        }
        XCTAssertTrue(app.alerts.element.staticTexts["Enter valid EmailId"].exists)
    }

    func testLoginWithInvalidCredential() {
        txtclient.tap()
        txtclient.typeText(clientID)
        txtemail.tap()
        txtemail.typeText(email)
        txtpass.tap()
        txtpass.typeText("9876")
        txtbase.tap()
        txtbase.typeText(baseUrl)
        txtbase.typeText("\n")
        if app.buttons["login"].exists {
            app.buttons["login"].tap()
            sleep(5)
        }
        XCTAssertTrue(app.alerts.element.staticTexts["No data found."].exists)
    }
        
    func testSendChat() {
        var isDashboardScreenAppeared = false
        txtclient.tap()
        txtclient.typeText(clientID)
        txtemail.tap()
        txtemail.typeText(email)
        txtpass.tap()
        txtpass.typeText(password)
        txtbase.tap()
        txtbase.typeText(baseUrl)
        txtbase.typeText("\n")
        if app.buttons["login"].exists {
            app.buttons["login"].tap()
            isDashboardScreenAppeared =  app.collectionViews.cells.element.waitForExistence(timeout: 10)
        }
        
        if isDashboardScreenAppeared {
            app.collectionViews.cells.element(boundBy:1).tap()
            sleep(1)
            let txtDestination = app.textFields["destination"]
            let txtchat = app.textViews["chattext"]
            txtDestination.tap()
            txtDestination.typeText(chatID)
            txtchat.tap()
            sleep(1)
            txtchat.typeText("Hello! This is test chat message. Don't reply.")
            app.buttons["btnsendchat"].tap()
            sleep(2)
            XCTAssertFalse(app.alerts.element.staticTexts["Failed to sent. Try again later."].exists)
        } else {
            XCTAssertFalse(app.buttons["login"].exists, "App still in login screen.")
        }
        
    }
    
    func testSendSMS() {
        var isDashboardScreenAppeared = false
        txtclient.tap()
        txtclient.typeText(clientID)
        txtemail.tap()
        txtemail.typeText(email)
        txtpass.tap()
        txtpass.typeText(password)
        txtbase.tap()
        txtbase.typeText(baseUrl)
        txtbase.typeText("\n")
        if app.buttons["login"].exists {
            app.buttons["login"].tap()
            isDashboardScreenAppeared =  app.collectionViews.cells.element.waitForExistence(timeout: 10)
        }
        
        if isDashboardScreenAppeared {
            app.collectionViews.cells.element(boundBy:0).tap()
            sleep(1)
            let txtSender = app.textFields["sender"]
            let txtDestination = app.textFields["destination"]
            let txtsms = app.textViews["smstext"]
            txtSender.tap()
            txtSender.typeText(senderNo)
            txtDestination.tap()
            txtDestination.typeText(destinationNo)
            txtsms.tap()
            sleep(1)
            txtsms.typeText("Hello! This is test SMS. Don't reply.")
            app.buttons["btnsendsms"].tap()
            sleep(2)
            XCTAssertFalse(app.alerts.element.staticTexts["Failed to sent. Try again later."].exists)
        } else {
            XCTAssertFalse(app.buttons["login"].exists, "App still in login screen.")
        }
        
    }
    

}
