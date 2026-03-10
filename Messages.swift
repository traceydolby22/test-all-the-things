
import Foundation
import enum CompanyUI.AccessibilityIdentifier
import XCTest

class Messages2024: TestActions2024 {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  // Taps to search for people, then tests buttons within sending a message. Cannot run on os 15... the interruption handlers won't dismiss :( 

  func testMessages() throws {
    dismissInterrupters()
    nap()
    app.tabBars[CompanyUI.AccessibilityIdentifier.TabBar.tabBar].buttons["connections"].tap()
    let searchBar = app.tables.textFields[CompanyUI.AccessibilityIdentifier.Messages.FilterOptions.searchBar]
    searchBar.tap()
    let tablesQuery = app.scrollViews.otherElements.tables
    app.typeText("ap")
    let clearTextButton = app.tables.buttons[CompanyUI.AccessibilityIdentifier.Messages.FilterOptions.clearXButton]
    clearTextButton.tap()
    let cancelSearchButton = app.tables.buttons[CompanyUI.AccessibilityIdentifier.Messages.FilterOptions.cancelButton]
    XCTAssert(cancelSearchButton.waitForExistence(timeout: TestConstants.timeout))
    cancelSearchButton.tap()
    let conversationRow = app.tables[CompanyUI.AccessibilityIdentifier.Messages.connections]
    conversationRow.staticTexts["bobs"].tap()
    let sendMsgTextField = app.textViews.staticTexts["Send a message"]
    XCTAssert(sendMsgTextField.waitForExistence(timeout: TestConstants.timeout))
    sendMsgTextField.tap()
    app.typeText("Hey")
    let sendButton = app.buttons["SendEnabled"]
    XCTAssert(sendButton.waitForExistence(timeout: TestConstants.timeout))
    sendButton.tap()

    let toolbar = app.toolbars["Toolbar"]
    let moreButton = toolbar.buttons[CompanyUI.AccessibilityIdentifier.Messages.moreButton]
    let toolbarExtra = toolbar.children(matching: .other).element.children(matching: .other).element.children(matching: .button)

    moreButton.tap()

    let dismiss = app.staticTexts["Dismiss"]
    XCTAssert(dismiss.waitForExistence(timeout: TestConstants.timeout))
    dismiss.tap()

    let mic = app.buttons["Mic"]
    XCTAssert(mic.waitForExistence(timeout: TestConstants.timeout))
    mic.tap()
    addInterruptionHandlers()
    let appNotifs = BaseTest.sharedApp
    appNotifs.tabBars.firstMatch.waitForExistence(timeout: TestConstants.timeout)
    appNotifs.tap()
    nap()
    let stopRecord = app.buttons["StopRecording"]
    XCTAssert(stopRecord.waitForExistence(timeout: TestConstants.timeout))
    stopRecord.tap()
    let playButton = app.buttons["PlayFill"]
    let deleteButton = app.buttons["DeleteRecording"]
    if deleteButton.isHittable {
      sendButton.tap()
    }

    nap(timeout: TestConstants.midTimeout)
    let gifButton = app.buttons[CompanyUI.AccessibilityIdentifier.Messages.gifButton]
    XCTAssert(gifButton.exists)
    gifButton.tap()
    let gifSearch = app.textFields["Search GIPHY"]
    XCTAssert(gifSearch.exists)
    let element = app.children(matching: .window).element(boundBy: 0).scrollViews
    let firstGif = element.children(matching: .other).element.children(matching: .other).element(boundBy: 0)
    XCTAssert(firstGif.waitForExistence(timeout: TestConstants.timeout))
    firstGif.tap()
    let sendGif = app.buttons["Send GIF"].staticTexts["Send GIF"]
    XCTAssert(sendGif.waitForExistence(timeout: TestConstants.timeout))
    sendGif.tap()
    let backArrow = toolbar.buttons[RayaUI.AccessibilityIdentifier.Messages.backArrow]
    XCTAssert(backArrow.waitForExistence(timeout: TestConstants.timeout))
    backArrow.tap()
  }

  // Testing tapping into DR drawer and checking for expiring matches.

  func testConnections() {
    dismissInterrupters()
    nap()
    app.tabBars[RayaUI.AccessibilityIdentifier.TabBar.tabBar].buttons["connections"].tap()

    let drButton = app.otherElements[CompanyUI.AccessibilityIdentifier.Messages.DirectRequestDrawer.directRequests]
    XCTAssert(drButton.waitForExistence(timeout: TestConstants.timeout))
    drButton.tap()

    let toolbar = app.toolbars["Toolbar"]
    XCTAssert(toolbar.waitForExistence(timeout: TestConstants.timeout))

    let backButton = toolbar.buttons["LeftChevron"]
    XCTAssert(backButton.waitForExistence(timeout: TestConstants.timeout))
    backButton.tap()

    let expiringText = app.scrollViews.otherElements.tables.staticTexts["Expiring"]
    if expiringText.isHittable {
      expiringText.tap()
    }
  }

