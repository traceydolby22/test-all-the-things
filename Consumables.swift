import Foundation
import XCTest
import enum CompanyUI.AccessibilityIdentifier

class Consumables: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  // Direct Requests in settings

  func selectDirectRequestsToBuy() {
    let directRequests = app.tables.staticTexts["Direct Request"]
    XCTAssert(directRequests.waitForExistence(timeout: TestConstants.timeout))
    directRequests.tap()
    let purchasethreeDr = app.staticTexts["3 Direct Requests for $12.99"]
    XCTAssert(purchasethreeDr.waitForExistence(timeout: TestConstants.timeout))
    purchasethreeDr.tap()
  }

  // Travel Plans in settings

  func selectTravelPlansToBuy() {
    let travelPlan = app.tables.staticTexts["Travel Plans"]
    let redesignTPSelection = app.staticTexts["1 Travel Plan for $9.99"]
    let oneTravelPlan = app.scrollViews.otherElements.buttons["1 Travel Plan for $9.99"]

    if travelPlan.isHittable {
      travelPlan.tap()
      if oneTravelPlan.isHittable {
        oneTravelPlan.tap()
      } else if redesignTPSelection.isHittable {
        redesignTPSelection.tap()
      }
    }
  }

  // Skip the wait in settings

  func selectSTWToPurchase() {
    let eosCarouselSTWButton = app.scrollViews.otherElements.collectionViews.staticTexts["Skip the Wait"]
    let skipTheWaitOW = app.tables.staticTexts["Skip the Wait"]
    if skipTheWaitOW.isHittable {
      skipTheWaitOW.tap()
    }
    eosCarouselSTWButton.tap()
    let purchaseOneSTW = app.scrollViews.otherElements.buttons["1 Skip the Wait for $7.99"]
    let redesignPurchaseSTW = app.staticTexts["1 Skip the Wait for $7.99"]
    if purchaseOneSTW.isHittable {
      purchaseOneSTW.tap()
    } else {
      redesignPurchaseSTW.tap()
    }
  }

  // purchasing STW in the stack for Old world and redesign

  func skipTheWaitStackPurchase() {
    let stackSTWButtonOW = app.scrollViews.otherElements[CompanyUI.AccessibilityIdentifier.Stack.endOfStackView].buttons["Skip the Wait"]
    let eosCarouselSTWButton = app.scrollViews.otherElements.collectionViews.staticTexts["Skip the Wait"]
    let selectStw = app.scrollViews.otherElements.buttons["1 Skip the Wait for $7.99"]
    let redesignselectOption = app.staticTexts["1 Skip the Wait for $7.99"]
    if stackSTWButtonOW.isHittable {
      stackSTWButtonOW.tap()
    } else if eosCarouselSTWButton.isHittable {
      eosCarouselSTWButton.tap()
    }
    if selectStw.isHittable {
      selectStw.tap()
    } else if redesignselectOption.isHittable {
      redesignselectOption.tap()
    }
  }

let redesignAppleAlert = Springboard.springboard
 lazy var redesignPurchaseButton = redesignAppleAlert.buttons["Purchase"]

func appleRedesignPurchasePrompt() {
  nap()
  let ios16PurchaseButton = app.buttons["Purchase"]
  if redesignPurchaseButton.isHittable {
    XCTAssert(redesignPurchaseButton.waitForExistence(timeout: TestConstants.longTimeout))
    redesignPurchaseButton.tap()
  } else if ios16PurchaseButton.isHittable {
    ios16PurchaseButton.tap()
  }
}

let appleAlert = Springboard.springboard
lazy var purchaseButton = appleAlert.buttons["Purchase"]
lazy var numbersKey = appleAlert.keys["numbers"]
lazy var lettersKey = appleAlert.keys["letters"]
lazy var shiftKey = appleAlert.keyboards.buttons["shift"]
// works for consumables for redesign and old world no need to get rid of later.
func applePurchasePrompt() {
  if purchaseButton.isHittable {
    XCTAssert(purchaseButton.waitForExistence(timeout: TestConstants.longTimeout))
    purchaseButton.tap()
  }
}

// works for consumables for redesign and old world no need to get rid of later.
func appleSignIn() {
  let signInAlert = appleAlert.secureTextFields["Password"]
  let ios15SignIn = appleAlert.alerts["Sign in with Apple ID"].scrollViews.otherElements.collectionViews.secureTextFields["Password"]
  if signInAlert.isHittable {
    XCTAssert(signInAlert.waitForExistence(timeout: TestConstants.longTimeout))
    signInAlert.tap()
  } else {
    ios15SignIn.tap()
  }
}
// Entering password from Apple's secure Keyboard
// works for consumables for redesign and old world no need to get rid of later.
func enterPassword() {
  shiftKey.tap()
  appleAlert.keys["T"].tap()
  numbersKey.tap()
  appleAlert.keys["3"].tap()
  lettersKey.tap()
  appleAlert.keys["s"].tap()
  appleAlert.keys["t"].tap()
  numbersKey.tap()
  appleAlert.keys["1"].tap()
  lettersKey.tap()
  appleAlert.keys["n"].tap()
  appleAlert.keys["g"].tap()
  numbersKey.tap()
  appleAlert.keys["!"].tap()
  let signInToPay = appleAlert.buttons["Sign In"]
  let scrollViewWindow = app.windows["SBTransientOverlayWindow"].scrollViews.otherElements
  let redesignSignInToPay = scrollViewWindow.buttons["Sign In"]
  if signInToPay.isHittable {
    signInToPay.tap()
  } else {
    redesignSignInToPay.tap()
  }
}

// So the reason why there is a 15 sec timeout here is due to the successful payment prompt not
// showing for like 12-15 seconds on average.
// works for consumables for redesign and old world no need to get rid of later.
func checkIfPasswordNeeded() {
  if appleAlert.secureTextFields["Password"].isHittable {
    appleSignIn()
    enterPassword()
    nap(timeout: TestConstants.fifteenTimeout)
    dismissApplePrompt()
  } else {
    nap(timeout: TestConstants.fifteenTimeout)
    dismissApplePrompt()
  }
}

// Purchase Easy Tiger
func checkPurchaseEasyTiger() {
  let etModalTitle = app.staticTexts["Daily Likes Reached"]
  let ios16ETButton = app.buttons["30 More Likes $10.99"]
  let easyTiger = app.scrollViews.otherElements.buttons["30 More Likes $10.99"]
  if etModalTitle.isHittable {
    if easyTiger.isHittable {
      easyTiger.tap()
    } else if ios16ETButton.isHittable {
      ios16ETButton.tap()
    }
    applePurchasePrompt()
    checkIfPasswordNeeded()
  }
}

// This will dismiss the payment successful prompt
// works for redesign and old world no need to get rid of later....
func dismissApplePrompt() {
  addInterruptionHandlers()
  let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
  springboard.buttons["OK"].tap()
  let appNotifs = BaseTest.sharedApp
  appNotifs.tabBars.firstMatch.waitForExistence(timeout: TestConstants.timeout)
  appNotifs.tap()
}

}
