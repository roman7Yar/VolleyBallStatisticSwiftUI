//
//  GameModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.04.2023.
//

import Foundation

struct Game: Codable {
    var start = Date()
    let team1: Team
    let team2: Team
    var events = [GameEvent]()
}

class GameViewModel: ObservableObject {
    @Published var game: Game
    @Published var selectedType: GameType = .short
    @Published var isShowingGameOver = false
    var scoreTo: Int {
        switch selectedType {
        case .short: return 5
        case .long: return 25
        }
    }
    var isGameOver: Bool {
        let firstTeamScore = getScore(for: game.team1)
        let secondTeamScore = getScore(for: game.team2)
        if firstTeamScore < scoreTo && secondTeamScore < scoreTo {
            return false
        } else if abs(firstTeamScore - secondTeamScore) < 2 {
            return false
        } else {
            return true
        }
    }
    
    init(teams: [TeamViewModel]) {
        game = Game(team1: teams[0].team, team2: teams[1].team)
    }

    func printEvents() {
        var count = 1
        game.events.forEach { event in
            print("\(count). \(event.team.name) - \(event.type.description)(\(event.player?.fullName ?? "-"))")
            count += 1
        }
    }
    
    func newEvent(_ event: GameEvent) {
        if !isGameOver {
            game.events.append(event)
        }
    }
    
    func checkIsGameOver() {
        isShowingGameOver = isGameOver
    }
    
    func getWinner() -> String {
        if getScore(for: game.team1) > getScore(for: game.team2) {
            return "\(game.team1.name) win!"
        } else {
            return "\(game.team2.name) win!"

        }
    }
   
    func removeLastEvent() {
        if !game.events.isEmpty {
            game.events.removeLast()
        }
    }
    
    func getScore(for team: Team) -> Int {
        var score = 0
        game.events.forEach { event in
            if event.team.id == team.id {
                score += 1
            }
        }
        return score
    }
    
    func getLastTenEvents() -> [String] {
        let count = game.events.count
        var result = [String]()
        game.events.forEach { event in
            result.append("\(event.team.name):  \(event.type.description)(\(event.player?.fullName ?? "-"))")
        }
        if count < 6 {
            return result
        } else {
            let prefix = count - 5
            for _ in 1...prefix {
                result.removeFirst()
            }
            return result
        }
    }
    func saveGame() {
        if isGameOver {
            UserDefaultsManager.shared.addGame(game)
        }
    }
}

struct GameEvent: Codable {
    let type: EventType
    let team: Team
    let player: Player?
    var date = Date()
}

enum EventType: Codable, Equatable {
    case win(WinEventType)
    case error(ErrorEventType)
    
    var description: String {
        switch self {
        case .win(let winEventType):
            switch winEventType {
            case .attack: return "Attack"
            case .block: return "Block"
            case .serve: return "Serve"
            }
        case .error(let errorEventType):
            switch errorEventType {
            case .other: return "Other"
            case .line: return "Line"
            case .net: return "Net"
            case .out: return "Out"
            case .serve: return "Serve error"
            }
        }
    }
}

enum WinEventType: String, CaseIterable, Codable {
    case attack, block, serve
}
enum ErrorEventType: String, CaseIterable, Codable {
    case other, line, net, out, serve // mistakes
}
