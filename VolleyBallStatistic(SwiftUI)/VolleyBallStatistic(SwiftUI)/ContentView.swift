//
//  ContentView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 28.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingNextScreen = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                MenuButton(title: "Нова гра")
                MenuButton(title: "Статистика")
                NavigationLink {
                    PlayerListView(players: UserDefaultsManager.shared.players)
                } label: {
                    MenuButton(title: "Гравці")
                }

                            }
            .navigationTitle("Menu")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MenuButton: View {
    
    var title: String
    
    var body: some View {
            Text(title)
                .font(.title)
                .bold()
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(20)
    }
}
