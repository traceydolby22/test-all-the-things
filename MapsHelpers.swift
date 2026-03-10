import CoreLocation
import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class MapsHelpers: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  func setLocationOnMaps() {
    dismissInterrupters()
    nap()
    // A device location that wraps a CLLocation object from Core Location.
    let losAngelesLocation = XCUILocation(location: CLLocation(
      latitude: 34.0499998,
      longitude: -118.249999))
    // Sets the device's proxy location.
    XCUIDevice.shared.location = losAngelesLocation
    tabBar.buttons["maps"].tap()
  }

  func checkLikeAndDrButtons() {

    let mapsProfileCardChild = app.collectionViews[CompanyUI.AccessibilityIdentifier.Maps.profileCard].children(matching: .cell).element(boundBy: 0)
    let mapsPCElement = mapsProfileCardChild.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView)
    let mapsPCChild1 = mapsPCElement.element(boundBy: 1).children(matching: .cell).element(boundBy: 0).children(matching: .other)
    let mapsPCChild2 = mapsPCChild1.element.children(matching: .other).element.children(matching: .other)
    let cityCarouselCard = mapsPCChild2.element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
    let mapsPCLongPress = mapsPCElement.element(boundBy: 1)
    let xButtonChild = app.windows.children(matching: .other).element.children(matching: .other)
    let xButtonElement = xButtonChild.element.children(matching: .other).element.children(matching: .other)
    let xButton = xButtonElement.element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    let cityCarouselElement = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
    let buttonChild = cityCarouselElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    let closeCCButton = buttonChild.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    let element = app.windows.children(matching: .other).element(boundBy: 0).children(matching: .other).element

    let mapsLikeButton = app.buttons["LikeButton"]
    let mapsCheckMarkButton = app.buttons["Checkmark"]
    let mapsLikedProfileText = app.staticTexts["You liked their profile"]
    let mapsDrButton = app.buttons["LargeDRButton"]
    let mapsDRFillButton = app.buttons["DirectRequestFill"]
    let mapsSendDr = app.staticTexts["Send Direct Request"]
    let mapsDrProfileText = app.staticTexts["Direct Request Sent"]
    let mapsLikeAndDrProfileText = app.staticTexts["Liked and Direct Requested"]
    let travelChrome = app.staticTexts["Traveling"]
    let yourConnectionText = app.collectionViews["profileCard.Maps"].collectionViews.staticTexts["Your connection"]
    let messageBackChild = app.toolbars["Toolbar"].children(matching: .other).element.children(matching: .other)
    let messageBackButton = messageBackChild.element.children(matching: .button).element(boundBy: 0)
    let messageButton = app.buttons["MessageButton"]

    if yourConnectionText.isHittable {
      cityCarouselCard.tap()
      checkMessageIconPresent()
    }

    mapsPCLongPress.children(matching: .other).element.swipeLeft(velocity: 200)
    cityCarouselCard.tap()
    nap()
    if messageButton.exists {
      checkMessageIconPresent()
    } else if mapsLikedProfileText.exists {
      XCTAssert(!mapsLikeButton.isEnabled)
      mapsDrButton.tap()
      mapsSendDr.tap()
      XCTAssert(mapsLikeAndDrProfileText.waitForExistence(timeout: TestConstants.timeout))
      XCTAssert(!mapsDrButton.isEnabled)
      checkForConnectedView()
    } else if mapsLikeAndDrProfileText.exists || mapsDrProfileText.exists {
      closeCCButton.tap()
    } else if travelChrome.exists {
      travelChrome.tap()
      app.scrollViews.otherElements.buttons["Cancel"].tap()
      checkMessageIconPresent()
      tapBothButtonsOnProfile()
    } else if !mapsLikeAndDrProfileText.exists && !mapsLikedProfileText.exists {
      tapBothButtonsOnProfile()
    }

    func checkMessageIconPresent() {
      if messageButton.exists {
        messageButton.tap()
        checkForConnectedView()
        if messageBackButton.exists {
          messageBackButton.tap()
        }
        if xButton.exists {
          xButton.tap()
        } else if closeCCButton.exists {
          closeCCButton.tap()
        }
      }
    }

    func checkForConnectedView() {
      let sendMessageTextField = app.textViews.staticTexts["Send a message..."]
      let dismissConnectedModal = app.buttons[CompanyUI.AccessibilityIdentifier.Connections.xButton]
      let connectedView = app.staticTexts[CompanyUI.AccessibilityIdentifier.Connections.title]
      if connectedView.exists || sendMessageTextField.exists {
        dismissConnectedModal.tap()
      }
    }

    func tapBothButtonsOnProfile() {
      nap()
      if mapsLikeButton.exists {
        mapsLikeButton.tap()
      } else if mapsCheckMarkButton.exists {
        mapsCheckMarkButton.tap()
      }
      XCTAssert(mapsLikedProfileText.waitForExistence(timeout: TestConstants.timeout))
      checkForConnectedView()
      if mapsDrButton.exists {
        mapsDrButton.tap()
      } else if mapsDRFillButton.exists {
        mapsDRFillButton.tap()
      }
      mapsSendDr.tap()
      XCTAssert(mapsLikeAndDrProfileText.waitForExistence(timeout: TestConstants.timeout))
      checkForConnectedView()
    }
  }

  func tapMapsToggle() {
    // taps the nearby/global toggle

    let element = app.windows.children(matching: .other).element(boundBy: 0).children(matching: .other).element
    let child = element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other)
    let element2 = child.element.children(matching: .other).element.children(matching: .other).element
    let child2 = element2.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let element3 = child2.element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .other)
    let filterToggle = element3.element.children(matching: .other).element(boundBy: 1)
    let globalToggle = filterToggle.staticTexts["Global"]
    XCTAssert(globalToggle.waitForExistence(timeout: TestConstants.timeout))
    globalToggle.tap()
    let nearbyToggle = filterToggle.staticTexts["Nearby"]
    XCTAssert(nearbyToggle.waitForExistence(timeout: TestConstants.timeout))
    nearbyToggle.tap()
  }

  func tapNearbyToggle() {
    let element = app.windows.children(matching: .other).element(boundBy: 0).children(matching: .other).element
    let child = element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other)
    let element2 = child.element.children(matching: .other).element.children(matching: .other).element
    let child2 = element2.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let element3 = child2.element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .other)
    let filterToggle = element3.element.children(matching: .other).element(boundBy: 1)
    let nearbyToggle = filterToggle.staticTexts["Nearby"]
    XCTAssert(nearbyToggle.waitForExistence(timeout: TestConstants.timeout))
    nearbyToggle.tap()
  }

  func tapIntoNeighborhood() {
    nap(timeout: TestConstants.midTimeout)
    let neighborhoodElement = app.windows.children(matching: .other).element(boundBy: 0).children(matching: .other)
    let nbhChild = neighborhoodElement.element.children(matching: .other).element(boundBy: 1).children(matching: .other).element
    let nbhElement = nbhChild.children(matching: .other).element.children(matching: .other).element
    let nbhChild2 = nbhElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let nbhElement2 = nbhChild2.element.children(matching: .other).element(boundBy: 0)
    let nbhChild3 = nbhElement2.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
    let nbhChild4 = nbhChild3.children(matching: .other).element(boundBy: 4).children(matching: .other)
    let neighborhoodPin = nbhChild4.element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
    neighborhoodPin.tap()
    neighborhoodPin.tap()
  }

  func removeNeighborhoodFilterPill() {
    let nbhChild = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .other)
    let nbhElement = nbhChild.element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
    let nbhChild2 = nbhElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let nbhFilterElement = nbhChild2.element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
    let nbhFilterChild = nbhFilterElement.children(matching: .other).element(boundBy: 1)
    let neighborhoodFilterPill = nbhFilterChild.children(matching: .other).element.children(matching: .button).element
    XCTAssert(neighborhoodFilterPill.waitForExistence(timeout: TestConstants.timeout))
    neighborhoodFilterPill.tap()
  }

  func navigateBackHome() {
    // Taps navigation icon (star trek symbol ;) )

    let navchild = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .other)
    let navelement = navchild.element.children(matching: .other).element(boundBy: 1).children(matching: .other)
    let navelement2 = navelement.element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    let navchild2 = navelement2.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let navelement3 = navchild2.element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other)
    let navigationIcon = navelement3.element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    XCTAssert(navigationIcon.waitForExistence(timeout: TestConstants.timeout))
    navigationIcon.tap()
  }
}
