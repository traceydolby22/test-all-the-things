import XCTest

class NegativeLoginToSignUpTests: NoLogInTestsBase {

  func testNegativePathLogIn() throws {
    let key0 = app.keys["0"]
    let key1 = app.keys["1"]
    let key2 = app.keys["2"]
    let key3 = app.keys["3"]
    let key4 = app.keys["4"]
    let key5 = app.keys["5"]
    let key6 = app.keys["6"]
    let key7 = app.keys["7"]
    let key8 = app.keys["8"]
    let key9 = app.keys["9"]

    let login = app.staticTexts["Log in"]
    XCTAssertTrue(login.waitForExistence(timeout: TestConstants.fifteenTimeout))
    login.tap()
    nap()

    key8.tap()
    key2.tap()
    key8.tap()
    key2.tap()
    key3.tap()
    key2.tap()
    key3.tap()
    key0.tap()
    key5.tap()
    key3.tap()

    nap()
    let nextButton = app.staticTexts["Next"]
    nextButton.tap()
    nap()
    key4.tap()
    key9.tap()
    key1.tap()
    key6.tap()
    key7.tap()

    nap()
    let invalidCode = app.staticTexts["Invalid code."]
    nextButton.tap()
    XCTAssertTrue(invalidCode.waitForExistence(timeout: TestConstants.timeout))
  }
}
