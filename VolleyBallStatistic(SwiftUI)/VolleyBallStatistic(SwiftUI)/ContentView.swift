//
//  ContentView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 28.03.2023.
//

import SwiftUI

enum VolleyBallSegment: String, CaseIterable {
    case score, statistic, extended
}

struct ContentView: View {
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.init(red: 1, green: 0.7782, blue: 0.1961, alpha: 1)
    }
    @State private var selectedSegment: VolleyBallSegment = .score
    @State private var selectedSegment2 = 0

    @State var isShowingNextScreen = false
    var size = CGFloat(32)
    var body: some View {
        NavigationView {
            ZStack {
                GreenGradientBG()
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(-200)
                VStack {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .frame(width: size, height: size)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: size, height: size)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .ignoresSafeArea()
                    Spacer()
                }
                VStack(spacing: 40) {
                    Spacer()
                    Text("Volleyball tracker")
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
//                    Spacer()
                    CustomSegmentedControl(preselectedIndex: $selectedSegment2, options: ["score", "statistic", "extended"])
                        .padding(.horizontal, 8)
                    MenuButton(title: "New game")
                    MenuButton(title: "Statistics")
                    NavigationLink {
                        PlayerListView()
                    } label: {
                        MenuButton(title: "Players")
                    }
                    Spacer(minLength: 100)
                }
            }
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
                .background(Color.white)
                .foregroundColor(.init(red: 0.149, green: 0.6471, blue: 0.3961))
                .cornerRadius(50)
                .shadow(radius: 12, y: 9)
    }
}

struct GreenGradientBG: View {
    var body: some View {
        LinearGradient(gradient: .init(colors: [.init(red: 0.1843, green: 0.6039, blue: 0.3529), .init(red: 0, green: 0.8392, blue: 0.5843)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color = Color.init(red: 1, green: 0.7782, blue: 0.1961)
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.init(red: 0.1725, green: 0.5255, blue: 0.3412))
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
                        .foregroundColor(.white)
                )
            }
        }
        .frame(height: 80)
        .cornerRadius(10)
    }
}
