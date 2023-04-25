//
//  PlayerView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

struct PlayerView: View {
    @State private var pictures = UserDefaultsManager.shared.pictures
    @State private var isShowingPhotoPicker = false
    @State private var avatarImage = UIImage()
    @ObservedObject var viewModel: CreateUserViewModel
    @State private var circleSize = CGFloat(180)
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.myGreen)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    Circle()
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(.myWhite)
                    Text("\(firstChar(of: viewModel.player.firstName))" +
                         "\(firstChar(of: viewModel.player.lastName))")
                    .font(.system(size: 90))
                    .foregroundColor(.myLightGreen)
                    .bold()
                    if let profilePicture = pictures[viewModel.player.id] {
                        Image(uiImage: UIImage(data: profilePicture)!)
                            .resizable()
                            .frame(width: circleSize, height: circleSize)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .frame(width: circleSize, height: circleSize)
                            .clipShape(Circle())
                        
                    }
                }
                .onTapGesture { isShowingPhotoPicker = true }
                
                Text("\(viewModel.player.firstName) \(viewModel.player.lastName)")
                    .font(.title)
                    .foregroundColor(.myWhite)
                    .bold()
                VStack {
                    TextField("Імʼя", text: $viewModel.player.firstName)
                        .padding(4)
                        .background(Color.myWhite)
                        .cornerRadius(4)
                        .padding(.horizontal, 32)
                    TextField("Прізвище", text: $viewModel.player.lastName)
                        .padding(4)
                        .background(Color.myWhite)
                        .cornerRadius(4)

                        .padding(.horizontal, 32)
                }
//                .foregroundColor(Color.clear)
                .frame(maxHeight: 160)
                Spacer()
                Button {
                    pictures[viewModel.player.id] = avatarImage.jpegData(compressionQuality: 1)
                    UserDefaultsManager.shared.pictures = pictures
                    viewModel.savePlayer(viewModel.player)
                } label: {
                    Text("Save")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                .accentColor(.red)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            if (pictures[viewModel.player.id] != nil) {
                avatarImage = UIImage(data: pictures[viewModel.player.id]!)!
            }
        }

        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(avatarImage: $avatarImage)
        }
        
    }
    
    func firstChar(of string: String) -> String {
        string.isEmpty ? "" : String(string.first!)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(viewModel: CreateUserViewModel())
    }
}
