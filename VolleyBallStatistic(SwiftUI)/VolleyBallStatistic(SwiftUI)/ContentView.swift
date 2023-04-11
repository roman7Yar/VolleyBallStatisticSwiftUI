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
    var body: some View {
        NavigationView {
            ZStack {
                GreenGradientBG()
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .global).minX
                    let minY = proxy.frame(in: .global).minY
                    let maxX = proxy.frame(in: .global).maxX
                    let height = proxy.size.height

                    Image("upBall").position(x: minX + 32, y: minY - 124)
                    Image("middleBall").position(x: minX, y: height * 0.65)
                    Image("downBall").position(x: maxX + 20, y: height)
                }
                VStack(spacing: 40) {
                    Text("Volleyball tracker")
                        .bold()
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Spacer()
                    CustomSegmentedControl(preselectedIndex: $selectedSegment2, options: ["score", "statistic", "extended"])
                        .padding(.horizontal, 8)
                    MenuButton(title: "Нова гра")
                    MenuButton(title: "Статистика")
                    NavigationLink {
                        PlayerListView()
                    } label: {
                        MenuButton(title: "Гравці")
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
                .cornerRadius(20)
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
                        .fill(Color.gray.opacity(0.2))
                    Rectangle()
                        .fill(color)
                        .cornerRadius(10)
                        .padding(8)
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
        .frame(height: 72)
        .cornerRadius(10)
    }
}
