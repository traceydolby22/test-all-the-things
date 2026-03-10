import Foundation
import CompanyUI
import XCTest

class StackButtons2024: StackSwipingActions {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }
  func testStackButtons() throws {
    dismissInterrupters()
    tappingIntoStack()
    let connectionTitle = app.staticTexts[CompanyUI.AccessibilityIdentifier.Connections.title]
    let connectionMessage = app.textViews.staticTexts["Send a message..."]
    if connectionTitle.isHittable || app.images[CompanyUI.AccessibilityIdentifier.Connections.profileCard].exists {
      connectionMessage.tap()
      let hKey = app.keys["H"]
      let iKey = app.keys["i"]
      hKey.tap()
      iKey.tap()
      app.buttons["SendEnabled"].tap()
    }

    let elementsQuery = app.scrollViews.otherElements
    let dislike = elementsQuery.buttons["DislikeButton"]
    nap()
    dislike.tap()
    let rewind = elementsQuery.buttons["BackButton"]
    rewind.tap()
    let dr = elementsQuery.buttons["SmallDRButton"]
    dr.tap()
    let sendDrButton = app.staticTexts["Send Direct Request"]
    XCTAssert(sendDrButton.waitForExistence(timeout: TestConstants.timeout))
    sendDrButton.tap()
    nap()
    checkForConnectedView()
    amIinFullStack()
  }

  func testSwipingThroughStack() {
    dismissInterrupters()
    tappingIntoStack()
    while !eosCarouselSkipTheWait.exists {
      NSLog("Skip the wait", false)
      swipingThroughStack()
      nap(timeout: TestConstants.shortestTimeout)
    }

    if eosCarouselSkipTheWait.isHittable && noSkipCopy.exists {
      eosCarouselSkipTheWait.tap()
      nap(timeout: TestConstants.midTimeout)
      app.staticTexts["Dismiss"].tap()
      amIinFullStack()
    }
    amIinFullStack()
  }
}
