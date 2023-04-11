//
//  PlayerListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

struct PlayerListView: View {
   @State private var players = UserDefaultsManager.shared.players
    
    var body: some View {
        List(players) { player in
            NavigationLink {
                PlayerView(viewModel: CreateUserViewModel(player: player))
            } label: {
                PlayerRowView(player: player)
            }
            .swipeActions {
                Button(role: .destructive) {
                    UserDefaultsManager.shared.remove(with: player.id)
                    players = UserDefaultsManager.shared.players
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .onAppear {
            players = UserDefaultsManager.shared.players
        }
        .navigationTitle("Гравці")
        
        .navigationBarItems(trailing: NavigationLink {
            PlayerView(viewModel: CreateUserViewModel())
        } label: {
            Image(systemName: "plus.circle")
        })
        
//        .navigationBarItems(trailing: Button {
//            UserDefaultsManager.shared.removeLast()
//            players = UserDefaultsManager.shared.players
//        } label: {
//            Image(systemName: "minus.circle")
//        })
    }
}

struct PlayerRowView: View {
    var player: Player
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50
                    )
                    .foregroundColor(.init(red: 0.8, green: 0.8, blue: 0.8))
                Text("\(firstChar(of: player.firstName))" +
                     "\(firstChar(of: player.lastName))")
                .font(.system(size: 20))
                .bold()
                if let profilePicture = player.profilePicture {
                    Image(uiImage: UIImage(data: profilePicture)!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            VStack(alignment: .leading) {
                Text(player.firstName)
                    .font(.headline)
                Text(player.lastName)
                    .font(.headline)
            }
        }
    }
        func firstChar(of string: String) -> String {
            string.isEmpty ? "" : String(string.first!)
    }

}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
    }
}

