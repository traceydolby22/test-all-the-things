import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class EditProfile2024: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  func testEditProfileUpperHalf() throws {
    dismissInterrupters()
    nap()
    tapEditProfile()

    let tablesQuery = app.tables
    let editGallery = tablesQuery.staticTexts["Edit photos"]
    XCTAssert(editGallery.waitForExistence(timeout: TestConstants.timeout))
    editGallery.tap()
    let profilePhoto = tablesQuery.staticTexts["Profile photo"]
    XCTAssert(profilePhoto.waitForExistence(timeout: TestConstants.timeout))
    profilePhoto.tap()
    let profileBack = app.navigationBars["Profile photo"].children(matching: .button).element(boundBy: 0)
    profileBack.tap()
    nap()
    let imageGallery = tablesQuery.staticTexts["Image gallery"]
    imageGallery.tap()
    app.navigationBars["Your gallery"].children(matching: .button).element(boundBy: 0)
    let galleryBack = app.navigationBars["Your gallery"].children(matching: .button).element(boundBy: 0)
    galleryBack.tap()
    let yourGalleryBack = app.navigationBars["Your gallery"].children(matching: .button).element
    yourGalleryBack.tap()

    // Taps into Gender section

    let gender = tablesQuery.staticTexts["Gender"]
    XCTAssert(gender.waitForExistence(timeout: TestConstants.timeout))
    gender.tap()
    tablesQuery.staticTexts["Male"].tap()
    let genderFemale = tablesQuery.staticTexts["Female"]
    genderFemale.tap()
    app.tables.staticTexts["More options"].tap()
    nap()
    app.textFields["Search"].tap()
    nap()
    app.keys["G"].tap()
    app.keys["e"].tap()
    app.keys["n"].tap()
    app.keys["d"].tap()
    app.keys["e"].tap()
    app.keys["r"].tap()
    app.buttons["search"].tap()
    let closeButton = app.buttons["Close"]
    closeButton.tap()
    let genderBackArrow = app.navigationBars["Gender"].children(matching: .button).element
    app.tables.staticTexts["Androgynous"].tap()
    let moreOptionsBackArrow = app.navigationBars["More options"].buttons["LeftChevron"]
    moreOptionsBackArrow.tap()

    // Making selections for non-binary

    let showMeToMen = tablesQuery.staticTexts["Members looking for men"]
    showMeToMen.tap()
    let showMeToWomen = tablesQuery.staticTexts["Members looking for women"]
    showMeToWomen.tap()

    // Tapping back arrow to see unsaved changes modal

    genderBackArrow.tap()
    app.staticTexts["Dismiss"].tap()
    let removeNonBinary = tablesQuery.cells.containing(.staticText, identifier: "Androgynous").children(matching: .button).element
    removeNonBinary.tap()
    genderFemale.tap()

    // Toggling displaying or not

    let displayGenderOn = tablesQuery.staticTexts["On"]
    displayGenderOn.tap()
    nap()
    let displayGenderOff = tablesQuery.staticTexts["Off"]
    displayGenderOff.tap()
    genderBackArrow.tap()

    // Taps into Occupation, where I work website, and where I live

    app.swipeUp(velocity: 300)
    tablesQuery.staticTexts["Occupation"].tap()
    let backButton = app.navigationBars["Occupation"].children(matching: .button).element
    backButton.tap()

    tablesQuery.staticTexts["Where I work"].tap()
    let elementChildren = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
    let childrenElement = elementChildren.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    let removeTextField = childrenElement.children(matching: .other).element.children(matching: .button).element
    removeTextField.tap()
    app.navigationBars["Where I work"].buttons["LeftChevron"].tap()
    nap()
    let discardChanges = app.staticTexts["Yes, discard changes"]
    discardChanges.tap()

    tablesQuery.staticTexts["Website"].tap()
    app.scrollViews.containing(.other, identifier: "Vertical scroll bar, 1 page").children(matching: .textView).element.tap()
    app.buttons["Emoji"].tap()

    let emojiText = app.keyboards.collectionViews.children(matching: .key).matching(identifier: "😂").element(boundBy: 0).staticTexts["😂"]
    emojiText.tap()
    nap(timeout: TestConstants.midTimeout)
    app.staticTexts["ABC"].tap()
    nap()
    app.typeText("hi")
    app.buttons["Emoji"].staticTexts["ABC"].tap()
    nap()
    emojiText.tap()

    let websiteBack = app.navigationBars["Website"].buttons["LeftChevron"]
    websiteBack.tap()
    discardChanges.tap()
    app.swipeUp(velocity: 300)
    tablesQuery.staticTexts["Where I live"].tap()
    let whereILiveBack = app.navigationBars["Where I live"].buttons["LeftChevron"]
    XCTAssert(whereILiveBack.waitForExistence(timeout: TestConstants.timeout))
    whereILiveBack.tap()
    tablesQuery.staticTexts["Where I'm from"].tap()
    let whereImFrom = app.navigationBars["Where I'm from"].buttons["LeftChevron"]
    XCTAssert(whereImFrom.waitForExistence(timeout: TestConstants.timeout))
    whereImFrom.tap()
    XCTAssert(app.navigationBars["Edit profile"].staticTexts["Edit profile"].exists)
    app.buttons["Done"].tap()
  }

  func testEditProfileBottomHalf() {
    dismissInterrupters()
    nap()
    tapEditProfile()

    let tablesQuery = app.tables
    app.swipeUp(velocity: 500)
    let oftenVisitsCopy = tablesQuery.staticTexts["Add cities you often visit"]
    let oftenVisitsCell = tablesQuery.cells.matching(identifier: "locationFrom.EditProfile").staticTexts["Where I often visit"]

    if oftenVisitsCell.exists {
      oftenVisitsCell.tap()
    } else if oftenVisitsCopy.exists {
      oftenVisitsCopy.tap()
    }
    let searchField = app.textFields["Search any city"]
    searchField.tap()
    app.typeText("Los Angeles")

    let losAngelesText = app.tables.staticTexts["Los Angeles, CA"]
    XCTAssert(losAngelesText.waitForExistence(timeout: TestConstants.timeout))
    losAngelesText.tap()
    searchField.tap()
    app.typeText("New York")
    app.buttons["Return"].tap()

    let newYorkText = app.tables.staticTexts["New York, NY"]
    XCTAssert(newYorkText.waitForExistence(timeout: TestConstants.timeout))
    newYorkText.tap()
    let saveButton = app.buttons["Save"]
    saveButton.tap()

    let cityPillID = app.otherElements[CompanyUI.AccessibilityIdentifier.EditProfile.OftenVisits.cityPills]
    oftenVisitsCell.tap()
    let nyRemoveButton = cityPillID.staticTexts["New York, NY"]
    nyRemoveButton.tap()
    let laRemoveButton = cityPillID.staticTexts["Los Angeles, CA"]
    laRemoveButton.tap()
    app.navigationBars["Add cities you often visit"].buttons["LeftChevron"].tap()
    app.staticTexts["Dismiss"].tap()
    saveButton.tap()
    nap(timeout: TestConstants.midTimeout)
    let editBio = tablesQuery.buttons["Edit bio"]
    nap()
    editBio.tap()
    nap()
    app.navigationBars["About you"].buttons["LeftChevron"].tap()

    // Edit interests

    app.swipeUp(velocity: 300)
    let editInterestsButton = tablesQuery.staticTexts["Edit interests"]
    XCTAssert(editInterestsButton.waitForExistence(timeout: TestConstants.timeout))
    editInterestsButton.tap()
    let addInterest = app.collectionViews.textFields["Add interests"]
    XCTAssert(addInterest.waitForExistence(timeout: TestConstants.timeout))
    addInterest.tap()
    app.typeText("Dog")
    app.buttons["Done"].tap()
    app.navigationBars["Interests"].buttons["LeftChevron"].tap()

    // Taps the Places App to toggle privacy
    nap()
    app.swipeUp(velocity: 500)
    nap()
    let placesRowText = tablesQuery.staticTexts["Places app"]
    let editPrivacyButton = app.tables.staticTexts["Edit privacy"]
    let downloadPlacesButton = app.staticTexts["Download Places"]
    let placesText = app.staticTexts["Enjoy exclusive access to Places"]
    XCTAssert(placesRowText.waitForExistence(timeout: TestConstants.timeout))
    editPrivacyButton.tap()
    let placesOnRayaProfile = app.staticTexts["Display Places on Raya profile"]
    XCTAssert(placesOnRayaProfile.waitForExistence(timeout: TestConstants.timeout))
    let placesOnRayaProfileToggle = app.switches[CompanyUI.AccessibilityIdentifier.CommonButtons.toggle]
    placesOnRayaProfileToggle.tap()
    nap()
    placesOnRayaProfileToggle.tap()
    app.navigationBars["Places app"].buttons["LeftChevron"].tap()

    if downloadPlacesButton.isHittable {
      app.tables.staticTexts["Join Places"].tap()
      XCTAssert(placesText.exists && downloadPlacesButton.exists)
      app.staticTexts["Dismiss"].tap()
      XCTFail("Places Ad is showing when it shouldn't be")
      return
    }

    // Taps into edit song, checks you can tap into search bar
    nap()
    app.swipeUp(velocity: 400)
    nap()
    let os17EditSong = app.tables.staticTexts["Edit song"]
    let os15EditSong = app.tables.buttons["Edit song"]
    nap()
    if os15EditSong.exists {
      os15EditSong.tap()
    } else if os17EditSong.exists {
      os17EditSong.tap()
    }
    nap()
    app.textFields["Search any song"].tap()
    app.typeText("ap")
    let closeButton = app.buttons["Close"]
    closeButton.tap()
    let profileSongBack = app.navigationBars["Profile song"].children(matching: .button).element

    if profileSongBack.exists {
      profileSongBack.tap()
    }
    // Taps into mixtape to search for, add and remove a song
    app.swipeUp(velocity: 400)

    let editMixtape = app.tables.staticTexts["Edit Mixtape"]
    nap()
    if editMixtape.exists {
      editMixtape.tap()
    }

    let mixtapeNavigationBar = app.navigationBars["Mixtape"]
    let mixtapeBackButton = mixtapeNavigationBar.buttons["LeftChevron"]
    let addMixtapeSong = mixtapeNavigationBar.buttons["Add"]
    addMixtapeSong.tap()
    app.textFields["Search any song"].tap()
    app.typeText("nsync")
    app.buttons["Search"].tap()
    nap()
    app.tables.staticTexts["Bye Bye Bye"].tap()
    nap()
    let pauseButton = tablesQuery.buttons["PauseFill"]
    pauseButton.tap()

    let nsyncRow = tablesQuery.cells.containing(.staticText, identifier: "Bye Bye Bye")
    let  addSong = nsyncRow.buttons[CompanyUI.AccessibilityIdentifier.EditProfile.Mixtape.addSongsButton]

    let removeSong = nsyncRow.buttons[CompanyUI.AccessibilityIdentifier.EditProfile.Mixtape.removeSongsButton]
    addSong.tap()
    removeSong.tap()
    let addSongClose = app.navigationBars["Add songs"].children(matching: .button).element

    if addSongClose.exists {
      addSongClose.tap()
    }

    // taps song on mixtape

    app.tables.staticTexts["Dua Lipa"].tap()
    app.buttons["PauseFill"].tap()
    app.navigationBars["Mixtape"].buttons["LeftChevron"].tap()
    // app.navigationBars["Mixtape"].children(matching: .button).element(boundBy: 0).tap()
    // Taps to toggle HJFF

    let hjffCopy = app.tables.staticTexts["I'm here for friends"]
    XCTAssert(hjffCopy.waitForExistence(timeout: TestConstants.timeout))
    hjffCopy.tap()
    XCUIApplication().staticTexts["On"].tap()
    let hjffBack = app.navigationBars["What are you using Raya for"].buttons["LeftChevron"]
    let ios18hjffBack = app.navigationBars["What are you using Raya for"].children(matching: .button).element
    if hjffBack.exists {
      hjffBack.tap()
    } else if ios18hjffBack.exists {
      ios18hjffBack.tap()
    }
    // tapping Done at very bottom of view

    app.buttons["Done"].tap()
  }
}
