//
//  PlayerView.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

struct PlayerView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var pictures = UserDefaultsManager.shared.pictures
    @State private var isShowingPhotoPicker = false
    @State private var isShowingAlert = false
    @State private var avatarImage = UIImage()
    @State private var circleSize = CGFloat(180)
    @State private var errorMessage = ""

    
    @ObservedObject var viewModel: PlayerViewModel
    
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
                    
                    Text(viewModel.player.firstName.firstChar() +
                         viewModel.player.lastName.firstChar())
                    .font(.system(size: 90))
                    .foregroundColor(.myRandomGreen)
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
                    
                    TextField("First Name", text: $viewModel.player.firstName)
                        .padding(4)
                        .background(Color.myWhite)
                        .foregroundColor(.myBlack)
                        .cornerRadius(4)
                        .padding(.horizontal, 32)
                        .onChange(of: viewModel.player.firstName) { newName in
                            let trimmedName = newName.trimmingCharacters(in: .whitespaces)
                            if trimmedName.count > 16 {
                                viewModel.player.firstName = String(trimmedName.prefix(16))
                            } else {
                                viewModel.player.firstName = trimmedName
                            }
                        }

                    TextField("Last Name", text: $viewModel.player.lastName)
                        .padding(4)
                        .background(Color.myWhite)
                        .foregroundColor(.myBlack)
                        .cornerRadius(4)
                        .padding(.horizontal, 32)
                        .onChange(of: viewModel.player.lastName) { newName in
                            let trimmedName = newName.trimmingCharacters(in: .whitespaces)
                            if trimmedName.count > 16 {
                                viewModel.player.lastName = String(trimmedName.prefix(16))
                            } else {
                                viewModel.player.lastName = trimmedName
                            }
                        }
                }
                .frame(maxHeight: 160)
                
                Spacer()
                
                Button {
                    if let error = viewModel.checkErrors(viewModel.player) {
                        isShowingAlert = true
                        errorMessage = error
                    } else {
                        pictures[viewModel.player.id] = avatarImage.jpegData(compressionQuality: 1)
                        UserDefaultsManager.shared.pictures = pictures
                        viewModel.savePlayer(viewModel.player)
                        dismiss()
                    }
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
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"),
                          message: Text(errorMessage),
                          dismissButton: .default(Text("OK")))
                }

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
    
}

struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerView(viewModel: PlayerViewModel())
    }
    
}
