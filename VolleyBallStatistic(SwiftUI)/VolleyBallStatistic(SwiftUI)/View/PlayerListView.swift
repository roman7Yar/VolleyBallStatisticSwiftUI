//
//  PlayerListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

enum ListMode {
    case detail, selecting
}

struct PlayerListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var players = UserDefaultsManager.shared.players
    @State private var searchText = ""
    
    @ObservedObject var viewModel = TeamViewModel()
    
    private var filteredPlayers: [Player] {
        
        if searchText.isEmpty {
            return players
        } else {
            return players.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
        
    }
    
    var listMode = ListMode.detail
    
    var body: some View {
        
        VStack {
            TextField("Search", text: $searchText)
                .padding(.leading, 10)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding([.horizontal, .top])
            
            List(filteredPlayers) { player in
                switch listMode {
                case .detail:
                    NavigationLink {
                        PlayerView(viewModel: PlayerViewModel(player: player))
                    } label: {
                        PlayerRowView(player: player)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            UserDefaultsManager.shared.removePlayer(withId: player.id)
                            players = UserDefaultsManager.shared.players
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                case .selecting:
                    Button {
                        viewModel.addPlayer(player)
                        dismiss()
                    } label: {
                        PlayerRowView(player: player)
                    }
                    .foregroundColor(.primary)
                }
            }
            .onAppear {
                players = UserDefaultsManager.shared.players
            }
            .navigationTitle("Гравці")
            
            .navigationBarItems(trailing: NavigationLink {
                PlayerView(viewModel: PlayerViewModel())
            } label: {
                Image(systemName: "plus.circle")
            })
        }
    }
}

struct PlayerRowView: View {
    
    var player: Player
    
    @State private var pictures = UserDefaultsManager.shared.pictures
    
    var body: some View {
        HStack {
            
            ZStack {
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.myRandomGreen)
                
                Text(player.firstName.firstChar() +
                     player.lastName.firstChar())
                .font(.system(size: 20))
                .foregroundColor(.myWhite)
                .bold()
                
                if let profilePicture = pictures[player.id] {
                    Image(uiImage: UIImage(data: profilePicture)!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            
            VStack(alignment: .trailing) {
                Text(player.fullName)
            }
            
        }
    }    
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
    }
}

