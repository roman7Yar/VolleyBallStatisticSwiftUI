//
//  TeamListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct TeamListView: View {
    
    @State private var teams = UserDefaultsManager.shared.teams
    @ObservedObject var game = GameModel()
    @ObservedObject var teamViewModel = TeamViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.myGreen)
            ScrollView {
                Text("Teams")
                    .font(.system(size: 60))
                    .foregroundColor(.myWhite)
                ForEach(teams) { team in
                    TeamItem(teamViewModel: TeamViewModel(team: team), game: game)
                        .contextMenu {
                            Button("Delete") {
                                UserDefaultsManager.shared.removeTeam(withId: team.id)
                                teams = UserDefaultsManager.shared.teams
                            }
                        }
                        .swipeActions {
                            Button {
                                UserDefaultsManager.shared.removeTeam(withId: team.id)
                                teams = UserDefaultsManager.shared.teams
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
                NavigationLink {
                    TeamView(teamViewModel: TeamViewModel())
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(Color.myYellow)
                        .foregroundColor(.myWhite)
                        .cornerRadius(50)
                        .shadow(radius: 12, y: 4)
                }
                .padding()
            }
            if game.teams.count == 2 {
                VStack {
                    Spacer()
                    NavigationLink {
                        GameView(gameVM: GameViewModel(teams: game.teams))
                    } label: {
                        Text("Play")
                            .font(.system(size: 30))
                            .padding()
                            .padding(.horizontal, 20)
                            .background(Color.myYellow)
                            .foregroundColor(.myWhite)
                            .cornerRadius(8)
                            .shadow(radius: 12, y: 9)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AppDelegate.orientationLock = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                teams = UserDefaultsManager.shared.teams
            }
        }
    }
}

struct TeamItem: View {
    
    @ObservedObject var teamViewModel: TeamViewModel
    @ObservedObject var game: GameModel
    
    @State var isSelected = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(teamViewModel.team.name)
                .font(.system(size: 30))
                .foregroundColor(.myWhite)
            ZStack {
                Rectangle()
                    .frame(minWidth: 300, minHeight: 160)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .shadow(radius: 12, y: 9)
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            if let players = teamViewModel.team.players {
                                ForEach(players) { player in
                                    PlayerItem(player: player)
                                }
                            }
                        }
                    }
                    HStack {
                        NavigationLink {
                            TeamView(teamViewModel: TeamViewModel(team: teamViewModel.team))
                        } label: {
                            Text("Change")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.yellow)
                                .cornerRadius(8)
                        }
                        Spacer()
                        Button {
                            isSelected.toggle()
                            if isSelected {
                                game.selectTeam(teamViewModel)
                            } else {
                                game.deselectTeam(teamViewModel)
                            }
                        } label: {
                            Image(systemName: game.chekSelection(teamViewModel) ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(game.chekSelection(teamViewModel) ? .myYellow : .myDarkGray)
                        }
                    }
                    .padding([.horizontal, .bottom], 20)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct PlayerItem: View {
    private let pictures = UserDefaultsManager.shared.pictures
    private let circleSize = CGFloat(64)
    var player: Player
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(.myRandomGreen)
                Text("\(firstChar(of: player.firstName))" +
                     "\(firstChar(of: player.lastName))")
                    .font(.system(size: 30))
                    .foregroundColor(.myWhite)
                if let profilePicture = pictures[player.id] {
                    Image(uiImage: UIImage(data: profilePicture)!)
                        .resizable()
                        .frame(width: circleSize, height: circleSize)
                        .clipShape(Circle())
                }
            }
            Text(player.firstName)
            Text(player.lastName)
        }
        .foregroundColor(.myBlack)
        .padding(.vertical)
        .padding(.horizontal, 4)
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
    }
}

