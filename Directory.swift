import Foundation
import XCTest
import enum CompanyUI.AccessibilityIdentifier

class Directory2024: TestActions2024 {

  func testDirectorySearch() throws {
    dismissInterrupters()
    // Tap directory in tab bar then search bar to enter in Raya..
    directoryTab()
    app.typeText("Raya")
    let rayaResult = app.tables[CompanyUI.AccessibilityIdentifier.Directory.exampleSearches].staticTexts["Members at Raya"]
    XCTAssert(rayaResult.waitForExistence(timeout: TestConstants.timeout))
    rayaResult.tap()
    let searches = app.tables[CompanyUI.AccessibilityIdentifier.Directory.exampleSearches]
    let cells = searches.cells
    let resultsCard = cells.matching(identifier: CompanyUI.AccessibilityIdentifier.Directory.resultsProfileCard).firstMatch
    XCTAssert(resultsCard.waitForExistence(timeout: TestConstants.timeout))
    resultsCard.tap()
    profileCheck()
    let igDoneButton = app.buttons["Done"]
    let igLink = app.collectionViews.buttons[CompanyUI.AccessibilityIdentifier.MemberProfile.iGLink]
    nap()
    igLink.tap()
    XCTAssert(igDoneButton.waitForExistence(timeout: TestConstants.timeout))
    igDoneButton.tap()

    // have to do this since on the view, automation can't locate button
    let xButtonElement = app.windows.children(matching: .other).element.children(matching: .other).element
    let buttonChildren = xButtonElement.children(matching: .other).element.children(matching: .other).element
    let profilexButton = buttonChildren.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    XCTAssert(profilexButton.waitForExistence(timeout: TestConstants.timeout))
    profilexButton.tap()
  }

  func testDirectorySearchBar() throws {
    dismissInterrupters()
    let cancelButton = app.buttons[CompanyUI.AccessibilityIdentifier.Directory.searchBarCancelButton]
    nap()
    directoryTab()
    // Tapping the different options in Search bar
    for _ in 0...3 {
      tapSearchBarExamples()
    }
    cancelButton.tap()
    // Tapping the different 4 options on Directory view
    for _ in 0...3 {
      tapDirectoryExamples()
    }
  }

  func testProfileCard() throws {
    dismissInterrupters()    // tapping profile card
    directoryTab()
    let cancelSearchButton = app.buttons[CompanyUI.AccessibilityIdentifier.Directory.searchBarCancelButton]
    cancelSearchButton.tap()
    let child = app.children(matching: .window).element(boundBy: 0).children(matching: .other)
    let element = child.element.children(matching: .other).element.children(matching: .other).element
    let element1 = element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    let child1 = element1.children(matching: .other).element.children(matching: .other).element
    let element2 = child1.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other)
    let profileIcon = element2.element.children(matching: .other).element.children(matching: .other).element
    profileIcon.tap()

    app.staticTexts["Edit Profile"].tap()
    let doneButton = app.staticTexts["Done"]
    doneButton.tap()
    let privacyToggle = app.switches["toggle.ProfileCard"]
    privacyToggle.tap()

    nap(timeout: TestConstants.midTimeout)
    privacyToggle.tap()
    let dismissButton = app.staticTexts["Dismiss"]
    XCTAssert(dismissButton.exists)
    dismissButton.tap()
    let enableDirectory = app.buttons["Enable Directory"]
    let directoryPageTitle = app.staticTexts["Directory"]
    let directoryPageRayaPlus = app.staticTexts["Directory+"]
    if enableDirectory.exists {
      enableDirectory.tap()
    }
    XCTAssert(directoryPageTitle.exists || directoryPageRayaPlus.exists)
  }
}
