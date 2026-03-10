import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class TestTravelPlan: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func testTravelPlan() {
    dismissInterrupters()
    nap()
    tappingMeIcon()

    let addTravel = app.collectionViews.buttons["Add Travel"]
    let editTravelPlan = app.collectionViews.staticTexts["Edit Travel"]
    let redesigntpButton = app.staticTexts["Delete travel plan"]
    let oldWorldButton = app.staticTexts["Delete Travel Plan"]

    if addTravel.exists {
      addTravel.tap()
    } else if editTravelPlan.exists {
      if redesigntpButton.exists {
        redesigntpButton.tap()
      }
      oldWorldButton.tap()
      nap()
      addTravel.tap()
      }
    let travelPlanViewOne = app.staticTexts["Travel Plans"]
    let tpViewOneText = app.staticTexts["Optimize your experience for meeting locals and others traveling to the same place."]
    let tpViewTwo = app.staticTexts["Have your profile stand out"]
    let tpViewTwoText = app.staticTexts["Other members also in the same place you’re going will see your profile differently from others."]
    let tpViewThree = app.staticTexts["Any upcoming travel?"]
    let creatTravelButton = app.buttons["Create a Travel Plan"]
    let nextButton = app.buttons["Next"]

    if travelPlanViewOne.exists && tpViewOneText.exists {
      nextButton.tap()
      XCTAssert(tpViewTwo.waitForExistence(timeout: TestConstants.timeout))
      XCTAssert(tpViewTwoText.exists)
      nextButton.tap()
      XCTAssert(tpViewThree.waitForExistence(timeout: TestConstants.timeout))
      creatTravelButton.tap()
    }

    // tapping into the search for Norway to complete the travel plan

    let whereAreYouGoingText = app.staticTexts["Where are you traveling to?"]
    XCTAssert(whereAreYouGoingText.waitForExistence(timeout: TestConstants.timeout))
    app.typeText("Norway")
    let emptySearch = app.tables["exampleSearches.Directory"].staticTexts["Hmmm… try another search"]
    nap(timeout: TestConstants.shortTimeout)
    if emptySearch.exists {
      app.buttons["Close"].tap()
      app.typeText("Norway")
    }
    nap()
    let tpSearchBar = app.tables[CompanyUI.AccessibilityIdentifier.Directory.exampleSearches]
    nap(timeout: TestConstants.midTimeout)
    let tpSearchExample = tpSearchBar.children(matching: .cell).element(boundBy: 0).staticTexts["Norway"]
    XCTAssert(tpSearchExample.waitForExistence(timeout: TestConstants.timeout))
    tpSearchExample.tap()
    let travelingToTitle = app.staticTexts["Traveling to Norway from"]
    XCTAssert(travelingToTitle.waitForExistence(timeout: TestConstants.timeout))
    let element1 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other)
    let element2 = element1.element.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let element3 = element2.element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
    let dateOne = element3.children(matching: .other).element(boundBy: 14)
    let dateTwo = element3.children(matching: .other).element(boundBy: 19)
    let dateThree = element3.children(matching: .other).element(boundBy: 20)

    if dateOne.isHittable {
      dateOne.tap()
    }
    if dateTwo.exists && dateTwo.isHittable {
        dateTwo.tap()
    } else if dateThree.isHittable {
      dateThree.tap()
    }

    app.buttons["Next"].tap()
    let travelPlanExpireTitle = app.staticTexts["Your Travel Plan will expire at the end of your trip."]

    XCTAssert(travelPlanExpireTitle.waitForExistence(timeout: TestConstants.timeout))
    app.staticTexts["Create Plan"].tap()
    nap()
    app.buttons["Close"].tap()

    // Edit Travel plan

    editTravelPlan.tap()
    let cancel = app.staticTexts["Cancel"]
    XCTAssert(cancel.waitForExistence(timeout: TestConstants.timeout))
    cancel.tap()
    editTravelPlan.tap()
    app.staticTexts["Edit travel dates"].tap()

    let dateFour = element3.children(matching: .other).element(boundBy: 13)
    let dateFive = element3.children(matching: .other).element(boundBy: 17)
    if dateFour.isHittable {
      dateFour.tap()
    }
    if dateFive.isHittable {
      dateFive.tap()
    } else if dateTwo.isHittable {
      dateTwo.tap()
    }
    app.staticTexts["Next"].tap()
    app.staticTexts["Update Plan"].tap()

    // Delete travel plan

    let createPlanButton = app.collectionViews.buttons["Add Travel"]
    editTravelPlan.tap()

    if redesigntpButton.exists {
      redesigntpButton.tap()
    } else if oldWorldButton.exists {
      oldWorldButton.tap()
    }
    XCTAssert(createPlanButton.waitForExistence(timeout: TestConstants.shortTimeout))
  }
}
