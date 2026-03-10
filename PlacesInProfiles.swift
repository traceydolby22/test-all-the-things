import enum CompanyUI.AccessibilityIdentifier
import XCTest

final class TestPlacesInProfiles: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testPlacesMyProfile() throws {
    dismissInterrupters()
    nap()
    let meTab = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["me"]
    XCTAssert(meTab.waitForExistence(timeout: TestConstants.timeout))
    meTab.tap()
    // scrolling to the places view on Profile
    app.swipeUp(velocity: 900)
    app.swipeUp(velocity: 500)

    // tapping Places Ad

    let collectionViewsQuery = app.collectionViews
    let placesTitle = collectionViewsQuery.staticTexts["Saved Places"]
    let placesAddText = collectionViewsQuery.tables.staticTexts["Add more places to showcase your unique taste."]
    let downloadButton = collectionViewsQuery.tables.cells.containing(.button, identifier: "Download Places").children(matching: .other).element(boundBy: 2)
    XCTAssert(placesTitle.exists && placesAddText.isHittable && downloadButton.isHittable)

    let placesAd = collectionViewsQuery.cells.otherElements.containing(.image, identifier: "PlacesInlineAdBackground").children(matching: .other).element

    if placesAd.exists {
      let acceptInviteButton = collectionViewsQuery.buttons["Accept Invite"]
      acceptInviteButton.tap()
      let placesModalText = app.staticTexts["Enjoy exclusive access to Places"]
      let removePlacesAd = app.staticTexts["Remove from profile"]
      let downloadPlacesButton = app.staticTexts["Download Places"]
      XCTAssert(placesModalText.exists && removePlacesAd.exists && downloadPlacesButton.exists)
      app.staticTexts["Dismiss"].tap()
      XCTFail("Places Ad is showing when it shouldn't be")
      return
    }
  }
}
