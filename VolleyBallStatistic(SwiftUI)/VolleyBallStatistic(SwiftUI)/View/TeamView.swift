//
//  TeamView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct TeamView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var teamViewModel: TeamViewModel
    
    @State private var isPresented = false
    @State private var isShowingAlert = false
    @State private var isEditing = false

    
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
                HStack {
                    Text(teamViewModel.team.name)
                        .font(.system(size: 40))
                        .foregroundColor(.myWhite)
                        .alert("Enter team name", isPresented: $isEditing) {
                            TextField("Enter team name", text: $teamViewModel.team.name)
                                .onChange(of: teamViewModel.team.name) { newName in
                                    let trimmedName = newName.trimmingCharacters(in: .whitespaces)
                                    if trimmedName.count > 16 {
                                        teamViewModel.team.name = String(trimmedName.prefix(16))
                                    } else {
                                        teamViewModel.team.name = trimmedName
                                    }
                                }
                        }
                    
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.myWhite)
                    }
                    
                }
                .padding()
                
                LazyVGrid(columns: layer) {
                    if let players = teamViewModel.team.players {
                        ForEach(0..<6) { index in
                            if index < players.count {
                                let player = players[index]
                                Button {
                                    teamViewModel.removePlayer(player)
                                } label: {
                                    PlayerItem2(player: player)
                                }
                            } else {
                                NavigationLink {
                                    PlayerListView(viewModel: teamViewModel, listMode: .selecting)
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
                            }
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
                        dismiss()
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

