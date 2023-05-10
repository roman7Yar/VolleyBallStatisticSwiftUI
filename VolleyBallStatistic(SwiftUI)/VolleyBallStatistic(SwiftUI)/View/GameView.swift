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
    
    @State private var gameTime = 0.0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    private var isLandscape: Bool { verticalSizeClass == .compact }
    
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
                
                Spacer()
                
                HStack(spacing: 32) {
                    Button {
                        gameVM.removeLastEvent()
                        gameVM.checkIsGameOver()
                    } label: {
                        Image(systemName: "arrow.uturn.left")
                    }
                    
                    Text(String(format: "%.0f:%02.0f", gameTime/60, gameTime.truncatingRemainder(dividingBy: 60)))
                    
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
                .shadow(radius: 12, y: 9)
                .padding(24)
            }
            
            if gameVM.isShowingGameOver {
                Text(gameVM.getWinner())
                    .font(.largeTitle)
                    .foregroundColor(.myWhite)
                    .bold()
            }
        }
        .onReceive(timer) { _ in
            gameTime += 1
        }
        .onAppear {
            gameVM.checkIsGameOver()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AppDelegate.orientationLock = .landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
            
        }
        .onDisappear {
            gameVM.saveGame()
        }
    }
}


struct TapView: View {
    
    @ObservedObject var gameVM: GameViewModel
    
    @State var team: Team
    @State var opponentTeam: Team
    
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
                                    gameVM.checkIsGameOver()
                                }
                            }
                        }
                    }
                } label: {
                    VStack {
                        Text("\(gameVM.getScore(for: team))")
                            .font(.system(size: 150))
                            .foregroundColor(.myWhite)
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Text("tap to score")
                            .foregroundColor(.myWhite)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
