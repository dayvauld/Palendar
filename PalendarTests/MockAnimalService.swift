//
//  MockAnimalService.swift
//  PalendarTests
//
//  Created by David Auld on 2024-09-09.
//

import Foundation
import Combine

@testable import Palendar

class MockAnimalService: AnimalService {
  let throwFailure: Bool
  let mockDelay: Bool
  let mockPalFetch: Pals
  
  static let defaultPals = Pals(
    [
      mockPal(),
      mockPal(),
      mockPal(),
      mockPal(),
      mockPal(),
      mockPal(),
      mockPal(),
    ])
  
  init(throwFailure: Bool = false, mockDelay: Bool = false, mockPalFetch: Pals = MockAnimalService.defaultPals) {
    self.throwFailure = throwFailure
    self.mockDelay = mockDelay
    self.mockPalFetch = mockPalFetch
  }
  
  func fetchPals(palType: PalFetchType) -> AnyPublisher<Pals, any Error> {
    if throwFailure {
      return Fail(error: URLError(.badServerResponse))
        .eraseToAnyPublisher()
    } else {
      return Just(mockPalFetch)
        .delay(for: mockDelay ? 5 : 0, scheduler: RunLoop.main)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }
  
  
  static func mockPal() -> Animal {
    return mockDogPal()
  }
  
  private static func mockDogPal() -> Dog {
    Dog(id: UUID().uuidString, url: "https://cdn2.thedogapi.com/images/N6mcV-D57.jpg")
  }
  
  private static func mockCatPal() -> Cat {
    Cat(id: UUID().uuidString, url: "mockCatUrl")
  }
}
