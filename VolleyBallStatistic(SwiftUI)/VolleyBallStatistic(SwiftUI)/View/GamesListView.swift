//
//  GamesListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct GamesListView: View {
    @State private var games = UserDefaultsManager.shared.games

    var body: some View {
        List(games, id: \.start) { game in
            NavigationLink {
                StatisticView(game: .init(game: game))
            } label: {
                GameRowView(game: game)
            }
        }
    }
}

struct GameRowView: View {
    var game: Game
    var body: some View {
        HStack {
            Text("\(game.team1.name) - \(game.team2.name)")
            Divider()
            Text(game.start.formatted())
        }
    }
}
struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView()
    }
}
