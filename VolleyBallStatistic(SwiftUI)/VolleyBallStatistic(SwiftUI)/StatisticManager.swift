//
//  StatisticManager.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 29.04.2023.
//

import Foundation

class StatisticManager {
    var events = [GameEvent]()
    let game: Game
    var teams: [Team] {
        return [game.team1, game.team2]
    }
    
    init(game: Game) {
        self.game = game
        events = game.events
    }
    
    func getTime(for event: GameEvent) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let timeDifference = Int(event.date.timeIntervalSince(game.start))
        let formattedTime = dateFormatter.string(from: Date(timeIntervalSince1970: Double(timeDifference)))
        
        return formattedTime
    }
    
    func totalScore() -> String {
        let score = getScore(for: events.last!)
        return "\(score[0]):\(score[1])"
    }
    
    func getScore(for event: GameEvent) -> [String] {
        var firstTeamScore = 0
        var secondTeamScore = 0
        let breakDate = event.date
        
        var index = 0
        
        while index < events.count && events[index].date <= breakDate {
            let event = events[index]
            if event.team.id == teams[0].id {
                firstTeamScore += 1
            } else {
                secondTeamScore += 1
            }
            index += 1
        }
        
        return [String(firstTeamScore), String(secondTeamScore)]
    }
    
    func getLongestTime() -> String {
        guard events.count > 2 else { return "-" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        var longestTimeInterval = 0
        var previousDate: Date?
        
        for event in events {
            if let previousDate = previousDate {
                let timeInterval = Int(event.date.timeIntervalSince(previousDate))
                if timeInterval > longestTimeInterval {
                    longestTimeInterval = timeInterval
                }
            }
            previousDate = event.date
            
        }
        let result = dateFormatter.string(from: Date(timeIntervalSince1970: Double(longestTimeInterval)))
        return result
    }
    
    func getSuccess(for team: Team) -> [(String, String)] {
        
        let attacks = calculate(eventType: .win(.attack), for: team)
        let blocks = calculate(eventType: .win(.block), for: team)
        let aces = calculate(eventType: .win(.serve), for: team)
        let all = attacks + blocks + aces
        
        return [("Attacks", String(attacks)),
                ("Blocks", String(blocks)),
                ("Serves", String(aces)),
                ("", ""),
                ("All", String(all))]
    }
    
    func getErrors(for team: Team) -> [(String, String)] {
        
        let serve = calculate(eventType: .error(.serve), for: team)
        let line = calculate(eventType: .error(.line), for: team)
        let net = calculate(eventType: .error(.net), for: team)
        let out = calculate(eventType: .error(.out), for: team)
        let other = calculate(eventType: .error(.other), for: team)
        let all = serve + line + net + out + other
        
        return [("Serve", String(serve)),
                ("Line", String(line)),
                ("Net",String(net)),
                ("Out", String(out)),
                ("Other", String(other)),
                ("", ""),
                ("All", String(all))]
    }
    
    
    private func numberOfEvents(for player: Player) -> Int {
        var count = 0
        
        for event in events {
            if let eventPlayer = event.player {
                if eventPlayer.id == player.id { count += 1 }
            }
        }
        
        return count
    }
    
    private func calculate(eventType type: EventType, for team: Team) -> Int {
        var count = 0
        
        for event in events {
            if event.type == type && event.team.id == team.id { count += 1 }
        }
        
        return count
    }
    
    func getPlayerSummary(for player: Player) -> [(String, String)] {
            
        let attacks = calculate(eventType: .win(.attack), for: player)
        let blocks = calculate(eventType: .win(.block), for: player)
        let serves = calculate(eventType: .win(.serve), for: player)
        let errors = numberOfEvents(for: player) - (attacks + blocks + serves)

        return [("Attacks", String(attacks)),
                ("Blocks", String(blocks)),
                ("Serves", String(serves)),
                ("", ""),
                ("Errors", String(errors))]
        }
    
    private func calculate(eventType type: EventType, for player: Player) -> Int {
        var count = 0
        
        for event in events {
            if let eventPlayer = event.player {
                if event.type == type && eventPlayer.id == player.id { count += 1 }
            }
        }
        return count
    }


}
