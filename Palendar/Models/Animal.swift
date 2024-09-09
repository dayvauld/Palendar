//
//  Animal.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import Foundation

typealias Pals = [Animal]

protocol Animal: Codable {
  var id: String { get }
  var url: String { get }
}

struct Dog: Animal {
  var id: String
  var url: String
}

struct Cat: Animal {
  var id: String
  var url: String
}
