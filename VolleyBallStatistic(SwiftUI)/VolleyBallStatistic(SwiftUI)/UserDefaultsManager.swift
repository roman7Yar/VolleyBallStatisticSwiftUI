//
//  UserDefaultsManager.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 30.03.2023.
//

import Foundation

class UserDefaultsManager {
    
    let playersKey = "players"
   
    private init() {
            UserDefaults.standard.register(defaults: [
                playersKey : ""
            ])
        }
    static let shared = UserDefaultsManager()
    
    var players: [Player] {
        get {
            var players = [Player(id: UUID(), firstName: "", lastName: "")]
           
            if let data = UserDefaults.standard.data(forKey: playersKey) {
                do {
                    let decoder = JSONDecoder()
                    
                    let decodeData = try decoder.decode([Player].self, from: data)
                    
                    players = decodeData

                } catch {
                    print("Unable to Decode Data (\(error))")
                }
//                return players
            }
            return players
        }
    }
    
    func addPlayer(_ player: Player) {
        var players = UserDefaultsManager.shared.players
        var count = 0
        players.forEach { item in
            if item.id == player.id {
                players.remove(at: count)
            }
            count += 1
        }
        players.append(player)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(players)
            UserDefaults.standard.set(data, forKey: playersKey)
        } catch {
            print("Unable to Encode Array of Data (\(error))")
        }
    }
    func remove(with id: UUID) {
        var players = UserDefaultsManager.shared.players
        var count = 0
        players.forEach { player in
            if player.id == id {
                players.remove(at: count)
            }
            count += 1
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(players)
            UserDefaults.standard.set(data, forKey: playersKey)
        } catch {
            print("Unable to Encode Array of Data (\(error))")
        }
    }
}
