//
//  TeamListView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

//class TeamSelection: ObservableObject {
//    @Published var isSelected = false
//
////    var selectedTeamsCount: Int {
////            return teams.filter { $0.isSelected }.count
////        }
//
//}


struct TeamListView: View {
    
//    @EnvironmentObject var teamSelection: TeamSelection
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.myGreen)
            ScrollView {
                Text("Teams")
                    .font(.system(size: 60))
                    .foregroundColor(.myWhite)
                TeamItem()
                TeamItem()
                TeamItem()
                TeamItem()
                TeamItem()
                NavigationLink {
                    TeamView()
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
//            if isSelected {
//                NavigationLink {
//                    GameView()
//                } label: {
//                    Text("Play")
//                        .padding()
//                        .background(Color.myYellow)
//                        .foregroundColor(.myWhite)
//                        .cornerRadius(8)
//                }
//
//            }

        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
//        .environmentObject(teamSelection)
    }
}


struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
    }
}

struct PlayerItem: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.mint)
                Text("NS")
                    .font(.system(size: 20))
                    .foregroundColor(.myWhite)
            }
            Text("Name")
                .foregroundColor(.myBlack)
            Text("Surname")
                .foregroundColor(.myBlack)

        }
        .padding(.vertical)
    }
}

struct TeamItem: View {// TODO: ObservableObject
//    @ObservedObject var teamSelection = TeamSelection()
    @State private var isSelected = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Team 1")
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
                            PlayerItem()
                            PlayerItem()
                            PlayerItem()
                            PlayerItem()
                            PlayerItem()
                            PlayerItem()
                        }
                    }
                    HStack {
                        NavigationLink {
                            TeamView()
                        } label: {
                            Text("Change")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.yellow)
                                .cornerRadius(8)

                        }
                        Spacer()
                        Image(systemName: isSelected ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(isSelected ? .myYellow : .myDarkGray)
                            .onTapGesture {
                                isSelected.toggle()
                            }
                    }
                    .padding(20)
                }

            }
        }
        .padding()
    }
}
