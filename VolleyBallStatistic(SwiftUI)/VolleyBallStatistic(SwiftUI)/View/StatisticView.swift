//
//  StatisticView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct StatisticView: View {
    @State var game: StatisticManager
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.myGreen)
            ScrollView {
                VStack(spacing: 64) {
                    Text("Statistic")
                        .font(.largeTitle)
                        .foregroundColor(.myWhite)
                        .bold()
                    TeamsView(teams: game.teams)
                    EventsView(manager: game, events: game.events)
                    HStack {
                        Text("Longest rally")
                            .font(.title2)
                            .foregroundColor(.myWhite)
                        Spacer()
                        Text(game.getLongestTime())
                            .font(.title2)
                            .foregroundColor(.myWhite)
                            .bold()
                    }
                }
                .padding()
            }
        }
    }
    struct TeamsView: View {
        var teams: [Team]
        var body: some View {
            VStack {
                Text("Teams")
                    .font(.title)
                    .foregroundColor(.myWhite)
                    .bold()
                HStack(alignment: .top, spacing: 0) {
                    ForEach(teams) { team in
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                Text(team.name)
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            ForEach(team.players) { player in
                                PlayerRowView(player: player)
                            }
                        }
                        .padding()
                    }
                }
                .background(Color.myWhite)
                .cornerRadius(20)
            }
        }
    }
    
    struct EventsView: View {
        var manager: StatisticManager
        var events: [GameEvent]
        var body: some View {
            VStack {
                Text("Game Events")
                    .font(.title)
                    .foregroundColor(.myWhite)
                    .bold()
                    .padding()
                HStack {
                    Text(manager.game.team1.name)
                        .font(.title2)
                        .foregroundColor(.myWhite)
                        .bold()
                    Spacer()
                    Text(manager.game.team2.name)
                        .font(.title2)
                        .foregroundColor(.myWhite)
                        .bold()
                }
                ForEach(events, id: \.date) { event in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.myWhite)
                            .cornerRadius(10)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(event.player?.fullName ?? "-")
                                    .bold()
                                HStack {
                                    Text(event.type.description)
                                    Spacer()
                                    Text(manager.getTime(for: event))
                                }
                            }
                            .foregroundColor(manager.game.team1.id == event.team.id ? Color.myBlack : Color.clear)
                            .padding(4)
                            HStack(spacing: 2) {
                                let score = manager.getScore(for: event)
                                Text(score[0])
                                    .font(.title2)
                                    .foregroundColor(event.team.id == manager.teams[0].id ? Color.myGreen : Color.myDarkGray)
                                    .bold()
                                Text(":")
                                    .font(.title2)
                                    .foregroundColor(Color.myDarkGray)
                                    .bold()
                                Text(score[1])
                                    .font(.title2)
                                    .foregroundColor(event.team.id == manager.teams[1].id ? Color.myGreen : Color.myDarkGray)
                                    .bold()
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(event.player?.fullName ?? "-")
                                    .bold()
                                HStack {
                                    Text(event.type.description)
                                    Spacer()
                                    Text(manager.getTime(for: event))
                                }
                            }
                            .foregroundColor(manager.game.team2.id == event.team.id ? Color.myBlack : Color.clear)
                            .padding(4)
                        }
                    }
                    //                    .padding(.vertical, 4)
                }
            }
        }
    }
}

//struct StatisticView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticView(game: )
//    }
//}
