//
//  TeamView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct TeamView: View {
    @ObservedObject var teamViewModel: TeamViewModel
    
    @State private var isPresented = false

    var layer = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.myGreen)
            VStack {
                ZStack {
                    Text(teamViewModel.team.name)
                        .font(.system(size: 60))
                        .foregroundColor(.myWhite)
                    TextField("Team name", text: $teamViewModel.team.name)
                        .foregroundColor(.clear)
                        .padding(.leading, 100)
                }
                .padding()
                LazyVGrid(columns: layer) {
                    if let players = teamViewModel.team.players {
                        ForEach(players) { player in
                            Button {
                                teamViewModel.removePlayer(player)
                            } label: {
                                PlayerItem2(player: player)
                            }
                        }
                    }
                    if teamViewModel.team.players.count < 6 {
                        Button {
                            isPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(8)
                                .background(Color.myYellow)
                                .foregroundColor(.myWhite)
                                .cornerRadius(50)
                                .shadow(radius: 12, y: 4)

                        }
                        .padding(.bottom, 48)
                        .sheet(isPresented: $isPresented) {
                            PlayerListView(listMode: .selecting, viewModel: teamViewModel)
                        }
                    }
                }
                Spacer()
                Button {
                    teamViewModel.saveTeam(teamViewModel.team)
                } label: {
                    Text("Save")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .shadow(radius: 12, y: 9)
                }

            }
            .padding()
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        
    }
    
    struct PlayerItem2: View {
        private let pictures = UserDefaultsManager.shared.pictures
        private let circleSize = CGFloat(100)
        var player: Player
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(.myWhite)
                    Text("\(firstChar(of: player.firstName))" +
                         "\(firstChar(of: player.lastName))")
                        .font(.system(size: 50))
                        .foregroundColor(.myRandomGreen)
                    if let profilePicture = pictures[player.id] {
                        Image(uiImage: UIImage(data: profilePicture)!)
                            .resizable()
                            .frame(width: circleSize, height: circleSize)
                            .clipShape(Circle())
                    }
                }
                Text("\(player.firstName)")
                    .font(.system(size: 20))
                    .foregroundColor(.myWhite)
                Text("\(player.lastName)")
                    .font(.system(size: 20))
                    .foregroundColor(.myWhite)
            }
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(teamViewModel: TeamViewModel())
    }
}

