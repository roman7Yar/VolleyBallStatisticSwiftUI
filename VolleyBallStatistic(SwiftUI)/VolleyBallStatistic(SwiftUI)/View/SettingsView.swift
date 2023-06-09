//
//  SettingsView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

enum GameType: String, CaseIterable {
    case short = "15"
    case long = "25"
}

struct SettingsView: View {
    
    @ObservedObject var gameVM: GameViewModel
    
    @State private var selectedSegmentIndex = 0
    
    let segmentItems = ["15", "25"]
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.myGreen)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .ignoresSafeArea()
                        .frame(height: 80)
                    
                    Text("Settings")
                        .font(.system(size: 60))
                        .foregroundColor(.myGreen)
                }
                
                Spacer()
                
                VStack {
                    Text("Count to")
                        .foregroundColor(.myWhite)
                    
                    Picker("", selection: $gameVM.selectedType) {
                        ForEach(GameType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .padding(.horizontal, 80)
                
                Text("Last 5 events:")
                    .foregroundColor(.myWhite)
                    .bold()
                
                VStack(alignment: .leading) {
                    ForEach(gameVM.getLastTenEvents(), id: \.self) { event in
                        Text(event)
                            .foregroundColor(.myWhite)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscape
        }
        
    }
    
    
}

struct TeamRow: View {
    
    @ObservedObject var teamVM: TeamViewModel
    
    var body: some View {
        
        HStack(spacing: 40) {
            Text(teamVM.team.name)
                .font(.system(size: 32))
                .foregroundColor(.white)
            
            NavigationLink {
                TeamView(teamViewModel: teamVM)
            } label: {
                Text("Edit")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 40)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
        }
    }
}
