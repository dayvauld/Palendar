//
//  ContentView.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import SwiftUI

struct PalendarView: View {
  @ObservedObject var viewModel: PalendarViewModel
  @State var fetchDogs: Bool = true
  @State var fetchCats: Bool = true
  
  var fetchType: PalFetchType {
    if fetchDogs && fetchCats {
      return .both
    } else if fetchDogs {
      return .dogs
    } else {
      return .cats
    }
  }
  
  var body: some View {
    VStack {
        switch viewModel.state {
        case .loading:
          ProgressView()
        case .loaded(let days):
          ScrollView {
            LazyVStack {
              ForEach(days, id: \.id) { day in
                palCard(for: day)
              }
            }
          }
        case .error:
          errorView
        }
    }
    .padding(.horizontal, 16)
    .navigationTitle("Palendar 🐾")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack(spacing: 0) {
          Button(action: {
            if fetchType == .dogs {
              fetchCats = true
            }
            
            fetchDogs.toggle()
            viewModel.getPals(palType: fetchType)
          }) {
            Image(systemName: fetchDogs ? "dog.circle.fill" : "dog.circle")
              .foregroundStyle(fetchDogs ? .mint : .red)
          }
          
          Button(action: {
            if fetchType == .cats {
              fetchDogs = true
            }
            
            fetchCats.toggle()
            viewModel.getPals(palType: fetchType)
          }) {
            Image(systemName: fetchCats ? "cat.circle.fill" : "cat.circle")
              .foregroundStyle(fetchCats ? .mint : .red)
          }
        }
      }
    }
    .onAppear {
      viewModel.getPals(palType: fetchType)
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
  
  var errorView: some View {
    VStack {
      Image(systemName: "exclamationmark.triangle")
      Text("Your pals are out on a walk, try back later")
    }
  }
}

#Preview("Palendar") {
  NavigationView {
    PalendarView(viewModel: PalendarViewModel(palService: PalService()))
  }
}

#Preview("Error State") {
  let mockedPalService = MockAnimalService(throwFailure: true)
  return NavigationView {
    PalendarView(
      viewModel: PalendarViewModel(palService: mockedPalService))
  }
}

#Preview("Delayed State") {
  let mockedPalService = MockAnimalService(mockDelay: true)
  return NavigationView {
    PalendarView(
      viewModel: PalendarViewModel(palService: mockedPalService))
  }
}
