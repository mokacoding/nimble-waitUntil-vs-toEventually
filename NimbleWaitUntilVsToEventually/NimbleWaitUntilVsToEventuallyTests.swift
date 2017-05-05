import XCTest
import Nimble

class NimbleWaitUntilVsToEventuallyTests: XCTestCase {

  func testToEventually() {
    let delegate = FakeDelegate()
    let service = AsyncService()
    service.delegate = delegate

    service.callThatResultsInSideEffect()

    expect(delegate.aProperty).toEventually(equal("bazinga"))
  }

  func testAsyncCallNotEffectiveSyntax() {
    let service = AsyncService()

    var callbackValue: String? = .none
    service.doStuff { result in
      switch result {
      case .success(let value): callbackValue = value
      case .error(let error): callbackValue = "\(error)"
      }
    }

    expect(callbackValue).toEventually(equal("bazinga"))
  }

  func testAsyncCallResult() {
    let service = AsyncService()

    waitUntil { done in
      service.doStuff { result in
        switch result {
        case .success(let value):
          expect(value) == "bazinga"
          done()
        case .error:
          fail("Expected call to doStuff to suceeded, but it failed")
        }
      }
    }
  }
}

class FakeDelegate: AsyncServiceDelegate {
  var aProperty: String = "unset"
}
