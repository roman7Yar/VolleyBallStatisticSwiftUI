//
//  PlayerView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

struct PlayerView: View {
    
    @State private var isShowingPhotoPicker = false
    @State private var avatarImage = UIImage()
    @ObservedObject var viewModel: CreateUserViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.init(red: 0.8, green: 0.8, blue: 0.8))
                Text("\(firstChar(of: viewModel.player.firstName))" +
                     "\(firstChar(of:viewModel.player.lastName))")
                .font(.system(size: 56))
                .bold()
                if let profilePicture = viewModel.player.profilePicture {
                    Image(uiImage: UIImage(data: profilePicture)!)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())

                }
            }
            .onTapGesture { isShowingPhotoPicker = true }
            
            Text("\(viewModel.player.firstName) \(viewModel.player.lastName)")
                .font(.title)
                .bold()
            Form {
                Section(header: Text("Гравець")) {
                    TextField("Імʼя", text: $viewModel.player.firstName)
                    TextField("Прізвище", text: $viewModel.player.lastName)
                }
            }
            
            Button {
                viewModel.player.profilePicture = avatarImage.jpegData(compressionQuality: 1)
                viewModel.savePlayer(viewModel.player)
            } label: {
                Text("Зберегти")
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .accentColor(.red)
            .padding(.vertical, 20)
        }
        .onAppear {
            if (viewModel.player.profilePicture != nil) {
                avatarImage = UIImage(data: viewModel.player.profilePicture!)!
            }
        }

        .navigationTitle("Профіль")
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
