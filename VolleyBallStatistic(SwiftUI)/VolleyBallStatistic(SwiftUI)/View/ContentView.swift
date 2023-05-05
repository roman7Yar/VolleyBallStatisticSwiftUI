//
//  ContentView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 28.03.2023.
//

import SwiftUI
import UIKit

//enum VolleyBallSegment: String, CaseIterable {
//    case score, statistic, extended
//}

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
    var description: String {
        switch selectedSegment {
        case 0:
            return "Only score"
        case 1:
            return "Score with team statistic"
        case 2:
            return "Score with team and players statistic"
        default:
            return ""
        }
    }
    var size = CGFloat(32)

    var body: some View {
        ZStack {
            GreenGradientBG()
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .padding(-200)
//            VStack {
//                HStack {
//                    Image(systemName: "info.circle.fill")
//                        .resizable()
//                        .frame(width: size, height: size)
//                        .foregroundColor(.myWhite)
//                    Spacer()
//                    NavigationLink {
//                        SettingsView()
//                    } label: {
//                        Image(systemName: "gearshape.fill")
//                            .resizable()
//                            .frame(width: size, height: size)
//                            .foregroundColor(.myWhite)
//                    } // TODO: fix on iphone7
//
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 24)
//                //                    .ignoresSafeArea()
//                Spacer()
//            }
            VStack(spacing: 40) {
                Spacer()
                Text("Volleyball tracker")
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 56))
                    .foregroundColor(.myWhite)
                    .shadow(radius: 12, y: 2)

//                CustomSegmentedControl(preselectedIndex: $selectedSegment, options: ["score", "statistic", "extended"])
//                    .padding(.horizontal, 8)
//                Text(description)
//                    .padding(.vertical, -24)
//                    .foregroundColor(.myWhite)
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

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color = Color.myYellow
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.mySegmentBG)
                    Rectangle()
                        .fill(color)
                        .cornerRadius(10)
                        .padding(12)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselectedIndex = index
                                }
                            }
                }
                .overlay(
                    Text(options[index])
                        .font(.title2)
                        .bold()
                        .foregroundColor(.myWhite)
                )
            }
        }
        .frame(height: 80)
        .cornerRadius(10)
    }
}

