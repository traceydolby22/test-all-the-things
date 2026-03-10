import CompanyUI
import XCTest

class SettingsPage: TestActions2024 {

  func testRedesignMemberSettings24() throws {
    dismissInterrupters()
    tappingMeIcon()
    app.buttons[RCompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()
    app.tables.staticTexts["Member Suggestions"].tap()
    let toggleOff = app.tables.staticTexts["Off"]
    let toggleOn = app.tables.staticTexts["On"]
    XCTAssert(toggleOn.waitForExistence(timeout: TestConstants.timeout))
    app.switches[RCompanyUI.AccessibilityIdentifier.SettingsPage.MembershipSuggestions.toggle].tap()
    XCTAssert(toggleOff.waitForExistence(timeout: TestConstants.timeout))
    app.switches[CompanyUI.AccessibilityIdentifier.SettingsPage.MembershipSuggestions.toggle].tap()

    let noticeCopy = app.tables.staticTexts["Notice"]
    let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Adjust the settings below to personalize who you see in your home screen recommendations.")
    let adjustPrivacy = app.staticTexts.element(matching: predicate)
    XCTAssertTrue(adjustPrivacy.exists, "The 'Adjust Privacy' label does not exist.")
    XCTAssert(noticeCopy.exists)

    let men = app.tables.staticTexts["Men"]
    let women = app.tables.staticTexts["Women"]
    let allWomen = app.tables.staticTexts["All women"]
    let womenForWomen = app.tables.staticTexts["Women looking for women"]
    let allMen = app.cells.staticTexts["All men"]
    let menForMen = app.cells.staticTexts["Men looking for men"]
    let everyone = app.tables.staticTexts["Everyone"]
    let HJFF = app.tables.staticTexts["Only people here just for friends"]
    let excludeHJFF = app.tables.staticTexts["Exclude people here just for friends"]
    XCTAssertTrue(men.waitForExistence(timeout: TestConstants.timeout))
    men.tap()
    XCTAssertTrue(allWomen.waitForExistence(timeout: TestConstants.timeout))
    allWomen.tap()
    womenForWomen.tap()
    men.tap()
    let ageCheck = app.tables.cells["ageRange.MembershipSuggestions"].staticTexts["Age"]
    let ageRange24 = app.tables.staticTexts["Age"]
    XCTAssert(ageRange24.exists || ageCheck.exists)
    app.swipeUp(velocity: 400)

    HJFF.tap()
    excludeHJFF.tap()
    everyone.tap()
    let backButton = app.navigationBars["Member suggestions"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]
    let oldBackButton = app.navigationBars["Member suggestions"].buttons["back"]
    if oldBackButton.exists {
      oldBackButton.tap()
    } else if backButton.exists {
      backButton.tap()
    }
    let discardChangesModal = app.staticTexts["Yes, discard changes"]
    if discardChangesModal.exists {
      discardChangesModal.tap()
    }
    let settingsView = app.navigationBars["Settings"].staticTexts["Settings"]
    XCTAssert(settingsView.waitForExistence(timeout: TestConstants.timeout))
  }

  func testTogglesRedesign24() throws {

    // MARK: Toggle Directory checks for all copy on view
    dismissInterrupters()
    tappingMeIcon()
    app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()
    let directoryCell = app.tables.cells["Directory"].staticTexts["Directory"]
    let directoryText = app.tables.staticTexts["Directory"]
    func tappingDirectoryCell() {
      if directoryCell.exists {
        directoryCell.tap()
      } else if directoryText.exists {
        directoryText.tap()
      }
    }
    tappingDirectoryCell()
    let directoryNotice = app.tables.staticTexts["Notice"]
    let directoryOn = app.tables.staticTexts["On"]
    let directoryToggle = app.switches["Display profile in Directory"]
    XCTAssert(directoryNotice.exists)
    XCTAssert(directoryOn.exists)
    XCTAssert(directoryToggle.waitForExistence(timeout: TestConstants.timeout))
    directoryToggle.tap()

    let directoryBack = app.navigationBars["Directory"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]
    let directoryOff = app.tables.staticTexts["Off"]
    XCTAssert(directoryOff.waitForExistence(timeout: TestConstants.timeout))
    let saveButton = app.staticTexts["Save"]
    saveButton.tap()
    nap(timeout: TestConstants.midTimeout)
    tappingDirectoryCell()
    XCTAssert(app.tables.staticTexts["Off"].exists)
    directoryToggle.tap()
    saveButton.tap()

    // MARK: toggle Maps checks for all copy on view
    let appTable = app.tables.staticTexts
    let mapsRow = app.tables.staticTexts["Maps"]
    let mapsCopy = app.tables.staticTexts["Notice"]
    mapsRow.tap()
    // swiftlint:disable:next line_length
    let predicateMaps = NSPredicate(format: "label CONTAINS[c] %@", "Explore neighborhoods and cities around the world. Your profile will be shown to other members based on your privacy settings.")
    let mapsExploreCopy = app.staticTexts.element(matching: predicateMaps)
    XCTAssertTrue(mapsExploreCopy.exists, "The 'Adjust Privacy' label does not exist.")
    let displayMapsToggle = app.tables.switches["Display profile in Maps"]
    let mapsOn = app.tables.staticTexts["On"]
    let mapsOff = app.tables.staticTexts["Off"]
    let mapsBack = app.navigationBars["Maps"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]

    XCTAssert(mapsCopy.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(mapsExploreCopy.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(mapsOn.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(displayMapsToggle.waitForExistence(timeout: TestConstants.timeout))
    displayMapsToggle.tap()

    XCTAssert(mapsOff.waitForExistence(timeout: TestConstants.timeout))

    saveButton.tap()
    nap()
    mapsRow.tap()
    displayMapsToggle.tap()

    saveButton.tap()

    // MARK: Toggle Activity checks for all copy on view

    let activityRow = app.tables.containing(.other, identifier: "Features").staticTexts["Activity"]
    // swiftlint:disable:next line_length
    let activityText = app.tables.staticTexts["If enabled, your activity will be visible to your connections and other community members who may share your interests."]
    let activityOn = app.tables.cells["Activity"].staticTexts["On"]
    let activityOff = app.tables.cells["Activity"].staticTexts["Off"]
    let activityToggle = app.tables.switches["Activity"]
    let activityBack = app.navigationBars["Activities"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]
    let activityDismiss = app.staticTexts["Dismiss"]

    activityRow.tap()
    XCTAssert(activityText.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(activityToggle.waitForExistence(timeout: TestConstants.timeout))
    activityToggle.tap()

    activityBack.tap()
    activityDismiss.tap()
    saveButton.tap()

    XCTAssert(activityOff.waitForExistence(timeout: TestConstants.timeout))
    activityRow.tap()
    activityToggle.tap()
    saveButton.tap()
    nap()
    // MARK: Testing Light and Dark mode toggle

    let darkModeCell = app.tables.staticTexts["Dark Mode"]
    let deviceSettings = app.tables.staticTexts["Use your device system settings"]
    let darkAlways = app.tables.staticTexts["Always use dark mode"]
    let lightAlways = app.tables.staticTexts["Always use light mode"]
    let lightMode = app.tables.staticTexts["Always light mode"]
    let darkMode = app.tables.staticTexts["Always dark mode"]
    let autoMode = app.tables.staticTexts["Auto"]

    darkModeCell.tap()
    darkAlways.tap()
    saveButton.tap()
    XCTAssert(darkMode.waitForExistence(timeout: TestConstants.timeout))

    darkModeCell.tap()
    deviceSettings.tap()
    app.navigationBars["Dark Mode"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton].tap()
    app.staticTexts["Dismiss"].tap()
    saveButton.tap()
    XCTAssert(autoMode.exists)

    darkModeCell.tap()
    lightAlways.tap()
    saveButton.tap()
    XCTAssert(lightMode.exists)

    // MARK: Push notifications toggle testing copy on view

    let pushRow = app.tables.staticTexts["Push notifications"]
    let pushNotifToggle = app.tables.switches["Push Notifications"]
    let memberSuggestionToggle = app.tables.switches["New member suggestions"]
    let allowNotifCopy = app.tables.staticTexts["Allow Raya to send notifications"]
    let receiveNotifCopy = app.tables.staticTexts["Receive notifications when there are more members to browse."]
    let pushOn = app.tables.cells["Push Notifications"].staticTexts["On"]
    let pushOff = app.tables.cells["Push Notifications"].staticTexts["Off"]
    let memberSuggestionOn = app.tables.cells["New member suggestions"].staticTexts["On"]
    let memberSuggestionOff = app.tables.cells["New member suggestions"].staticTexts["Off"]
    let pushBack = app.navigationBars["Push Notifications"].buttons[RayaUI.AccessibilityIdentifier.CommonButtons.backButton]
    pushRow.tap()
    XCTAssert(pushNotifToggle.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(memberSuggestionToggle.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(allowNotifCopy.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(receiveNotifCopy.waitForExistence(timeout: TestConstants.timeout))
    pushNotifToggle.tap()
    // settingsToggle.tap()

    XCTAssert(pushOff.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(memberSuggestionOff.waitForExistence(timeout: TestConstants.timeout))

    saveButton.tap()
    pushRow.tap()
    pushNotifToggle.tap()
    memberSuggestionToggle.tap()
    // settingsToggle.tap()
    saveButton.tap()
    let settingsView = app.navigationBars["Settings"].staticTexts["Settings"]
    XCTAssert(settingsView.waitForExistence(timeout: TestConstants.timeout))
  }

  func testSettingsAccount() throws {
    dismissInterrupters()
    tappingMeIcon()
    app.buttons[RayaUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel].tap()
    app.tables.staticTexts["Direct Request"].tap()
    let dismissModal = app.staticTexts["Dismiss"]
    dismissModal.tap()
    app.tables.staticTexts["Travel Plans"].tap()
    dismissModal.tap()
    app.tables.staticTexts["Skip the Wait"].tap()
    dismissModal.tap()
    nap()
    app.swipeUp(velocity: 500)
    let committee = app.tables.cells["Committee"].children(matching: .staticText).matching(identifier: "Committee").element(boundBy: 1)
    if committee.exists {
      XCTAssert(committee.isHittable)
    }
    app.tables.staticTexts["Email address"].tap()
    let emailPrivacyCopy = app.staticTexts["Privacy"]
    let emailNotic = app.staticTexts["We ask for your email so we can get in touch with you. We will never share your information with anyone. "]
    app.staticTexts["Send verification email"].tap()
    let emailVerificationSentCopy = app.staticTexts["Verification email sent"]
    app.navigationBars["Email Address"].buttons["back"].tap()
    app.swipeUp(velocity: 400)

    app.tables.staticTexts["Who can see me"].tap()
    let visibilityCopy = app.tables.otherElements["Visibility"].staticTexts["Visibility"]
    XCTAssert(visibilityCopy.exists)
    app.tables.staticTexts["Only my connections"].tap()
    app.tables.staticTexts["Other members"].tap()
    let referralsCopy = app.tables.otherElements["Referrals"].staticTexts["Referrals"]
    XCTAssert(referralsCopy.exists)
    let referralSection = app.tables.children(matching: .cell).element(boundBy: 1)
    referralSection.staticTexts["No one"].tap()
    referralSection.staticTexts["Only my contacts"].tap()
    app.swipeUp(velocity: 400)
    let inCommonCopy = app.tables.otherElements["In Common"].staticTexts["In Common"]
    XCTAssert(inCommonCopy.exists)
    let incommonSection = app.tables.children(matching: .cell).element(boundBy: 2)
    incommonSection.staticTexts["No one"].tap()
    incommonSection.staticTexts["Only my contacts"].tap()
    let wcsmBackButton = app.navigationBars["Who can see me"].buttons[RayaUI.AccessibilityIdentifier.CommonButtons.backButton]
    wcsmBackButton.tap()

    app.tables.staticTexts["Blocked members"].tap()
    let blockedMembersHeader = app.navigationBars["Blocked members"]
    XCTAssert(blockedMembersHeader.staticTexts["Blocked members"].waitForExistence(timeout: TestConstants.timeout))
    blockedMembersHeader.buttons["back"].tap()

    app.tables.staticTexts["Email Raya"].tap()
    let composeEmailError = app.staticTexts["Unable to Compose Email"]
    XCTAssert(composeEmailError.waitForExistence(timeout: TestConstants.timeout))
    app.buttons["Okay"].tap()

    app.tables.staticTexts["Terms of Service"].tap()
    let tOSHeader = app.webViews.webViews.webViews.staticTexts["RAYA APP, INC. – TERMS OF USE"]
    XCTAssert(tOSHeader.waitForExistence(timeout: TestConstants.timeout))
    let backButton = app.toolbars["Toolbar"].buttons["LeftChevron"]
    backButton.tap()

    app.tables.staticTexts["Privacy Policy"].tap()
    let privacyHeader = app.webViews.webViews.webViews.staticTexts["RAYA APP, INC. - PRIVACY POLICY"]
    XCTAssert(privacyHeader.waitForExistence(timeout: TestConstants.timeout))
    backButton.tap()
    let settingsView = app.navigationBars["Settings"].staticTexts["Settings"]
    XCTAssert(settingsView.waitForExistence(timeout: TestConstants.timeout))

    // MARK: Tapping into Privacy Policy cell
    let tablesQuery = app.tables
    let privacyPolicy = tablesQuery.staticTexts["Privacy Policy"]
    let toolbarBackButton = app.toolbars["Toolbar"].buttons["backButtonIcon"]
    let backCaret = app.toolbars["Toolbar"].buttons["LeftChevron"]
    func caretButtonTap() {
      if toolbarBackButton.exists {
        toolbarBackButton.tap()
      } else if backCaret.exists {
        backCaret.tap()
      }
    }
    XCTAssert(privacyPolicy.waitForExistence(timeout: TestConstants.timeout))
    privacyPolicy.tap()
    caretButtonTap()
    app.navigationBars["Settings"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton].tap()
  }

  func testMemberSuggestionsAreOff() {
    dismissInterrupters()
    tappingMeIcon()
    let settings = app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel]
    let memberCell = app.tables.staticTexts["Member Suggestions"]
    let memberToggle = app.switches[CompanyUI.AccessibilityIdentifier.SettingsPage.MembershipSuggestions.toggle]
    let save = app.staticTexts["Save"]
    let settingBackButton = app.navigationBars["Settings"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton]

    let tabHome = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["home"]
    let toggleOff = app.tables.cells[CompanyUI.AccessibilityIdentifier.SettingsPage.MembershipSuggestions.toggle].staticTexts["Off"]
    let toggleOn = app.tables.cells[CompanyUI.AccessibilityIdentifier.SettingsPage.MembershipSuggestions.toggle].staticTexts["On"]

    settings.tap()
    memberCell.tap()
    nap()
    func memberSugCheck() {
      memberToggle.tap()
      nap()
      save.tap()
      nap()
      settingBackButton.tap()
      tabHome.tap()
      nap()
    }

    let suggestionsOff = app.staticTexts["Your member suggestions are off"]
    let stackEnableButton = app.staticTexts["Turn on Member Suggestions"]

    func enableSuggestion() {
      if suggestionsOff.exists {
        stackEnableButton.tap()
      }
    }

    if toggleOn.exists {
      memberSugCheck()
      XCTAssert(suggestionsOff.exists)
    } else if toggleOff.exists {
      app.navigationBars["Member suggestions"].children(matching: .button).element.tap()
      settingBackButton.tap()
      tabHome.tap()
      nap()
    }
    let checkmark = app.buttons["Checkmark"]
    let likeButton = app.buttons["LikeButton"]
    let heart = app.buttons["Heart"]
    XCTAssert(!heart.isHittable && !checkmark.isHittable)
    enableSuggestion()
    nap()
    XCTAssert(heart.isHittable || checkmark.isHittable || likeButton.isHittable)
  }

  func testExploratoryTogglesAreOff() {
    dismissInterrupters()
    tappingMeIcon()
    let settings = app.buttons[CompanyUI.AccessibilityIdentifier.SettingsPage.settingsCogwheel]
    let directory = app.tables.staticTexts["Directory"]
    let directoryToggle = app.switches["Display profile in Directory"]
    let save = app.buttons["Save"]
    let settingBackButton = app.navigationBars["Settings"].children(matching: .button).element
    let directoryTab = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["directory"]
    let toggleOn = app.tables.cells["Display profile in Directory"].staticTexts["On"]
    let toggleOff = app.tables.cells["Display profile in Directory"].staticTexts["Off"]
    settings.tap()
    directory.tap()
    nap()

    func checkDirectory() {
      directoryToggle.tap()
      nap()
      save.tap()
      nap()
      settingBackButton.tap()
      directoryTab.tap()
    }
    if toggleOn.exists {
      checkDirectory()
    } else if toggleOff.exists {
      app.navigationBars["Directory"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton].tap()
      settingBackButton.tap()
      directoryTab.tap()
    }

    let directoryOffCopy = app.staticTexts["Directory is currently off. To search and be found by the community, enable directory."]
    let enableDirectory = app.staticTexts["Enable Directory"]
    XCTAssert(directoryOffCopy.exists && enableDirectory.exists)
    tappingMeIcon()
    settings.tap()
    directory.tap()
    nap()
    checkDirectory()
    let searchBar = app.collectionViews.otherElements["searchField.Directory"].children(matching: .other).element(boundBy: 1)
    XCTAssert(searchBar.exists)
    tappingMeIcon()
    settings.tap()
    directory.tap()
    checkDirectory()
    app.buttons["Enable Directory"].staticTexts["Enable Directory"].tap()
    tappingMeIcon()

    // MARK: Activity toggle

    let activityRow = app.tables.staticTexts["Activity"]
    let activityToggle = app.tables.switches["Activity"]
    let tabHome = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["home"]
    let toggleActivityOff = app.tables.cells["Activity"].staticTexts["Off"]
    let toggleActivityOn = app.tables.cells["Activity"].staticTexts["On"]
    let bubbles = app.otherElements[CompanyUI.AccessibilityIdentifier.HomeView.bubbles].children(matching: .other).element(boundBy: 1)
    settings.tap()
    activityRow.tap()
    nap()
    func checkActivity() {
      activityToggle.tap()
      nap()
      save.tap()
      nap()
      settingBackButton.tap()
      tabHome.tap()
    }

    if toggleActivityOn.exists {
      checkActivity()
      XCTAssert(!bubbles.exists)
    } else if toggleActivityOff.exists {
      app.navigationBars["Activity"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton].tap()
      settingBackButton.tap()
      tabHome.tap()
      XCTAssert(!bubbles.exists)
    }

    tappingMeIcon()
    settings.tap()
    activityRow.tap()
    nap()
    checkActivity()
    nap()
    if bubbles.isHittable {
      XCTAssert(bubbles.exists)
    }
    tappingMeIcon()

    // MARK: Maps

    let mapsRow = app.tables.staticTexts["Maps"]
    let displayMapsToggle = app.tables.switches["Display profile in Maps"]
    let mapsTab = app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["maps"]
    let mapToggleOffCopy = app.staticTexts["Discover members in Maps"]
    let neighborhoodCopy = app.staticTexts["Here you'll be able to see other members grouped by neighborhood on the map as well as be discovered by others."]

    let enableMaps = app.staticTexts["Turn on"]
    let mapsDrawer = app.staticTexts["Members nearby"]
    let toggleMapsOn = app.tables.cells["Display profile in Maps"].staticTexts["On"]
    let toggleMapsOff = app.tables.cells["Display profile in Maps"].staticTexts["Off"]

    settings.tap()
    mapsRow.tap()
    nap()
    if toggleMapsOff.exists {
      app.navigationBars["Maps"].buttons[CompanyUI.AccessibilityIdentifier.CommonButtons.backButton].tap()
      settingBackButton.tap()
      mapsTab.tap()
      XCTAssert(mapToggleOffCopy.exists && neighborhoodCopy.exists)
    } else if toggleMapsOn.exists {
      displayMapsToggle.tap()
      save.tap()
      nap()
      settingBackButton.tap()
      mapsTab.tap()
      XCTAssert(mapToggleOffCopy.exists && neighborhoodCopy.exists)
    }
    enableMaps.tap()
    nap()
    XCTAssert(mapsDrawer.exists)
  }
}
