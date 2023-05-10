//
//  PlayerViewModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 09.05.2023.
//

import SwiftUI

class PlayerViewModel: ObservableObject {
    
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
    func checkErrors(_ player: Player) -> String? {
        if player.fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Player need name"
        }
        return nil
    }
}
