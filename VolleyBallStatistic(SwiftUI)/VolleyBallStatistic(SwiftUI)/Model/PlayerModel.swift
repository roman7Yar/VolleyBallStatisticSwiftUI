//
//  UserModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

    
struct Player: Identifiable, Codable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
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
    }
}
