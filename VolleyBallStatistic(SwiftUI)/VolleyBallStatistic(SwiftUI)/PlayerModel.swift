//
//  UserModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

//    var players: [Player]
    
struct Player: Identifiable, Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var profilePicture: Data?
}

class CreateUserViewModel: ObservableObject {
    
    @Published var player: Player
    
    init() {
        player = Player(id: UUID(), firstName: "", lastName: "")
    }
    
    init(player: Player) {
        self.player = player
    }
    
    func savePlayer(_ player: Player) {
        UserDefaultsManager.shared.addPlayer(player)
        // Виконай код для збереження юзера
    }
}
