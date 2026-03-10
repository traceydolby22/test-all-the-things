import Foundation
import XCTest
import enum CompanyUI.AccessibilityIdentifier

final class StackConsumables: StackSwipingActions {

  override var performLoginLogout: Bool {
   return false
  }
  // Some information on this test if you're looking to run it.
  // This test can only be run on a physical device as apple sims do not have capablility(2023) to purchase.
  // 1. The user can have a skip the wait they purchased through previous settings consumable test,
  // and I recommend it as the 'TestsStack' test case will go through and purchase a skip the wait in stack.
  // 2. The user can have a connected user in the stack, it's usually the first one as it's easiest to set
  // up the like using admin commands.
  // 3. The user may hit easy tiger while in the stack, this isn't a requirement, but the function will run

  func testRedesignStackConsumables() {

    nap(timeout: TestConstants.timeout)
    tappingIntoStack()
    while !eosCarouselSkipTheWait.exists {
      NSLog("Skip the wait", false)
      nap()
      checkForConnectedView()
      checkPurchaseEasyTiger()
      swipingLike()
    }
    if eosCarouselSkipTheWait.isHittable {
      checkSkipTheWaitPurchase()
    }
  }
}
