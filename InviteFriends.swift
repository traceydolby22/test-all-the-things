import XCTest
import enum CompanyUI.AccessibilityIdentifier

class InviteFriends: TestActions2024 {

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testFriendPass() throws {
    dismissInterrupters()
    tappingMeIcon()
    nap()

    let tablesQuery = app.tables
    let friendsBackButton = app.navigationBars["Friends"].buttons["back"]
    let friendsButton = app.buttons["friendPass.Profile"]
    nap()
    XCTAssert(friendsButton.waitForExistence(timeout: TestConstants.timeout))
    friendsButton.tap()
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
    let ignoreFriend = tablesQuery.cells.containing(.staticText, identifier: "GR").staticTexts["Ignore"]
    XCTAssertTrue(ignoreFriend.waitForExistence(timeout: TestConstants.shortTimeout))
    ignoreFriend.tap()
    let dismissFriend = app.scrollViews.otherElements.buttons["Dismiss"]
    let redesignDismiss = app.staticTexts["Dismiss"]

    if dismissFriend.isHittable {
      dismissFriend.tap()
    } else {
      redesignDismiss.tap()
    }
    let friendNavigationBar = app.navigationBars["Friend"]
    let addAFriendHistory = app.navigationBars["Add a Friend"]
    let referalHistory = referralNavigationBar.buttons["referralsHistoryButton"]
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
