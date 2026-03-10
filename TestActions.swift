import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class TestActions2024: BaseTest {

  func dismissInterrupters() {
    addInterruptionHandlers()

    // this ensures the BaseTest.swift addInterruptionHandlers() function above runs

    let appNotifs = BaseAuthenticatedTest.sharedApp
    appNotifs.tabBars.firstMatch.waitForExistence(timeout: TestConstants.timeout)
    appNotifs.tap()
    let canAllowContacts = app.buttons["Allow"]
    let allowContactsExists = canAllowContacts.waitForExistence(timeout: TestConstants.timeout)
    XCTAssert(allowContactsExists, "APP prompt to allow access to contacts")
    canAllowContacts.tap()
    nap()
    appNotifs.tap()
    let contactsPrompt = XCUIApplication(bundleIdentifier: "com.apple.ContactsUI.LimitedAccessPromptView")
    if contactsPrompt.waitForExistence(timeout: TestConstants.timeout) {
      let allowFullAccessButton = contactsPrompt.buttons["Allow Full Access"]
      if allowFullAccessButton.exists {
        allowFullAccessButton.tap()
      }
    }
    // Dismiss Raya location permission prompt
    let canDismissLocation = app.buttons["Allow"]
    let dismissLocationExists = canDismissLocation.waitForExistence(timeout: TestConstants.timeout)
    XCTAssert(dismissLocationExists, "APP prompt to allow Locations")
    canDismissLocation.tap()
    appNotifs.tabBars.firstMatch.waitForExistence(timeout: TestConstants.timeout)
    appNotifs.tap()
    nap()
    amIinFullStack()
  }

  func tapEditProfile() {
    nap()
    let meTab = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["me"]
    let editProfileButton = app.collectionViews.buttons["Edit profile"]
    XCTAssert(meTab.waitForExistence(timeout: TestConstants.timeout))
    meTab.tap()

    if editProfileButton.exists {
      editProfileButton.tap()
    }
  }

  func tappingMeIcon() {
    nap(timeout: TestConstants.shortestTimeout)
    let tabBar = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar]
    let meTab = tabBar.children(matching: .button).element(boundBy: 4)
    XCTAssert(meTab.waitForExistence(timeout: TestConstants.timeout))
    meTab.tap()
  }

  func addInterests() {
    // tapping Add Interests +
    let editAddInterests = app.tables.buttons[CompanyUI.AccessibilityIdentifier.EditProfile.addInterests]
    if editAddInterests.exists {
      editAddInterests.tap()
    }

    // Taps into text field to enter manually

    let manuallyAddInterests = app.collectionViews.children(matching: .cell)
      .element(boundBy: 10)
      .children(matching: .other)
      .element.children(matching: .button)
      .element

    let cancelInterest = app.navigationBars["Add Interests"].buttons["Cancel"]
    let doneEditProfile = app.navigationBars["Edit Profile"].buttons["Done"]

    if manuallyAddInterests.exists {
      manuallyAddInterests.tap()
      enterInText()
      cancelInterest.tap()
      doneEditProfile.tap()
    }

    func enterInText() {

      app.keys["D"].tap()
      app.keys["o"].tap()
      app.keys["g"].tap()
      app.keys["s"].tap()
      app.buttons["Next:"].tap()
    }
  }

  func profileCheck() {
    let likeAndDirectRequestedNote = app.staticTexts["Liked and direct requested"]
    let likeProfileNote = app.staticTexts["You liked their profile"]
    let likeButton = app.buttons["LikeButton"]
    let bar = app.toolbars["Toolbar"]
    let element = bar.children(matching: .other).element.children(matching: .other).element
    let backButton = app.toolbars["Toolbar"].buttons["LeftChevron"]
    let messageBackButton = element.children(matching: .button).element(boundBy: 0)
    let profileMessageButton = app.buttons["MessageButton"]
    let connectionXButton = app.buttons[RayaUI.AccessibilityIdentifier.Connections.xButton]

    if profileMessageButton.exists {
      profileMessageButton.tap()
      nap()
      if messageBackButton.exists {
        messageBackButton.tap()
      } else if backButton.exists {
        backButton.tap()
      } else if connectionXButton.exists {
        connectionXButton.tap()
       }
      nap()
      checkReportModal()
    } else if likeProfileNote.exists {
      app.buttons["DRButton"].tap()
      let drNote = app.textViews.staticTexts["Add a personal note (optional)"]
      XCTAssert(drNote.waitForExistence(timeout: TestConstants.timeout))
      drNote.tap()
      app.typeText("Hi")
      app.buttons["Send Direct Request"].tap()
      checkReportModal()
    } else if likeAndDirectRequestedNote.exists {
      checkReportModal()
    } else {
      likeButton.tap()
      checkReportModal()
    }
  }

  func directoryTab() {
    nap()
    let directoryTabBar = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["directory"]
    XCTAssert(directoryTabBar.waitForExistence(timeout: TestConstants.timeout))
    directoryTabBar.tap()
    let searchBar = app.collectionViews.staticTexts["Search "]
    XCTAssert(searchBar.waitForExistence(timeout: TestConstants.timeout))
    searchBar.tap()
  }

  func checkReportModal() {
    // have to do this since on the view, automation can't locate button
    let reportElements = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
    let reportChildren = reportElements.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let reportModal = reportChildren.element.children(matching: .button).element(boundBy: 1)
    let closeReportModal = app.staticTexts["Dismiss"]
    nap()
    reportModal.tap()
    closeReportModal.tap()
  }

  func tapSearchBarExamples() {
    let closeButton = app.buttons["Close"]
    let exampleSearchesDirectory = app.tables[CompanyUI.AccessibilityIdentifier.Directory.exampleSearches]
    let searchBarExamples = exampleSearchesDirectory.staticTexts
    nap(timeout: TestConstants.shortestTimeout)
    searchBarExamples.element(boundBy: Int.random(in: 0..<searchBarExamples.count)).tap()
    closeButton.tap()
  }

  func tapDirectoryExamples() {
    let collectionViews = app.collectionViews
    let directorySelection = collectionViews.children(matching: .cell)
    let cancelButton = app.buttons[CompanyUI.AccessibilityIdentifier.Directory.searchBarCancelButton]
    nap(timeout: TestConstants.shortestTimeout)
    directorySelection.element(boundBy: Int.random(in: 0..<directorySelection.count)).tap()
    cancelButton.tap()
  }

  func checkForMapsToggledOff() {
    let membersNearbyCopy = app.staticTexts["Members nearby"]
    let mapsModal = app.staticTexts["Discover members in Maps"]
    let turnOnMaps = app.staticTexts["Turn on"]
    if mapsModal.exists {
      turnOnMaps.tap()
    }
    XCTAssert(membersNearbyCopy.waitForExistence(timeout: TestConstants.timeout))

    guard let url = URL(string: "APP://") else {
         fatalError("Cannot move away from map")
       }
    app.open(url)
  }

  // This is here since the tests will sometimes tap into the stack..... //

  func amIinFullStack() {
    let element = app.scrollViews.children(matching: .other).element(boundBy: 0)
    let xButton = element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    let dismissStwModal = app.staticTexts["Dismiss"]
    let stwXButton = element.children(matching: .other).element.children(matching: .button).element
    if xButton.exists {
      xButton.tap()
    } else if dismissStwModal.exists {
      dismissStwModal.tap()
      // stwXButton.tap()
    }
  }

  func tappingIntoMessageToSend() {
    dismissInterrupters()
    nap(timeout: TestConstants.midTimeout)
    app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["connections"].tap()
    let accessId = app.tables[CompanyUI.AccessibilityIdentifier.Messages.connections]
    let tapTestUser = accessId.cells.containing(.staticText, identifier: "21h").staticTexts["Testing"]
    let tapUserTest = accessId.cells.containing(.staticText, identifier: "Reaction sent: 👍").staticTexts["Testing"]
    let tapUser = accessId.cells.containing(.staticText, identifier: "Reaction sent: 😄").staticTexts["Testing"]
    if tapUser.exists {
      tapUser.tap()
    } else if tapTestUser.exists {
      tapTestUser.tap()
    } else if tapUserTest.exists {
      tapUserTest.tap()
    }
  }

  func messageResponseGetItTapGesture() {
    let getItMessage = app.collectionViews.textViews["Get it"]
      if getItMessage.waitForExistence(timeout: TestConstants.timeout) {
       getItMessage.press(forDuration: 1.3)
      }
  }

  func yoMessageTapGesture() {
    let yoMessage = app.collectionViews.textViews["Yo"]
      if yoMessage.waitForExistence(timeout: TestConstants.timeout) {
       yoMessage.press(forDuration: 1.3)
      }
  }

  func dismissReferralTooltip() {
    let referralTooltip = app.tables.staticTexts["Refer a friend to Raya"]
    let referralBack = app.navigationBars["Referral"].buttons["back"]
    if referralTooltip.isHittable {
      referralTooltip.tap()
      nap(timeout: TestConstants.midTimeout)
      referralBack.tap()
    }
  }
}
