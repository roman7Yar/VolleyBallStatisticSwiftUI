//
//  GamesListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct GamesListView: View {
    
    @State private var games = UserDefaultsManager.shared.games
    @State private var filteredGames = UserDefaultsManager.shared.games
    @State private var selectedDate = Date()
    
    var body: some View {
        
        VStack {
            
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date])
                .padding(.horizontal)
            
            List(filteredGames, id: \.start) { game in
                
                NavigationLink {
                    StatisticView(game: .init(game: game))
                } label: {
                    GameRowView(game: game)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        UserDefaultsManager.shared.removeGame(withDate: game.start)
                        games = UserDefaultsManager.shared.games
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
                
            }
        }
        .onChange(of: selectedDate) { _ in
            updateFilteredGames()
        }
        .onAppear {
            games = UserDefaultsManager.shared.games
            filteredGames = UserDefaultsManager.shared.games
        }
    }
    
    private func updateFilteredGames() {
        filteredGames = games.filter { $0.start.isSameDay(as: selectedDate) }
    }
    
}

struct GameRowView: View {
    
    var game: Game
    
    var body: some View {
        
        HStack {
            Text(game.start.formatted())
                .font(.headline)
                .foregroundColor(.gray)
            
            Divider()
            
            Text("\(game.team1.name) - \(game.team2.name)")
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView()
    }
}
