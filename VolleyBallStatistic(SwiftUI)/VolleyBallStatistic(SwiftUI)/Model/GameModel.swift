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
