
import XCTest
import enum CompanyUI.AccessibilityIdentifier

final class SettingsConsumables: Consumables {

  override var performLoginLogout: Bool {
   return false
  }
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  // This test can only be run on a physical device as apple sims do not have capablility(2023) to purchase.
  // also this test does take about 4 mins to run since it takes about a minute for apple payment to go through and
  // to display the prompt.

  func testPurchasingConsumablesSettingPage2024() throws {
    // gotta figure out how to reference TestActions2024 /// 
    nap()

    let settingButton = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].children(matching: .button).element(boundBy: 4)
    XCTAssert(settingButton.waitForExistence(timeout: TestConstants.timeout))
    settingButton.tap()
    app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()

    // Select to purchase 3 Direct requests from Settings view

    selectDirectRequestsToBuy()
    appleRedesignPurchasePrompt()
    checkIfPasswordNeeded()

    // Purchase 1 travel Plan from settings view

    selectTravelPlansToBuy()
    appleRedesignPurchasePrompt()
    checkIfPasswordNeeded()

    // Purchase Skip the wait

    selectSTWToPurchase()
    appleRedesignPurchasePrompt()
    checkIfPasswordNeeded()
  }
}
