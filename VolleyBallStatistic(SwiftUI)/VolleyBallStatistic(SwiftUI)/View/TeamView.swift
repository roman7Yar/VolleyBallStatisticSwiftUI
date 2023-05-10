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
    @State private var isShowingAlert = false
    
    @State private var errorMessage = ""
    
    @State private var layer = [
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
                        .font(.system(size: 40))
                        .foregroundColor(.myWhite)
                    
                    TextField("Team name", text: $teamViewModel.team.name)
                        .foregroundColor(.clear)
                        .padding(.leading, 100)
                        .tint(.clear)
                        .onChange(of: teamViewModel.team.name) { newName in
                            if newName.count > 16 {
                                teamViewModel.team.name = String(newName.prefix(16))
                            }
                        }
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
                            PlayerListView(viewModel: teamViewModel, listMode: .selecting)
                        }
                    }
                }
                Spacer()
                
                Button {
                    if let error = teamViewModel.checkErrors(teamViewModel.team) {
                        isShowingAlert = true
                        errorMessage = error
                    } else {
                        teamViewModel.saveTeam(teamViewModel.team)
                    }
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
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"),
                          message: Text(errorMessage),
                          dismissButton: .default(Text("OK")))
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
        
        var player: Player
        
        private let pictures = UserDefaultsManager.shared.pictures
        private let circleSize = CGFloat(100)
        
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(.myWhite)
                    
                    Text(player.firstName.firstChar() +
                         player.lastName.firstChar())
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

