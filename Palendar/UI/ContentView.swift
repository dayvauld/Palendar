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
        case .loaded(let days):
          ForEach(days, id: \.id) { day in
            palCard(for: day)
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
  
  func palCard(for day: PalendarDay) -> some View {
    ZStack(alignment: .top) {
      LinearGradient(
        colors: [.black, .clear],
        startPoint: .top, endPoint: .bottom)
        .opacity(0.8)
        .edgesIgnoringSafeArea(.all)
        .frame(height: 100)
      
      VStack(alignment: .leading) {
        Text(day.date.formatted(date: .complete, time: .omitted))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        if day.isToday {
          Text("TODAY")
            .fontDesign(.serif)
            .font(.largeTitle)
            .foregroundColor(.white)
        }
        
        Spacer()
      }
      .padding()
    }
    .frame(maxWidth: .infinity)
    .frame(height: max(300, UIScreen.main.bounds.height / 3))
    .background(
      AsyncImage(
        url: URL(string: day.pal.url),
        transaction: Transaction(animation: .easeInOut(duration: 0.3))) { phase in
          switch phase {
          case .empty:
            ProgressView()
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
              .clipped()
          default:
            Color.gray
          }
        }
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  ContentView(viewModel: ContentViewModel(palService: PalService()))
}
