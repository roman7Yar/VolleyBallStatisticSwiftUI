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
    
//    func getMain(for team: TeamType) -> [String : Int] {
//
//        let attacks = calculate(eventType: .win(.attack), for: team)
//        let blocks = calculate(eventType: .win(.block), for: team)
//        let aces = calculate(eventType: .win(.ace), for: team)
//        let opponentMistakes = numberOfEvents(for: team) - (attacks + blocks + aces)
//
//        return ["Attacks" : attacks,
//                "Blocks" : blocks,
//                "Aces" : aces,
//                "Opponent mistakes" : opponentMistakes]
//    }
//
//    func numberOfEvents(for team: TeamType) -> Int {
//        var count = 0
//
//        for event in events {
//            if event.team.oposit == team { count += 1 }
//        }
//
//        return count
//    }
    
//    func calculate(eventType type: EventType, for team: TeamType) -> Int {
//        var count = 0
//      
//        for event in events {
//            if event.type == type && event.team.oposit == team { count += 1 }
//        }
//      
//        return 0
//    }
}
