import XCTest
import enum CompanyUI.AccessibilityIdentifier

class FriendPass: TestActions2024 {

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testFriendPass() throws {
    dismissInterrupters()
    tappingMeIcon()
    nap()

    let tablesQuery = app.tables
    let refferalBackButton = app.navigationBars["Referral"].buttons["back"]
    let referralButton = app.buttons["friendPass.Profile"]
    nap()
    XCTAssert(referralButton.waitForExistence(timeout: TestConstants.timeout))
    referralButton.tap()
    nap()
    app.swipeUp(velocity: 800)
    let sendReminder = tablesQuery.cells.containing(
      .staticText,
      identifier: "DH"
    ).buttons[CompanyUI.AccessibilityIdentifier.HomeView.FriendPass.send].staticTexts["Send Reminder"]
    XCTAssert(sendReminder.waitForExistence(timeout: TestConstants.longTimeout))
    if sendReminder.isHittable {
      sendReminder.tap()
    }
    let okayButton = app.buttons["Okay"]
    okayButton.tap()
    app.swipeDown(velocity: 500)
    let searchTextField = tablesQuery.otherElements[CompanyUI.AccessibilityIdentifier.CommonButtons.search].children(matching: .textField).element
    XCTAssertTrue(searchTextField.waitForExistence(timeout: TestConstants.timeout))
    searchTextField.tap()
    app.typeText("Ap")
    let clearText = tablesQuery.buttons["Clear text"]
    let textClear = tablesQuery.buttons["Close"]
    if clearText.isHittable {
      clearText.tap()
    } else {
      textClear.tap()
    }
    let ignoreReferral = tablesQuery.cells.containing(.staticText, identifier: "GR").staticTexts["Ignore"]
    XCTAssertTrue(ignoreReferral.waitForExistence(timeout: TestConstants.shortTimeout))
    ignoreReferral.tap()
    let dismissReferral = app.scrollViews.otherElements.buttons["Dismiss"]
    let redesignDismiss = app.staticTexts["Dismiss"]

    if dismissReferral.isHittable {
      dismissReferral.tap()
    } else {
      redesignDismiss.tap()
    }
    let referralNavigationBar = app.navigationBars["Referral"]
    let referAFriendHistory = app.navigationBars["Refer a Friend"]
    let referalHistory = referralNavigationBar.buttons["referralsCommitteeButton"]
    if referAFriendHistory.isHittable {
      referAFriendHistory.buttons["History"].tap()
    } else {
      referalHistory.tap()
    }
    XCTAssertTrue(searchTextField.waitForExistence(timeout: TestConstants.timeout))
    searchTextField.tap()

    // Redesign buttons for tapping back

    let referralBackCaret = referralNavigationBar.children(matching: .button).element(boundBy: 0)
    let committeeBackButton = app.navigationBars["History"].buttons["back"]
    committeeBackButton.tap()
    referralBackCaret.tap()
  }
}
