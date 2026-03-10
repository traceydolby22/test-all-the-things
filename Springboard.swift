//  Springboard.swift
//

import XCTest

enum Springboard {

  static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

  static func deleteApp() {
    // Force delete the app from the springboard
    XCUIApplication().terminate()
    XCUIDevice.shared.press(.home)
    locateApp()
    let icon = springboard.icons["AppName"].firstMatch
    if icon.exists {
      icon.press(forDuration: 1.3)
    } else {
      XCTFail("Failed to find app icon named AppName")
    }
    nap()
    let deleteApp = springboard.buttons["Delete App"]
    let ios17removeApp = springboard.buttons["Remove App"]
    let ios17deleteApp = springboard.buttons["Delete App"]
    let deleteRaya = springboard.buttons["Delete"]
    if ios17removeApp.isHittable {
      ios17removeApp.tap()
      nap()
      ios17deleteApp.tap()
      nap()
      deleteRaya.tap()
    } else if deleteApp.isHittable {
      deleteApp.tap()
      nap()
      deleteRaya.tap()
    }
    XCUIDevice.shared.press(.home)
  }

  static func locateApp() {
    springboard.swipeLeft(velocity: 500)
    // this is used if the app is NOT downloaded on the 'home view' and instead is in app library
    // springboard.swipeLeft(velocity: 500)
  }
}
