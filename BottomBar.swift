import XCTest
import enum CompanyUI.AccessibilityIdentifier

class TestTabBar: TestActions2024 {

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  func testTabBarItemsTapped() throws {
    dismissInterrupters()
    amIinFullStack()
    nap()

    let window = app.windows.children(matching: .other).element.children(matching: .other).element
    let child = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let element = child.element.children(matching: .other).element.children(matching: .other).element
    let rayaHeaderImage = element.children(matching: .other).element.children(matching: .other).element
    if thisHeaderImage.exists {
      XCTAssert(rayaHeaderImage.waitForExistence(timeout: TestConstants.timeout))
    }
    XCTAssertTrue(tabBar.buttons["home"].isHittable)
    XCTAssertTrue(tabBar.waitForExistence(timeout: TestConstants.timeout))

    // MARK: Taps map Tab, enables it(if present), and checks page title

    tabBar.buttons["maps"].tap()
    checkForMapsToggledOff()

    // MARK: Taps Directory tab and checks for title

    let directoryPageTitle = app.staticTexts["Directory"]
    let directoryPlusPageTitle = app.staticTexts["Directory+"]
    nap(timeout: TestConstants.shortTimeout)
     tabBar.buttons["directory"].tap()
    if directoryPageTitle.exists {
      directoryPageTitle.tap()
    } else {
      directoryPlusPageTitle.tap()
    }

    // MARK: Taps Messages Tab and checks for Message title

    let messagePageTitle = app.staticTexts["Messages"]
    tabBar.buttons["connections"].tap()
    XCTAssertTrue(messagePageTitle.waitForExistence(timeout: TestConstants.timeout))

    // MARK: Taps Me view and checks for existence of cogwheel
    let mePageView = app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel]
    let meButton = app.tabBars["tabBar.TabBar"].buttons["connections"]
    let ogMeButton = tabBar.buttons["me"]
    ogMeButton.tap()

    XCTAssertTrue(mePageView.waitForExistence(timeout: TestConstants.timeout))

  }
}