  func testAddingReactions() {
    tappingIntoMessageToSend()
    messageResponseGetItTapGesture()
    let angryEmoji = app.staticTexts["😡"]
    XCTAssert(angryEmoji.waitForExistence(timeout: TestConstants.timeout))
    angryEmoji.tap()
    nap(timeout: TestConstants.midTimeout)
    let bar = app.toolbars["Toolbar"]

    let backArrow = bar.buttons[CompanyUI.AccessibilityIdentifier.Messages.backArrow]
    backArrow.tap()
    let connection = app.tables[CompanyUI.AccessibilityIdentifier.Messages.connections]
    let angryEmojiMsg = connection.cells.containing(.staticText, identifier: "Reaction sent: 😡").staticTexts["Testing"]
    angryEmojiMsg.tap()
    messageResponseGetItTapGesture()

    // Testing adding a more extended emoji, then removing it.

    let moreEmojiButton = app.buttons["ReactionAddIcon"]
    XCTAssert(moreEmojiButton.waitForExistence(timeout: TestConstants.timeout))
    moreEmojiButton.tap()

    nap()
    let tapChildren = app.popovers.collectionViews.children(matching: .cell)
    let reusedSmileyFaceEmoji = tapChildren.element(boundBy: 0).staticTexts["😄"]
    let newSmileyFaceEmoji = app.popovers.collectionViews.staticTexts["😄"]
    let tapSmileyFaceEmoji = tapChildren.element(boundBy: 3).staticTexts["😄"]

    if reusedSmileyFaceEmoji.isHittable {
      reusedSmileyFaceEmoji.tap()
    } else if newSmileyFaceEmoji.isHittable {
      newSmileyFaceEmoji.tap()
    } else if tapSmileyFaceEmoji.isHittable {
      tapSmileyFaceEmoji.tap()
    }
    nap(timeout: TestConstants.midTimeout)
    backArrow.tap()
    let smileEmoji = connection.cells.containing(.staticText, identifier: "Reaction sent: 😄").staticTexts["Testing"]
    smileEmoji.tap()

    messageResponseGetItTapGesture()
    let thumbsUpEmoji = app.staticTexts["👍"]
    thumbsUpEmoji.tap()
    backArrow.tap()
  }

  func testCopyingAndReply() {
    tappingIntoMessageToSend()
    let collectionViews = app.collectionViews
    nap()
    messageResponseGetItTapGesture()
    let copyTextField = app.collectionViews.cells.buttons["Copy"]
    let copyButton = collectionViews.buttons["Copy"]

    if copyButton.isHittable {
      copyButton.tap()
    } else if copyTextField.isHittable {
      copyTextField.tap()
    }
    let sendMessageTextField = app.textViews.staticTexts["Send a message"]
    sendMessageTextField.tap()
    sendMessageTextField.press(forDuration: 0.9)
    let pasteButton = collectionViews.staticTexts["Paste"]
    XCTAssert(pasteButton.waitForExistence(timeout: TestConstants.fifteenTimeout))
    pasteButton.tap()
    XCTAssert(!sendMessageTextField.exists)

    let delete = app.keys["delete"]
      delete.tap()
      delete.tap()
      delete.tap()
      delete.tap()
      delete.tap()
      delete.tap()

    yoMessageTapGesture()
    let replyButton = app.collectionViews.buttons["Reply"]
    replyButton.tap()
    let yoText = app.staticTexts["Yo"]
    let replyingToText = app.staticTexts["Replying to Testing"]
    XCTAssert(replyingToText.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(yoText.waitForExistence(timeout: TestConstants.timeout))
    let tapSpace = app.children(matching: .window).element(boundBy: 0).children(matching: .other)
    let child = tapSpace.element.children(matching: .other).element.children(matching: .other)
    let element4 = child.element.children(matching: .other).element.children(matching: .other).element
    let child4 = element4.children(matching: .other).element.children(matching: .other).element
    let element5 = child4.children(matching: .other).element.children(matching: .other).element.children(matching: .other)
    let child5 = element5.element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other)
    let closeReplyX = child5.element.children(matching: .button).element
    closeReplyX.tap()
    let bar = app.toolbars["Toolbar"]
    let backButton = bar.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
    backButton.tap()
  }

  func testFiltering() {
    dismissInterrupters()
    nap()
    app.tabBars[RayaUI.AccessibilityIdentifier.TabBar.tabBar].buttons["connections"].tap()

    let filterOption = app.tables[CompanyUI.AccessibilityIdentifier.Messages.connections]
    let unreadSelected = filterOption.staticTexts["Unread"]
    let mostRecentFilter = filterOption.staticTexts["Most recent"]

    let filterOptionUnread = app.tables[CompanyUI.AccessibilityIdentifier.Messages.FilterOptions.unreadFilter]
    let unreadFilter = filterOptionUnread.staticTexts["Unread"]
    let tablesQuery = app.tables
    let sortMostRecentCopy = filterOptionUnread.staticTexts["Sort messages from newest to oldest."]
    let unreadMessageCopy = filterOptionUnread.staticTexts["Only show unread messages."]

    if mostRecentFilter.exists {
      mostRecentFilter.tap()
    } else if unreadSelected.exists {
      unreadSelected.tap()
    }

    XCTAssert(sortMostRecentCopy.waitForExistence(timeout: TestConstants.timeout))
    XCTAssert(unreadMessageCopy.waitForExistence(timeout: TestConstants.timeout))
    unreadMessageCopy.tap()
    if unreadSelected.exists {
      unreadSelected.tap()
      sortMostRecentCopy.tap()
    } else if mostRecentFilter.exists {
      sortMostRecentCopy.tap()
    }
  }
}
