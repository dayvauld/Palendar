//
//  PalService.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import Foundation
import Combine

enum PalFetchType {
  case both
  case dogs
  case cats
}

protocol AnimalService {
  func fetchPals(palType: PalFetchType) -> AnyPublisher<Pals, Error>
}

class PalService: AnimalService {
  
  private let baseUrl = "https://api.thedogapi.com"
  private let dogImagePath = "/v1/images/search?limit=10"
  
  private let catBaseUrl = "https://api.thecatapi.com"
  private let catImagePath = "/v1/images/search?limit=10"
  
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func fetchPals(palType: PalFetchType) -> AnyPublisher<Pals, any Error> {
    switch palType {
    case .both:
      return getDogs()
        .zip(getCats())
        .map { $0 + $1 }
        .eraseToAnyPublisher()
    case .dogs:
      return getDogs()
    case .cats:
      return getCats()
    }
  }
  
  func getDogs() -> AnyPublisher<Pals, any Error> {
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
  
  func getCats() -> AnyPublisher<Pals, any Error> {
    let url = URL(string: catBaseUrl.appending(catImagePath))!
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
      .decode(type: [Cat].self, decoder: JSONDecoder())
      .map { $0 as Pals }
      .eraseToAnyPublisher()
  }
}
