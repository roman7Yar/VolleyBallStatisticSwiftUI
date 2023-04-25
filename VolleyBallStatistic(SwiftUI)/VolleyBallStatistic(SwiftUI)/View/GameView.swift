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
    
    var isLandscape: Bool { verticalSizeClass == .compact }
    
    var body: some View {
        ZStack {
            if isLandscape {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.init(red: 39/255, green: 111/255, blue: 67/255))
                    HStack {
                        TapView()
                        TapView()
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(Color.green)
                    //                    Text("").font(.system(size: 30))
                    //                        .foregroundColor(.white)
                    //                        .padding()
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

                    }
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.myDarkGray)
                    }
                    Spacer()
                }
                .padding(8)
                Spacer()
            }
            .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AppDelegate.orientationLock = .landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
            
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
        }
        .navigationBarBackButtonHidden()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct TapView: View {
    @State var score = 0
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
                    Text("Team 1")
                        .font(.system(size: 60))
                        .foregroundColor(.myGreen)
                }
                Text("\(score)")
                    .font(.system(size: 150))
                    .foregroundColor(.myWhite)
                    .padding(.vertical)
                Spacer()
                Text("tap to score")
                    .foregroundColor(.myWhite)
            }
        }.gesture(
            TapGesture()
                .onEnded { _ in
                    score += 1
                }
                .simultaneously(with:
                                    DragGesture()
                    .onEnded { value in
                        if value.translation.height > 0 {
                            score -= 1
                        }
                    }
                               )
        )
    }
}
