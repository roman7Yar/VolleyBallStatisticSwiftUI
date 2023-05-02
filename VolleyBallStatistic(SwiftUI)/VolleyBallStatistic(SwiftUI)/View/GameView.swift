//
//  GameView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 21.04.2023.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @ObservedObject var gameVM: GameViewModel
    
    var isLandscape: Bool { verticalSizeClass == .compact }
    
    var body: some View {
        ZStack {
            if isLandscape {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.init(red: 39/255, green: 111/255, blue: 67/255))
                    HStack(spacing: 8) {
                        TapView(gameVM: gameVM, team: gameVM.game.team1, opponentTeam: gameVM.game.team2)
                        TapView(gameVM: gameVM, team: gameVM.game.team2, opponentTeam: gameVM.game.team1)
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(Color.myGreen)
                }
            }
            VStack {
                HStack(spacing: 20) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.myDarkGray)
                            .padding(.bottom)
                            .padding(8)
                    }
                    
//                    NavigationLink {
//                        SettingsView()
//                    } label: {
//                        Image(systemName: "gearshape.fill")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.myDarkGray)
//                            .padding(.bottom)
//                    }
                    Spacer()
                }
                .padding(8)
                Spacer()
            }
            .ignoresSafeArea()
            VStack {
                Spacer()
                HStack(spacing: 32) {
                    Button {
                        gameVM.removeLastEvent()
                    } label: {
                        Image(systemName: "arrow.uturn.left")
                    }
                    Text("00:00")
                    NavigationLink {
                        SettingsView(gameVM: gameVM)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .padding()
                .background(Color.myWhite)
                .foregroundColor(Color.myDarkGray)
                .cornerRadius(10)
                .padding(24)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AppDelegate.orientationLock = .landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
            
        }
        .onDisappear {
//            AppDelegate.orientationLock = .portrait
            gameVM.saveGame()
        }
        .navigationBarBackButtonHidden()
    }
}

//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView(game: Game())
//    }
//}

struct TapView: View {
    @ObservedObject var gameVM: GameViewModel

    @State var team: Team
    @State var opponentTeam: Team
//    @State var score = 0
    var body: some View {
        
            ZStack {
                Rectangle()
                    .foregroundColor(.myGreen)
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.myWhite)
                            .ignoresSafeArea()
                        Text(team.name)
                            .font(.system(size: 60))
                            .foregroundColor(.myGreen)
                            .padding(.top)
                    }
                    Menu {
                        Menu("opponent error") {
                            ForEach(ErrorEventType.allCases, id: \.self) { errorType in
                                Menu(errorType.rawValue) {
                                    ForEach(opponentTeam.players) { player in
                                        Button("\(player.firstName) \(player.lastName)") {
                                            gameVM.newEvent(.init(type: .error(errorType), team: team, player: player))
                                        }
                                    }
                                    Button("-") {
                                        gameVM.newEvent(.init(type: .error(errorType), team: team, player: nil))
                                    }
                                }
                            }
                        }
                        ForEach(WinEventType.allCases, id: \.self) { winType in
                            Menu(winType.rawValue) {
                                ForEach(team.players) { player in
                                    Button("\(player.firstName) \(player.lastName)") {
                                        gameVM.newEvent(.init(type: .win(winType), team: team, player: player))
                                    }
                                }
                            }
                        }
                    } label: {
                        VStack {
                            Text("\(gameVM.getScore(for: team))")
//                            Text("\(score)")
                                .font(.system(size: 150))
                                .foregroundColor(.myWhite)
                                .padding(.vertical)
                            Spacer()
                            Text("tap to score")
                                .foregroundColor(.myWhite)
//                                .padding(.bottom, 32)
                        }
                }
            }
        }
//            .onTapGesture {
//                score += 1
//            }
        .ignoresSafeArea()
    }
}
