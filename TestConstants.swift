import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

enum TestConstants {
  static let timeout: TimeInterval = 10
  static let shortestTimeout: TimeInterval = 1
  static let shortTimeout: TimeInterval = 2
  static let midTimeout: TimeInterval = 5
  static let longTimeout: TimeInterval = 20
  static let fifteenTimeout: TimeInterval = 15
}

func nap(timeout: TimeInterval = TestConstants.shortTimeout) {
  sleep(UInt32(timeout))
}

class StackSwipingActions: Consumables {

  func tappingIntoStack() {
    app.swipeUp(velocity: 200)
    let like = app.buttons["LikeButton"]
    let checkmark = app.buttons["Checkmark"]
    let heart = app.buttons["Heart"]
    nap(timeout: TestConstants.timeout)

    if heart.isHittable {
      heart.tap()
    } else if checkmark.isHittable {
      checkmark.tap()
    } else if like.isHittable {
      like.tap()
    }
  }

  // Swiping "X" through to End of stack

  lazy var stackScrollViews = app.scrollViews
  lazy var collectionViewsQuery = stackScrollViews.otherElements.collectionViews
  lazy var noSkipCopy = app.staticTexts["No Skip the Waits remaining"]

  lazy var eosCarouselSkipTheWait = app.buttons["Skip the Wait"]
  // Checking if skip the waits are available to use or purchase

  func checkSkipTheWaitPurchase() {
    let scrollView = app.scrollViews.otherElements
    let noSkipCopyPred = NSPredicate(format: "label CONTAINS[c] %@", noSkipCopy)
    let skipsCopyPresent = app.staticTexts.containing(noSkipCopyPred)
    // swiftlint:disable:next empty_count
    if skipsCopyPresent.count == 0 {
      skipTheWaitStackPurchase()
      appleRedesignPurchasePrompt()
      checkIfPasswordNeeded()
    } else if eosCarouselSkipTheWait.isHittable && !noSkipCopy.isHittable {
      eosCarouselSkipTheWait.tap()
    }
  }

  // Check for connected modal while swiping works for both redesign and old world

  func checkForConnectedView() {
    let dismissConnectedModal = app.buttons[CompanyUI.AccessibilityIdentifier.Connections.xButton]
    let connectedView = app.staticTexts[CompanyUI.AccessibilityIdentifier.Connections.title]
    if connectedView.exists {
      dismissConnectedModal.tap()
    }
  }

  func swipingThroughStack() {
    let stackScrollViews = app.scrollViews
    let stackButton = stackScrollViews.otherElements
    let swipeXButton = stackButton.buttons["DislikeButton"]
    if eosCarouselSkipTheWait.isHittable && eosCarouselSkipTheWait.isHittable {
      eosCarouselSkipTheWait.tap()
      app.staticTexts["Dismiss"].tap()
    } else if !eosCarouselSkipTheWait.isHittable {
      if swipeXButton.exists {
        swipeXButton.tap()
      }
    }
  }

  func swipingLike() {
    let heartButton = app.scrollViews.otherElements.buttons["new swipeHeart"]
    let checkMarkButton = app.scrollViews.otherElements.buttons["LikeButton"]
    let checkMarkButtonios17 = app.tables.buttons["LikeButton"]
    if heartButton.exists && !eosCarouselSkipTheWait.exists {
      XCTAssert(heartButton.waitForExistence(timeout: TestConstants.timeout))
      heartButton.tap()
    } else if checkMarkButton.exists && !eosCarouselSkipTheWait.exists {
      XCTAssert(checkMarkButton.waitForExistence(timeout: TestConstants.timeout))
      checkMarkButton.tap()
    }
  }
}
