//
//  TeamModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.04.2023.
//

import Foundation

struct Team: Identifiable, Codable {
    let id: UUID
    var name: String
    var players = [Player]()
}

class GameModel: ObservableObject {
    @Published var teams: [TeamViewModel] = []
    
    func selectTeam(_ team: TeamViewModel) {
        if teams.count < 2 {
            teams.append(team)
        } else {
            teams.removeFirst()
            teams.append(team)
        }
    }
  
    func deselectTeam(_ team: TeamViewModel) {
        var count = 0
        teams.forEach { item in
            if item.team.id == team.team.id {
                teams.remove(at: count)
            }
            count += 1
        }
    }

}

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
            if i.id == player.id { team.players.remove(at: count) }
            count += 1
        })
    }
    
//    func getIndex(for player: Player) -> Int {
//        var result = 0
//        var count = 0
//        team.players.forEach({ i in
//            if i.id == player.id { result = count }
//            count += 1
//        })
//        return result
//    }
    
    func addPlayer(_ player: Player) {
                
        guard team.players.count < 6 else { return }
        var count = 0
        team.players.forEach({ i in
            if i.id == player.id { team.players.remove(at: count) }
            count += 1
        })
        team.players.append(player)
    }
    
    
    func saveTeam(_ team: Team) {
        UserDefaultsManager.shared.addTeam(team)
    }
    
}
