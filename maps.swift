import Foundation
import enum CompanyUI.AccessibilityIdentifier
import CoreLocation
import XCTest

class TestMaps: MapsHelpers {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testMapsTab() throws {
    setLocationOnMaps()

    let membersNearbyText = app.staticTexts["Members nearby"]
    XCTAssert(membersNearbyText.waitForExistence(timeout: TestConstants.timeout))
    tapMapsToggle()
    let editTravelPlan = app.collectionViews.staticTexts["Norway"]
    let addTravel = app.collectionViews.buttons["Add Travel"]
    let redesigntpButton = app.staticTexts["Delete travel plan"]
    let dismiss = app.staticTexts["Dismiss"]
    let searchText = app.staticTexts["Where are you traveling to?"]
    let travelBack = app.navigationBars["Share a Travel Plan"].children(matching: .button).element
    if addTravel.isHittable {
      addTravel.tap()
    } else if editTravelPlan.isHittable {
      editTravelPlan.tap()
      redesigntpButton.tap()
    }
    nap()

    if dismiss.isHittable {
      dismiss.tap()
    } else if searchText.exists {
      travelBack.tap()
    }
    let cityDropDown = app.buttons["City"]
    cityDropDown.tap()
    app.tables.staticTexts["Los Angeles, CA"].tap()

    let queryCollection = app.collectionViews
    let laCityResults = queryCollection.staticTexts["Members in Los Angeles, CA"]
    XCTAssert(laCityResults.waitForExistence(timeout: TestConstants.timeout))

    let cityConnections = app.collectionViews.staticTexts["My connections in Los Angeles"]
    let myConnectionsTitle = app.staticTexts["My connections"]
    if cityConnections.exists {
      cityConnections.tap()
      XCTAssert(myConnectionsTitle.exists)
      app.buttons["LeftChevron"].tap()
    }

    let downChevronButton = app.buttons["DownChevron"]
    downChevronButton.tap()
    let cityCard = queryCollection.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
    XCTAssert(cityCard.waitForExistence(timeout: TestConstants.timeout))
    cityCard.tap()
    downChevronButton.tap()
    tapNearbyToggle()
    tapIntoNeighborhood()

    let yourConnectionText = app.tables.cells.containing(.staticText, identifier: "Los Angeles, CA").staticTexts["Your connection"]
    let sheetGrab = app.buttons["Sheet Grabber"]
    XCTAssert(sheetGrab.waitForExistence(timeout: TestConstants.timeout))
    sheetGrab.tap()
    let connectionsNearby = app.collectionViews.staticTexts["My connections in Downtown"]
    if connectionsNearby.exists {
      connectionsNearby.tap()
      XCTAssert(app.staticTexts["My connections"].waitForExistence(timeout: TestConstants.timeout))
      app.buttons["LeftChevron"].tap()
    }
    downChevronButton.tap()
    removeNeighborhoodFilterPill()

    cityDropDown.tap()
    app.navigationBars["Explore a city"].buttons["Close"].tap()
    navigateBackHome()
    XCTAssert(membersNearbyText.waitForExistence(timeout: TestConstants.timeout))
  }

  func testLikeAndDrInMaps() throws {
    setLocationOnMaps()
    let sheetGrab = app.buttons["Sheet Grabber"]
    XCTAssert(sheetGrab.waitForExistence(timeout: TestConstants.timeout))
    sheetGrab.tap()
    checkLikeAndDrButtons()
    sheetGrab.tap()
  }
}
