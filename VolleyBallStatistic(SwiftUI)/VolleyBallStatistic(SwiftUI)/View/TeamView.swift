//
//  TeamView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct TeamView: View {
    @State var teamName = "Team 1"
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
                    Text(teamName)
                        .font(.system(size: 60))
                        .foregroundColor(.myWhite)
                    TextField("Team name", text: $teamName)
                        .foregroundColor(.clear)
                        .padding(.leading, 100)
                }
                .padding()
                LazyVGrid(columns: layer) {
                    PlayerItem2()
                    PlayerItem2()
                    PlayerItem2()
                    PlayerItem2()
                    PlayerItem2()
                    NavigationLink {
                        PlayerListView()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(8)
                            .background(Color.myYellow)
                            .foregroundColor(.myWhite)
                            .cornerRadius(50)
                    }
                    .padding(.bottom, 48)
                    
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        
    }
    
    struct PlayerItem2: View {
        
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.myWhite)
                    Text("N")
                        .font(.system(size: 50))
                        .foregroundColor(.myGreen)
                }
                Text("Name")
                    .font(.system(size: 30))
                    .foregroundColor(.myWhite)
            }
        }
        
    }

}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}

