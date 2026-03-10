import Foundation
import CompanyUI
import XCTest

class BaseAuthenticatedTest: XCTestCase {

  static var sharedApp = XCUIApplication()
  var app: XCUIApplication {
    BaseTest.sharedApp
  }
  var tabBar: XCUIElement {
    app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar]
  }

  func tap(at point: CGPoint) {
      let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
      let coordinate = normalized.withOffset(CGVector(dx: point.x, dy: point.y))
      coordinate.tap()
  }

  func happyPathLogIn() {

    let logInButton = app.buttons[CompanyUI.AccessibilityIdentifier.SplashScreen.logIn]
    XCTAssert(logInButton.waitForExistence(timeout: TestConstants.longTimeout))
    logInButton.tap()

    let key = app.keys["0"]
    let key1 = app.keys["1"]
    let key2 = app.keys["2"]
    let key3 = app.keys["3"]
    let key4 = app.keys["4"]
    let key5 = app.keys["5"]
    let key6 = app.keys["6"]
    let key7 = app.keys["7"]
    let key8 = app.keys["8"]
    let key9 = app.keys["9"]

    nap() // moves too quickly and enters 7 instead of 8...
    key8.tap()
    key.tap()
    key1.tap()
    key2.tap()
    key3.tap()
    key4.tap()
    key5.tap()
    key6.tap()
    key7.tap()
    key9.tap()

    let continueButton = app.buttons["Continue"]
    let nextButton = app.staticTexts["Next"]

    if continueButton.exists {
      continueButton.tap()
    } else {
      XCTAssert(nextButton.isHittable)
      nap()
      nextButton.tap()
    }

    let verifyNumber = app.staticTexts["Verify your number"]
    XCTAssert(verifyNumber.waitForExistence(timeout: TestConstants.timeout))
    key1.tap()
    key2.tap()
    key3.tap()
    key4.tap()
    key5.tap()

    let submitButton = app.buttons["Submit"]
    if submitButton.exists {
      XCTAssertTrue(submitButton.waitForExistence(timeout: TestConstants.timeout))
      submitButton.tap()
    }

    // MARK: Dismissing Places prompts for permissions if present.

    let placesAdDismissButton = app.staticTexts["Dismiss"]
    if placesAdDismissButton.isHittable {
      placesAdDismissButton.tap()
    }
  }

  func happyPathLogOut() {
    nap(timeout: TestConstants.midTimeout)
    let meTab = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["me"]
    if meTab.isHittable {
      meTab.tap()
      nap()
      app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()
    }

    let tableView = app.descendants(matching: .table).firstMatch
    guard let lastCell = tableView.cells.allElementsBoundByIndex.last else { return }
    let MAX_SCROLLS = 10
    var count = 0
    while lastCell.isHittable == false && count < MAX_SCROLLS {
      app.swipeUp()
      count += 1
    }
    // If there is only one label within the cell
    let logOut = lastCell.buttons["Log Out"]
    let logOutModal = app.staticTexts["Logout"]
    let redesignLogOut = app.tables.staticTexts["Log out"]
    if redesignLogOut.exists {
      redesignLogOut.tap()
      logOutModal.tap()
    } else if logOut.exists {
      logOut.tap()
      logOutModal.tap()
    }
    let apply = app.staticTexts["Apply for membership"]
    XCTAssertTrue(apply.waitForExistence(timeout: TestConstants.longTimeout))
  }
}
