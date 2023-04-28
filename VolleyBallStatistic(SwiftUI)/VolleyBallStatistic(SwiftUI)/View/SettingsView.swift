//
//  SettingsView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import SwiftUI

struct SettingsView: View {
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
                    Picker("", selection: $selectedSegmentIndex) {
                        ForEach(0..<segmentItems.count) { index in
                            Text(segmentItems[index])
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .padding(.horizontal, 80)
                TeamRow()
                TeamRow()
                Spacer()
            }
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscape
        }
        
    }


}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct TeamRow: View {
    var body: some View {
        HStack(spacing: 40) {
            Text("Team 1")
                .font(.system(size: 32))
                .foregroundColor(.white)
//            NavigationLink {
//                TeamView()
//            } label: {
                Text("Edit")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 40)
                    .background(Color.yellow)
                    .cornerRadius(8)
//                
//            }
            
        }
    }
}
