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

struct Team: Identifiable, Codable {
    let id: UUID
    var name: String
    var players = [Player]()
//    var isSelected = false
}

class TeamViewModel: ObservableObject {
    
    @Published var team: Team
    
    @Published var teamsToPlay = [Team]()
    

    init() {
        team = Team(id: UUID(), name: "Team 1")
    }
    
    init(team: Team) {
        self.team = team
    }
    
    func selectTeam() {
        if teamsToPlay.count < 2 {
            teamsToPlay.append(team)
        } else {
            teamsToPlay.removeFirst()
            teamsToPlay.append(team)
        }
        print(teamsToPlay.count)
    }
    
    func deselectTeam() {
        var count = 0
        teamsToPlay.forEach { item in
            if item.id == team.id {
                teamsToPlay.remove(at: count)
                count += 1
            }
        }
        print(teamsToPlay.count)
    }
    
    func removePlayer(_ player: Player) {
        var count = 0
        team.players.forEach({ i in
            if i.id == player.id { team.players.remove(at: count) }
            count += 1
        })
    }
    
    func getIndex(for player: Player) -> Int {
        var result = 0
        var count = 0
        team.players.forEach({ i in
            if i.id == player.id { result = count }
            count += 1
        })
        return result
    }
    
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
//        print(team.isSelected)
    }
    
}


struct Game: Codable {
    var start = Date()
    let team1: Team
    let team2: Team
    var events: [GameEvent]
}

struct GameEvent: Codable {
    let type: EventType
    let team: TeamType
    let player: UUID?
    var date = Date()
    
    var winnerTeam: TeamType {
        switch type {
        case .win:
            return team
        case .lose:
            return team.oposit
        }
    }
}

enum TeamType: Codable {
    case first, second
    
    var oposit: TeamType {
        switch self {
        case .first: return .second
        case .second: return .first
        }
    }
}

enum EventType: Codable, Equatable {
    case win(WinEventType)
    case lose(LoseEventType)
}

enum WinEventType: Codable {
    case attack, block, ace
}
enum LoseEventType: Codable {
    case double, line, serve, net, technical, other // mistakes
}

class GameManager {
    var events = [GameEvent]()
    


}

class StatisticManager {
    var events = [GameEvent]()
    let game: Game
    
    init(game: Game) {
        self.game = game
        events = game.events
        
    }
    
    func getLongestTime() -> Double {
        guard events.count > 2 else { return 0 }
        
        var longestTimeInterval: TimeInterval = 0.0 // найдовший проміжок часу
        var previousDate: Date?
        
        for event in events {
            if let previousDate = previousDate {
                let timeInterval = event.date.timeIntervalSince(previousDate)
                if timeInterval > longestTimeInterval {
                    longestTimeInterval = timeInterval
                }
            }
            previousDate = event.date

        }
        let result = longestTimeInterval / 60
        return result
    }
    
    func getMain(for team: TeamType) -> [String : Int] {
      
        let attacks = calculate(eventType: .win(.attack), for: team)
        let blocks = calculate(eventType: .win(.block), for: team)
        let aces = calculate(eventType: .win(.ace), for: team)
        let opponentMistakes = numberOfEvents(for: team) - (attacks + blocks + aces)
      
        return ["Attacks" : attacks,
                "Blocks" : blocks,
                "Aces" : aces,
                "Opponent mistakes" : opponentMistakes]
    }
    
    func numberOfEvents(for team: TeamType) -> Int {
        var count = 0
     
        for event in events {
            if event.team.oposit == team { count += 1 }
        }
      
        return count
    }
    
    func calculate(eventType type: EventType, for team: TeamType) -> Int {
        var count = 0
      
        for event in events {
            if event.type == type && event.team.oposit == team { count += 1 }
        }
      
        return 0
    }
}
