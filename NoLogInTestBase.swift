import Foundation
import CompanyUI
import XCTest

 class NoLogInTestsBase: XCTestCase {

  static var sharedApp = XCUIApplication()
  var app: XCUIApplication {
    BaseTest.sharedApp
  }

   var fullLogout: Bool {
     return true
   }

  var tabBar: XCUIElement {
    app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar]
  }

  override func setUp() {
    super.setUp()
    app.launchArguments.append("-configureForUITests")
    app.launch()
    if fullLogout {
      checkLoggedOut()
    }
    continueAfterFailure = false
}

  override func tearDown() {

      if let failureCount = testRun?.failureCount, failureCount > 0 {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot)
        add(attach)
      nap()
    }
      BaseTest.sharedApp.terminate()
      Springboard.deleteApp()
      super.tearDown()
  }

  func relaunchApp() {
    BaseTest.sharedApp.terminate()
    BaseTest.sharedApp.launch()
  }

  func killApp() {
    sleep(1)
    BaseTest.sharedApp.terminate()
  }

   func checkLoggedOut() {
     let applyButton = app.staticTexts["Apply for membership"]
     if !applyButton.isHittable {
       happyPathLogOut()
       Springboard.deleteApp()
       app.launch()
     }
   }

   func happyPathLogOut() {
     nap(timeout: TestConstants.midTimeout)
     app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["me"].tap()

     nap() // takes a second for button to be present
     app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()
     let tableView = app.descendants(matching: .table).firstMatch
     guard let lastCell = tableView.cells.allElementsBoundByIndex.last else { return }
     let MAX_SCROLLS = 10
     var count = 0
     while lastCell.isHittable == false && count < MAX_SCROLLS {
       app.swipeUp()
       count += 1
     }
     // If there is only one label within the cell

     let logOutRedesign = app.tables.staticTexts["Log out"]
     let logOutPrompt = app.staticTexts["Logout"]
     let logOutOw = lastCell.buttons["Log Out"]
     let logOutPromptOw = app.buttons["Logout"]
     if logOutOw.exists {
       logOutOw.tap()
       logOutPromptOw.tap()
     } else if logOutRedesign.exists {
       logOutRedesign.tap()
       logOutPrompt.tap()
     }

     let apply = app.staticTexts["Apply for membership"]
     XCTAssertTrue(apply.waitForExistence(timeout: TestConstants.fifteenTimeout))
   }

  func startApp() {
    BaseTest.sharedApp.launch()
  }
  func typeCharArray(str: String) {
    var newStr = ""
    if str.count < 6 {
      newStr = "0\(str)"
    } else {
      newStr = str
    }
    for element in newStr {
      BaseTest.sharedApp.keys[String(element)].tap()
    }
  }

  func waitForElementToAppear(format: String, element: AnyObject, time: Double) {
    let exists = NSPredicate(format: format)
    expectation(for: exists, evaluatedWith: element, handler: nil)
    waitForExpectations(timeout: time, handler: nil)
  }
}
