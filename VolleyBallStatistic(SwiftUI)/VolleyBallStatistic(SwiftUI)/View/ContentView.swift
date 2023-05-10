//
//  ContentView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 28.03.2023.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationView {
                MenuView()
            }
            .tint(.myYellow)
        } else {
            NavigationView {
                MenuView()
            }
            .accentColor(.myYellow)
        }
    }
    
}

struct MenuView: View {
    
    @State private var selectedSegment = 0
    
    private var size = CGFloat(32)
    
    var body: some View {
        ZStack {
            GreenGradientBG()
            
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .padding(-200)
            
            VStack(spacing: 40) {
                Spacer()
                Text("Volleyball tracker")
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 56))
                    .foregroundColor(.myWhite)
                    .shadow(radius: 12, y: 2)
                
                Spacer()

                NavigationLink {
                    TeamListView()
                } label: {
                    MenuButton(title: "New game")
                }
                
                NavigationLink {
                    GamesListView()
                } label: {
                    MenuButton(title: "Statistics")
                }
                
                NavigationLink {
                    PlayerListView()
                } label: {
                    MenuButton(title: "Players")
                }
                
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
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
            .background(Color.myWhite)
            .foregroundColor(.myGreen)
            .cornerRadius(50)
            .shadow(radius: 12, y: 9)
    }
}

struct GreenGradientBG: View {
    var body: some View {
        LinearGradient(gradient: .init(colors: [.myLightGreen, .myDarkGreen]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}
