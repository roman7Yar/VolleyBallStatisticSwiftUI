//
//  TeamViewModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 09.05.2023.
//

import Foundation

class TeamViewModel: ObservableObject {
    
    @Published var team: Team
    
    init() {
        team = Team(id: UUID(), name: "Team 1")
    }
    
    init(team: Team) {
        self.team = team
    }
    
    
    func removePlayer(_ player: Player) {
        
        var count = 0
        
        team.players.forEach({ i in
            if i.id == player.id {
                team.players.remove(at: count)
            }
            
            count += 1
            
        })
    }
    
    func addPlayer(_ player: Player) {
        
        guard team.players.count < 6 else {
            return
        }
        
        var count = 0
        
        team.players.forEach({ i in
            if i.id == player.id {
                team.players.remove(at: count)
            }
            
            count += 1
        })
        
        team.players.append(player)
        
    }
    
    func saveTeam(_ team: Team) {
        if !team.name.isEmpty || team.players.count > 1 {
            UserDefaultsManager.shared.addTeam(team)
        }
    }
    
    func checkErrors(_ team: Team) -> String? {
        if team.name.isEmpty {
            return "team must have a name"
        } else if team.players.count < 2 {
            return "need more players"
        }
        return nil
    }
    
}
