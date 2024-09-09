//
//  ContentViewModel.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
  enum State {
    case loading
    case loaded(Pals)
    case error
  }
  
  @Published var state: State = .loading
  
  private var palService: AnimalService
  
  private var subscriptions = Set<AnyCancellable>()
  
  init(palService: AnimalService) {
    self.palService = palService
  }
  
  func getPals() {
    self.state = .loading
    palService.fetchPals()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        // check if error
        // state = .error
      } receiveValue: { [weak self] pals in
        self?.state = .loaded(pals)
      }
      .store(in: &subscriptions)
  }
}
