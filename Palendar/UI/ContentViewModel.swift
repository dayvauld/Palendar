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
    case loaded([PalendarDay])
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
        guard let self = self else { return }
        // map array of dogs to array of PalendarDays
        let palendarWeek = self.mapDates(pals: pals)
        self.state = .loaded(palendarWeek)
      }
      .store(in: &subscriptions)
  }
  
  func mapDates(pals: Pals) -> [PalendarDay] {
    let currentWeekday = Calendar.current.component(.weekday, from: Date.now)
    var availablePals = pals.shuffled()
    var palendarDays: [PalendarDay] = []
    
    for index in 1...7 {
      guard let palToAssign = availablePals.first else { break }
      let dayOffset = index - currentWeekday
      guard let day = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date.now) else { continue }
      
      let calendarDay = PalendarDay(
        id: palToAssign.id,
        date: day,
        pal: palToAssign
      )
      
      palendarDays.append(calendarDay)
      availablePals.removeFirst()
    }
    
    palendarDays.sort { $0.date < $1.date }
    return palendarDays
  }
}
