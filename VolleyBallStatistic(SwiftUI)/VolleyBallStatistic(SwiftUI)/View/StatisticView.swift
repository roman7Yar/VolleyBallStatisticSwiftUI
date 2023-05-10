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
                    
                    TeamSummaryView(manager: game)
                    
                    PlayerSummaryView(teamIndex: 0, manager: game)
                    
                    PlayerSummaryView(teamIndex: 1, manager: game)
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
                                    .foregroundColor(.myBlack)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            ForEach(team.players) { player in
                                PlayerRowView(player: player)
                                    .foregroundColor(.myBlack)
                            }
                        }
                        .padding()
                    }
                }
                .background(Color.myWhite)
                .cornerRadius(20)
                .shadow(radius: 12, y: 9)
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
                    
                    Text(manager.totalScore())
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
                            .shadow(radius: 12, y: 4)
                        }
                    }
                }
            }
        }
    }
    struct TeamSummaryView: View {
        
        @State private var selectedTeamIndex = 0
        
        var manager: StatisticManager
        
        var body: some View {
            VStack {
                Text("Teams Summary")
                    .font(.title)
                    .foregroundColor(.myWhite)
                    .bold()
                
                VStack {
                    Picker("Select a team", selection: $selectedTeamIndex) {
                        ForEach(0..<manager.teams.count) { index in
                            Text(manager.teams[index].name)
                                .bold()
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.top, .horizontal])
                    
                    HStack(alignment: .top) {
                        VStack {
                            Text("Success")
                                .bold()
                                .padding(.bottom, 8)
                            
                            ForEach(manager.getSuccess(for: manager.teams[selectedTeamIndex]), id: \.0) { success in
                                
                                HStack {
                                    Text(success.0)
                                    Spacer()
                                    Text(success.1)
                                }
                            }
                        }
                        .padding()
                        VStack {
                            Text("Oppoennt Errors")
                                .bold()
                                .padding(.bottom, 8)
                            
                            ForEach(manager.getErrors(for: manager.teams[selectedTeamIndex]), id: \.0) { error in
                                HStack {
                                    Text(error.0)
                                    Spacer()
                                    Text(error.1)
                                }
                            }
                        }
                        .padding()
                    }
                    .foregroundColor(.myBlack)
                }
                .background(Color.myWhite)
                .cornerRadius(20)
                .shadow(radius: 12, y: 9)
            }
        }
    }
    
    struct PlayerSummaryView: View {
        
        @State private var index = 0
        
        let teamIndex: Int
        
        var manager: StatisticManager
        
        private var currentPlayer: Player {
            manager.teams[teamIndex].players[index]
        }
        
        var body: some View {
            VStack {
                Text(manager.teams[teamIndex].name)
                    .font(.title2)
                    .foregroundColor(.myWhite)
                    .bold()
                
                VStack {
                    HStack {
                        Button {
                            if index > 0 {
                                index -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.myWhite)
                                .padding()
                                .background(Color.myLightGreen)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(currentPlayer.fullName)
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            if index < manager.teams[teamIndex].players.count - 1 {
                                index += 1
                            }
                        } label: {
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.myWhite)
                                .padding()
                                .background(Color.myLightGreen)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        ForEach(manager.getPlayerSummary(for: currentPlayer), id: \.0) { element in
                            HStack {
                                Text(element.0)
                                    .padding(.leading, 80)
                                
                                Spacer()
                                
                                Text(element.1)
                                    .padding(.trailing, 80)
                            }
                        }
                    }
                    .padding(.bottom)
                }
                .background(Color.myWhite)
                .foregroundColor(.myBlack)
                .cornerRadius(20)
                .shadow(radius: 12, y: 9)
            }
        }
    }
}
