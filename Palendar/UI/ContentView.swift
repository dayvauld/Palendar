//
//  ContentView.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel: ContentViewModel
  
  var body: some View {
    ScrollView {
      LazyVStack {
        switch viewModel.state {
        case .loading:
          ProgressView()
        case .loaded(let pals):
          ForEach(pals, id: \.id) { pal in
            dogCard(dog: pal)
          }
        case .error:
          Text("error")
        }
      }
    }
    .padding()
    .onAppear {
      viewModel.getPals()
    }
  }
  
  func dogCard(dog: Animal) -> some View {
    AsyncImage(
      url: URL(string: dog.url),
      transaction: Transaction(animation: .easeInOut(duration: 0.3))) { phase in
        switch phase {
        case .empty:
          ProgressView()
        case .success(let image):
          image
            .resizable()
            .scaledToFill()
            .clipped()
        default: // placeholder if error
          Color.gray
        }
      }
  }
}

#Preview {
  ContentView(viewModel: ContentViewModel(palService: PalService()))
}
