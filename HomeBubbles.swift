import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class TestBubbles: TestActions2024 {

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  func testTabBarItemsTapped() throws {
    dismissInterrupters()
    amIinFullStack()
    nap()
    let bubbles = app.otherElements[CompanyUI.AccessibilityIdentifier.HomeView.bubbles].children(matching: .other).element(boundBy: 1)
    if bubbles.exists {
      bubbles.tap()
    }
  }

  func testSettingsActivity() throws {
    dismissInterrupters()
    tappingMeIcon()
    app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()

    let activityRow = app.tables.staticTexts["Activity"]
    XCTAssert(activityRow.exists)
    activityRow.tap()
    let tablesQuery = app.tables
    // swiftlint:disable:next line_length
    let activityNote = tablesQuery.staticTexts["If enabled, your activity will be visible to your connections and other community members who may share your interests."]
    let activityNotice = tablesQuery.staticTexts["Notice"]
    XCTAssert(activityNote.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(activityNote.waitForExistence(timeout: TestConstants.timeout))
    let activityToggle = app.switches["Activity"]
    activityToggle.tap()
    let saveButton = app.buttons["Save"].staticTexts["Save"]
    XCTAssert(saveButton.isHittable)
    saveButton.tap()
    let activityBack = app.navigationBars["Activities"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]
    let activityOff = app.tables.staticTexts["Off"]
    XCTAssert(activityOff.waitForExistence(timeout: TestConstants.timeout))
    activityOff.tap()
    activityToggle.tap()
    activityBack.tap()
    let unsaveChangeModal = app.staticTexts["Unsaved changes"]
    XCTAssert(unsaveChangeModal.isHittable)
    app.buttons["Dismiss"].staticTexts["Dismiss"].tap()
    let activityOn = app.tables.staticTexts["On"]
    saveButton.tap()
    XCTAssert(activityOn.waitForExistence(timeout: TestConstants.timeout))
  }
}
