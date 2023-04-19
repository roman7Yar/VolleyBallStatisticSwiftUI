//
//  UserModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.03.2023.
//

import SwiftUI

    
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
    }
}

struct Team: Identifiable, Codable {
    let id: UUID
    var name: String = "Team 1"
    var players: [Player]
}

struct Game: Codable {
    var date: Date
    var teams: [Team]
    var events: [GameEvent]
    var time: Double
}

var events = [GameEvent]()

struct GameEvent: Codable {
    var type: EventType
    var team: String
    var player: UUID
    var time: Double
}

enum EventType: Codable {
    case attack, block, ace
    case doble, line, serve, net, technical, other // mistakes
}

class EventHandler {
    var events = [GameEvent]()
    
    func getMain(for team: String) -> [String : Int] {
      
        let attacks = calculate(eventType: .attack, for: team)
        let blocks = calculate(eventType: .block, for: team)
        let aces = calculate(eventType: .ace, for: team)
        let opponentMistakes = numberOfEvents(for: team) - (attacks + blocks + aces)
      
        return ["Attacks" : attacks,
                "Blocks" : blocks,
                "Aces" : aces,
                "Opponent mistakes" : opponentMistakes]
    }
    
    func numberOfEvents(for team: String) -> Int {
        var count = 0
     
        for event in events {
            if event.team == team { count += 1 }
        }
      
        return count
    }
    
    func calculate(eventType type: EventType, for team: String) -> Int {
        var count = 0
      
        for event in events {
            if event.type == type && event.team == team { count += 1 }
        }
      
        return 0
    }
}
