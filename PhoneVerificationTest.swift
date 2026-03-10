import Foundation
import XCTest
import enum CompanyUI.AccessibilityIdentifier

class PhoneVerificationTest: NoLogInTestsBase {

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = true
    self.executionTimeAllowance = 900.0
  }

  // MARK: - Tests

  func testFirstThirdCountryCode() throws {
    validateCountryCodes(with: generatePhoneNumbers())
  }

  func testSecondThirdCountryCode() throws {
    validateCountryCodes(with: generatePhoneNumbers2())
  }

  func testLastThirdCountryCode() throws {
    validateCountryCodes(with: generatePhoneNumbers3())
  }

  // MARK: - Helpers

  /// validates a dictionary of country / phone numbers
  private func validateCountryCodes(with countryNumbers: [String: [String: String]]) {
    app.buttons[CompanyUI.AccessibilityIdentifier.SplashScreen.apply].tap()
    nap()
    let nextButton = app.buttons["submitButton.PhoneNumberVerification"]

    for (countryName, details) in countryNumbers {
      if let (countryCode, phoneNumber) = details.first {
        XCTContext.runActivity(named: "Testing for country: \(countryName)") { _ in
          app.buttons["countryCodeButton.PhoneNumberVerification"].tap()
          if app.tables[AccessibilityIdentifier.PhoneNumberVerification.countryPickerTable].exists {
            app.tables[AccessibilityIdentifier.PhoneNumberVerification.countryPickerTable].cells[countryName].tap()
            let textField = app.textFields.firstMatch
            textField.tap()
            textField.typeText(phoneNumber)

            if nextButton.exists {
              nap()
              // Just a note, this should not fail the whole test, just log the error
              XCTAssertTrue(nextButton.isEnabled,
                            "Next button disabled! Verification failed for country: \(countryName), code: \(countryCode), number: \(phoneNumber)"
              )
            } else {
              XCTFail("Next button not found! Verification failed for country: \(countryName), code: \(countryCode), number: \(phoneNumber)")
            }
            textField.clearText()
          }
        }
      }
    }
  }

  /// parses country -> phone number json data
  private func parsePhoneNumbers(from data: Data) -> [String: [String: String]] {
    var countryNumbers: [String: [String: String]] = [:]
    do {
      let countries = try JSONDecoder().decode([String: [String: String]].self, from: data)
      for (countryName, details) in countries {
        countryNumbers[countryName] = details
      }
    } catch {
      XCTFail("Failed to decode JSON: \(error.localizedDescription)")
    }
    return countryNumbers
  }

  // MARK: - Test Phone Numbers / Countries

  private func generatePhoneNumbers() -> [String: [String: String]] {
    parsePhoneNumbers(from: Data(
      """
      {
          "Afghanistan": {"93": "799317979"},
          "Åland Islands": {"358": "1817100"},
          "Albania": {"355": "682123456"},
          "Algeria": {"213": "661234567"},
          "American Samoa": {"1": "6846331234"},
          "Andorra": {"376": "312345"},
          "Angola": {"244": "923123456"},
          "Anguilla": {"1": "2644971234"},
          "Antigua & Barbuda": {"1": "2685621234"},
          "Argentina": {"54": "91123456789"},
          "Armenia": {"374": "91234567"},
          "Aruba": {"297": "5612345"},
          "Ascension Island": {"247": "66234"},
          "Australia": {"61": "412345678"},
          "Austria": {"43": "664123456"},
          "Azerbaijan": {"994": "501234567"},
          "Bahamas": {"1": "2423021234"},
          "Bahrain": {"973": "36001234"},
          "Bangladesh": {"880": "1712345678"},
          "Barbados": {"1": "2462501234"},
          "Belarus": {"375": "291234567"},
          "Belgium": {"32": "491234567"},
          "Belize": {"501": "6221234"},
          "Benin": {"229": "95123456"},
          "Bermuda": {"1": "4412911234"},
          "Bhutan": {"975": "17123456"},
          "Bolivia": {"591": "71234567"},
          "Bosnia & Herzegovina": {"387": "61123456"},
          "Botswana": {"267": "72123456"},
          "Brazil": {"55": "11912345678"},
          "British Virgin Islands": {"1": "2844941234"},
          "Brunei": {"673": "7123456"},
          "Bulgaria": {"359": "871234567"},
          "Burkina Faso": {"226": "70123456"},
          "Burundi": {"257": "79123456"},
          "Cambodia": {"855": "12345678"},
          "Cameroon": {"237": "671234567"},
          "Canada": {"1": "4169671111"},
          "Cape Verde": {"238": "9912345"},
          "Caribbean Netherlands": {"599": "3181234"},
          "Cayman Islands": {"1": "3459161234"},
          "Central African Republic": {"236": "72123456"},
          "Chad": {"235": "66234567"},
          "Chagos Archipelago": {"246": "3873334"},
          "Chile": {"56": "225830148"},
          "Christmas Island": {"61": "412345678"},
          "Cocos (Keeling) Islands": {"61": "891234567"},
          "Colombia": {"57": "3211234567"},
          "Comoros": {"269": "3212345"},
          "Congo - Brazzaville": {"242": "222829322"},
          "Congo - Kinshasa": {"243": "991234567"},
          "Cook Islands": {"682": "71234"},
          "Costa Rica": {"506": "83123456"},
          "Côte d’Ivoire": {"225": "0777775353"},
          "Croatia": {"385": "981234567"},
          "Cuba": {"53": "51234567"},
          "Curaçao": {"599": "95123456"},
          "Cyprus": {"357": "96123456"},
          "Czechia": {"420": "601234567"},
          "Denmark": {"45": "20123456"},
          "Djibouti": {"253": "77123456"},
          "Dominica": {"1": "7674481234"},
          "Dominican Republic": {"1": "8296505600"},
          "Ecuador": {"593": "991234567"},
          "Egypt": {"20": "1012345678"},
          "El Salvador": {"503": "70123456"},
          "Equatorial Guinea": {"240": "333477737"},
          "Eritrea": {"291": "7323456"},
          "Estonia": {"372": "51234567"},
          "Eswatini": {"268": "76123456"},
          "Ethiopia": {"251": "911234567"},
          "Falkland Islands": {"500": "22100"},
          "Faroe Islands": {"298": "211234"},
          "Fiji": {"679": "7012345"},
          "Finland": {"358": "401234567"},
          "France": {"33": "612345678"},
          "French Guiana": {"594": "694201234"},
          "French Polynesia": {"689": "87123456"},
          "Gabon": {"241": "6123456"},
          "Gambia": {"220": "3012345"},
          "Georgia": {"995": "555123456"}
      }
      """.utf8)
    )
  }

  func generatePhoneNumbers2() -> [String: [String: String]] {
    parsePhoneNumbers(from: Data(
      """
      {
          "Germany": {"49": "15123456789"},
          "Ghana": {"233": "241234567"},
          "Gibraltar": {"350": "57123456"},
          "Greece": {"30": "6912345678"},
          "Greenland": {"299": "221234"},
          "Grenada": {"1": "4734031234"},
          "Guadeloupe": {"590": "690123456"},
          "Guam": {"1": "6716474000"},
          "Guatemala": {"502": "51234567"},
          "Guernsey": {"44": "1481234567"},
          "Guinea": {"224": "621234567"},
          "Guinea-Bissau": {"245": "443067733"},
          "Guyana": {"592": "6512345"},
          "Haiti": {"509": "34123456"},
          "Honduras": {"504": "91234567"},
          "Hungary": {"36": "201234567"},
          "Iceland": {"354": "6112345"},
          "India": {"91": "9812345678"},
          "Indonesia": {"62": "812345678"},
          "Iran": {"98": "9123456789"},
          "Iraq": {"964": "7912345678"},
          "Ireland": {"353": "851234567"},
          "Isle of Man": {"44": "1624687039"},
          "Israel": {"972": "37599759"},
          "Italy": {"39": "3123456789"},
          "Jamaica": {"1": "8765123456"},
          "Japan": {"81": "9012345678"},
          "Jersey": {"44": "1534123456"},
          "Jordan": {"962": "791234567"},
          "Kazakhstan": {"7": "7012345678"},
          "Kenya": {"254": "768098821"},
          "Kiribati": {"686": "30012322"},
          "Kosovo": {"383": "44123456"},
          "Kuwait": {"965": "50123456"},
          "Kyrgyzstan": {"996": "501234567"},
          "Laos": {"856": "54543233"},
          "Latvia": {"371": "21234567"},
          "Lebanon": {"961": "70123456"},
          "Lesotho": {"266": "50123456"},
          "Liberia": {"231": "770123456"},
          "Libya": {"218": "912345678"},
          "Liechtenstein": {"423": "654833381"},
          "Lithuania": {"370": "61234567"},
          "Luxembourg": {"352": "621234567"},
          "Madagascar": {"261": "321234567"},
          "Malawi": {"265": "991234567"},
          "Malaysia": {"60": "121234567"},
          "Maldives": {"960": "7712345"},
          "Mali": {"223": "70123456"},
          "Malta": {"356": "99123456"},
          "Marshall Islands": {"692": "2351234"},
          "Martinique": {"596": "696201234"},
          "Mauritania": {"222": "22123456"},
          "Mauritius": {"230": "0012345678990"},
          "Mayotte": {"262": "269601331"},
          "Mexico": {"52": "5512345678"},
          "Micronesia": {"691": "3501234"},
          "Moldova": {"373": "62123456"},
          "Monaco": {"377": "612345678"},
          "Mongolia": {"976": "88123456"},
          "Montenegro": {"382": "67123456"},
          "Montserrat": {"1": "6644912345"},
          "Morocco": {"212": "612345678"},
          "Mozambique": {"258": "821234567"},
          "Myanmar (Burma)": {"95": "92123456"},
          "Namibia": {"264": "811234567"},
          "Nauru": {"674": "5551234"},
          "Nepal": {"977": "9812345678"},
          "Netherlands": {"31": "612345678"},
          "New Caledonia": {"687": "751234"},
          "New Zealand": {"64": "211234567"},
          "Nicaragua": {"505": "81234567"},
          "Niger": {"227": "92123456"},
          "Nigeria": {"234": "7012345678"},
          "Niue": {"683": "6282"},
          "North Korea": {"850": "1912345678"},
          "North Macedonia": {"389": "70123456"},
          "Northern Mariana Islands": {"1": "6702345678"},
          "Norway": {"47": "41234567"},
          "Oman": {"968": "92123456"},
          "Pakistan": {"92": "3012345678"}
      }
      """.utf8)
    )
  }

  func generatePhoneNumbers3() -> [String: [String: String]] {
    parsePhoneNumbers(from: Data(
      """
      {
          "Palau": {"680": "2771234"},
          "Palestinian Territories": {"970": "599123456"},
          "Panama": {"507": "61234567"},
          "Papua New Guinea": {"675": "3113339"},
          "Paraguay": {"595": "541232322"},
          "Peru": {"51": "912345678"},
          "Philippines": {"63": "9171234567"},
          "Poland": {"48": "501234567"},
          "Portugal": {"351": "912345678"},
          "Puerto Rico": {"1": "7872232233"},
          "Qatar": {"974": "33123456"},
          "Réunion": {"262": "692123456"},
          "Romania": {"40": "712345678"},
          "China mainland": {"86": "13323222323"},
          "Hong Kong": {"852": "62123456"},
          "Macao": {"853": "62123456"},
          "Taiwan": {"886": "912345678"},
          "Russia": {"7": "9123456789"},
          "Rwanda": {"250": "731234567"},
          "Samoa": {"685": "7222323"},
          "San Marino": {"378": "886377"},
          "São Tomé & Príncipe": {"239": "9912345"},
          "Saudi Arabia": {"966": "501234567"},
          "Senegal": {"221": "771234567"},
          "Serbia": {"381": "601234567"},
          "Seychelles": {"248": "2512345"},
          "Sierra Leone": {"232": "76123456"},
          "Singapore": {"65": "81234567"},
          "Sint Maarten": {"1": "7215801234"},
          "Slovakia": {"421": "912345678"},
          "Slovenia": {"386": "40123456"},
          "Solomon Islands": {"677": "21009"},
          "Somalia": {"252": "61123456"},
          "South Africa": {"27": "821234567"},
          "South Korea": {"82": "1023456789"},
          "South Sudan": {"211": "921234567"},
          "Spain": {"34": "612345678"},
          "Sri Lanka": {"94": "712345678"},
          "St. Barthélemy": {"590": "690123456"},
          "St. Helena": {"290": "22100"},
          "St. Kitts & Nevis": {"1": "8694651234"},
          "St. Lucia": {"1": "7585841234"},
          "St. Martin": {"590": "690123456"},
          "St. Pierre & Miquelon": {"508": "551234"},
          "St. Vincent & Grenadines": {"1": "7844561234"},
          "Sudan": {"249": "911234567"},
          "Suriname": {"597": "7412345"},
          "Svalbard & Jan Mayen": {"47": "79012345"},
          "Sweden": {"46": "701234567"},
          "Switzerland": {"41": "791234567"},
          "Syria": {"963": "933123456"},
          "Tajikistan": {"992": "917123456"},
          "Tanzania": {"255": "621234567"},
          "Thailand": {"66": "912345678"},
          "Timor-Leste": {"670": "77212345"},
          "Togo": {"228": "90123456"},
          "Tokelau": {"690": "4567888"},
          "Tonga": {"676": "37232"},
          "Trinidad & Tobago": {"1": "8682911234"},
          "Tristan da Cunha": {"290": "0023674444444"},
          "Tunisia": {"216": "20123456"},
          "Türkiye": {"90": "5312345678"},
          "Turkmenistan": {"993": "65123456"},
          "Turks & Caicos Islands": {"1": "6492311234"},
          "Tuvalu": {"688": "901288"},
          "U.S. Virgin Islands": {"1": "3407741234"},
          "Uganda": {"256": "483483334"},
          "Ukraine": {"380": "671234567"},
          "United Arab Emirates": {"971": "501234567"},
          "United Kingdom": {"44": "7912345678"},
          "United States": {"1": "2025550123"},
          "Uruguay": {"598": "91234567"},
          "Uzbekistan": {"998": "901234567"},
          "Vanuatu": {"678": "5765799"},
          "Vatican City": {"39": "0669883135"},
          "Venezuela": {"58": "4123456789"},
          "Vietnam": {"84": "912345678"},
          "Wallis & Futuna": {"681": "721234"},
          "Western Sahara": {"212": "522623888"},
          "Yemen": {"967": "712345678"},
          "Zambia": {"260": "971234567"},
          "Zimbabwe": {"263": "712345678"}
      }
      """.utf8)
    )
  }
}

extension XCUIElement {
  func clearText() {
    guard let stringValue = self.value as? String else {
      XCTFail("Failed to get the current text value")
      return
    }
    self.tap()
    XCUIApplication().buttons["Clear text"].tap()
    // let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
    // self.typeText(deleteString)
  }
}
