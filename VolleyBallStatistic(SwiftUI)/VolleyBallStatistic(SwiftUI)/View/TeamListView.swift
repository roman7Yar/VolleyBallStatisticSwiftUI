//
//  TeamListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI
//
//class TeamSelection: ObservableObject {
//    @Published var isSelected = false
//
//    var selectedTeamsCount: Int {
//        return UserDefaultsManager.shared.teams.filter { $0.isSelected }.count
//        }
//
//}


struct TeamListView: View {
    
//    @EnvironmentObject var teamSelection: TeamSelection

    @State private var teams = UserDefaultsManager.shared.teams
//    @State private var refresh = false
    @ObservedObject var game = GameModel()
    @ObservedObject var teamViewModel = TeamViewModel()
    
//    var selectedTeamsCount =  {
//        didSet {
//            if
//        }
//        }

    
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
                        .onTapGesture {
                            print(team.name)
//                            team.isSelected.toggle()
                        }
                        .contextMenu {
                            Button("Delete") {
                                UserDefaultsManager.shared.removeTeam(withId: team.id)
                                teams = UserDefaultsManager.shared.teams
                            }

                        }
                }
               
                NavigationLink {
                    TeamView(teamViewModel: TeamViewModel()
                    )
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(Color.myYellow)
                        .foregroundColor(.myWhite)
                        .cornerRadius(50)
                }
                .padding()
            }
            if game.teams.count == 2 {
                VStack {
                    Spacer()
                    NavigationLink {
                        GameView()
                    } label: {
                        Text("Play")
                            .font(.system(size: 30))
                            .padding()
                            .padding(.horizontal, 20)
                            .background(Color.myYellow)
                            .foregroundColor(.myWhite)
                            .cornerRadius(8)
                            .padding()
                    }
                }
            }

        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            teams = UserDefaultsManager.shared.teams
        }
    }
}


struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
    }
}

struct PlayerItem: View {
    private let pictures = UserDefaultsManager.shared.pictures
    private let circleSize = CGFloat(40)
    var player: Player
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(.mint)
                Text("\(firstChar(of: player.firstName))" +
                     "\(firstChar(of: player.lastName))")
                    .font(.system(size: 20))
                    .foregroundColor(.myWhite)
                if let profilePicture = pictures[player.id] {
                    Image(uiImage: UIImage(data: profilePicture)!)
                        .resizable()
                        .frame(width: circleSize, height: circleSize)
                        .clipShape(Circle())
                }

            }
            Text(player.firstName)
                .foregroundColor(.myBlack)
            Text(player.lastName)
                .foregroundColor(.myBlack)

        }
        .padding(.vertical)
    }
}


struct TeamItem: View {
    @ObservedObject var teamViewModel: TeamViewModel
    @ObservedObject var game: GameModel
    
    @State private var isSelected = false

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
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
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
                                game.addTeam(teamViewModel)
                            } else {
                                game.deleteTeam(teamViewModel)
                            }
                        } label: {
                            Image(systemName: isSelected ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(isSelected ? .myYellow : .myDarkGray)

                        }

                            
                    }
                    .padding(20)
                }

            }
        }
        .padding()
    }
}
