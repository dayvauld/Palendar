//
//  PalService.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import Foundation
import Combine

protocol AnimalService {
  func fetchPals() -> AnyPublisher<Pals, Error>
}

class PalService: AnimalService {
  
  private let baseUrl = "https://api.thedogapi.com"
  private let dogImagePath = "/v1/images/search?limit=10"
  
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func fetchPals() -> AnyPublisher<Pals, any Error> {
    let url = URL(string: baseUrl.appending(dogImagePath))!
    return urlSession.dataTaskPublisher(for: url)
      .map {
#if DEBUG // Print JSON response in debug mode
        if let jsonString = String(data: $0.data, encoding: .utf8) {
          print(jsonString)
        } else {
          print("Failed to convert Data to JSON String")
        }
#endif
        return $0.data
      }
      .decode(type: [Dog].self, decoder: JSONDecoder())
      .map { $0 as Pals }
      .eraseToAnyPublisher()
  }
}
