//
//  PalendarTests.swift
//  PalendarTests
//
//  Created by David Auld on 2024-09-09.
//

import XCTest
import Combine

@testable import Palendar

final class PalendarTests: XCTestCase {
  var subscriptions: Set<AnyCancellable>!
  
  override func setUp() {
    subscriptions = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    subscriptions = nil
    super.tearDown()
  }
  
  func test_fetchPals() {
    let expectation = XCTestExpectation(description: "Fetch all pals")
    let mockAnimalService = MockAnimalService(throwFailure: false)
    let viewModel = PalendarViewModel(palService: mockAnimalService)
    viewModel.$state
      .sink { state in
        switch state {
        case .loaded(let pals):
          XCTAssertNotNil(pals)
          expectation.fulfill()
        default:
          break
        }
      }
      .store(in: &subscriptions)
    
    viewModel.getPals()
    wait(for: [expectation], timeout: 5)
  }
  
  func test_loadingState() {
    let mockAnimalService = MockAnimalService(throwFailure: false, mockDelay: true)
    let viewModel = PalendarViewModel(palService: mockAnimalService)
    viewModel.getPals()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      XCTAssertEqual(viewModel.state, .loading)
    }
  }

  func test_errorState() {
    let mockAnimalService = MockAnimalService(throwFailure: true)
    let viewModel = PalendarViewModel(palService: mockAnimalService)
    
    XCTAssertEqual(viewModel.state, .loading)
    viewModel.getPals()
    
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .error)
    }
  }
}
