//
//  PalendarDay.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import Foundation

struct PalendarDay {
  let id: String
  let date: Date
  let pal: Animal

  var isToday: Bool {
    Calendar.current.isDateInToday(date)
  }
}
