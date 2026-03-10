//  BaseTest.swift
//
import Foundation
import CompanyUI
import XCTest

extension XCUIElement {
  func labelContains(text: String) -> Bool {
    let predicate = NSPredicate(format: "label CONTAINS %@", text)
    return staticTexts.matching(predicate).firstMatch.exists
  }
}

class BaseTest: BaseAuthenticatedTest {
  // this variable is set for github actions to go through the login logout flow. 
  var performLoginLogout: Bool {
    return true
  }

  override func setUp() {
    super.setUp()
    app.launchArguments.append("-configureForUITests")
    app.launch()
    executionTimeAllowance = 240 // The swipe test takes 4 minutes at the longest, so we make that the benchmark

    if performLoginLogout {
      checkIfPermissionsPresent()
      checkLoggedOut()
      happyPathLogIn()
    }
    continueAfterFailure = false
  }
  override func tearDown() {

    if performLoginLogout {
      if let failureCount = testRun?.failureCount, failureCount > 0 {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot)
        add(attach)
      }
      happyPathLogOut()
      nap()
    }
      BaseTest.sharedApp.terminate()

    if performLoginLogout {
      Springboard.deleteApp()
    }
      super.tearDown()
  }

  func relaunchApp() {
    BaseTest.sharedApp.terminate()
    BaseTest.sharedApp.launch()
  }

  func killApp() {
    sleep(1)
    BaseTest.sharedApp.terminate()
  }

  func startApp() {
    BaseTest.sharedApp.launch()
  }

  func checkLoggedOut() {
    let applyButton = app.staticTexts["Apply for membership"]
    if !applyButton.isHittable {
      happyPathLogOut()
      Springboard.deleteApp()
      app.launch()
    }
  }

  func checkIfPermissionsPresent() {
    nap(timeout: TestConstants.midTimeout)
    let notifPermissionButton = app.buttons["Allow"]
    let permissionsButton = app.buttons["OK"]
    nap(timeout: TestConstants.midTimeout)
    if notifPermissionButton.exists || permissionsButton.exists {
      Springboard.deleteApp()
      app.launch()
    }
  }

  func typeCharArray(str: String) {
    var newStr = ""
    if str.count < 6 {
      newStr = "0\(str)"
    } else {
      newStr = str
    }
    for element in newStr {
      BaseTest.sharedApp.keys[String(element)].tap()
    }
  }

  enum AccessibilityIdentifiers: String {

    case
    TabBarRedesignHome = "HOME",
    TabBarRedesignMaps = "MAPS",
    TabBarRedesignDirectory = "DIRECTORY",
    TabBarRedesignConnections = "CONNECTIONS",
    TabBarRedesignMe = "ME"
  }

  /* If the system will throw up alerts during your test – for example,
   if you ask for permission to read the user’s location – you can set
   a closure to run that can evaluate the system interruption and take
   any action you want. If you handled the interruption successfully
   your closure should return true; if not return false, and any other
   interruption monitors can be run. */

  var interruptionHandlers = [Any]()
  func addInterruptionHandlers() {
    let interruptionHandlerNotification = addUIInterruptionMonitor(withDescription: "Local Notifications") { alert -> Bool in
      let notifPermission = "“company” Would Like to Send You Notifications"
      if alert.labelContains(text: notifPermission) {
        alert.buttons["Allow"].tap()
        return true
      }
      return false
    }
    interruptionHandlers.append(interruptionHandlerNotification)

    let interruptionHandlerContacts = addUIInterruptionMonitor(withDescription: "Contacts Access") { alert -> Bool in
      let contactAccess = "“company” Would Like to Access Your Contacts"
      let ios17AllowButton = alert.buttons["Allow"]
      let ios15AllowButton = alert.buttons["OK"]
      let iosContinueButton = alert.buttons["Continue"]
      if alert.labelContains(text: contactAccess) {
        if ios17AllowButton.exists {
          ios17AllowButton.tap()
        } else if ios15AllowButton.exists {
          ios15AllowButton.tap()
        } else if iosContinueButton.exists {
          iosContinueButton.tap()
        }
        return true
      }
      return false
    }
    interruptionHandlers.append(interruptionHandlerContacts)

    let interruptionHandlerLocation = addUIInterruptionMonitor(withDescription: "Location Access") { alert -> Bool in
      let locationPermission = "Allow “company” to use your location?"
      if alert.labelContains(text: locationPermission) {
        alert.buttons["Allow While Using App"].tap()
        return true
      }
      return false
    }
    interruptionHandlers.append(interruptionHandlerLocation)

    let interruptionHandlerPurchase = addUIInterruptionMonitor(withDescription: "Purchase Success") { alert -> Bool in
      let purchaseSuccess = "You're all set."
      if alert.labelContains(text: purchaseSuccess) {
        alert.buttons["OK"].tap()
        return true
      }
      return false
    }
    interruptionHandlers.append(interruptionHandlerPurchase)

    let interruptionHandlerMicrophone = addUIInterruptionMonitor(withDescription: "Microphone Access") { alert -> Bool in
      let microphoneAccess = "“company” Would Like to Access the Microphone"
      let ios17AllowButton = alert.buttons["Allow"]
      let ios15OKButton = alert.buttons["OK"]
      if alert.labelContains(text: microphoneAccess) {
        if ios17AllowButton.exists {
          ios17AllowButton.tap()
        } else if ios15OKButton.exists {
          ios15OKButton.tap()
        }
        return true
      }
      return false
    }
    interruptionHandlers.append(interruptionHandlerMicrophone)
  }

  func waitForElementToAppear(format: String, element: AnyObject, time: Double) {
    let exists = NSPredicate(format: format)
    expectation(for: exists, evaluatedWith: element, handler: nil)
    waitForExpectations(timeout: time, handler: nil)
  }
}
