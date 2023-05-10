//
//  GameViewModel.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 09.05.2023.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    @Published var game: Game
    @Published var selectedType: GameType = .short
    @Published var isShowingGameOver = false
    
    var scoreTo: Int {
        switch selectedType {
        case .short: return 15
        case .long: return 25
        }
    }
    
    private var isGameOver: Bool {
        
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

class GameModel: ObservableObject {
    
    @Published var teams: [TeamViewModel] = []
    
    func chekSelection(_ teamVM: TeamViewModel) -> Bool {
        return teams.contains(where: { $0.team.id == teamVM.team.id })
    }
    
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
