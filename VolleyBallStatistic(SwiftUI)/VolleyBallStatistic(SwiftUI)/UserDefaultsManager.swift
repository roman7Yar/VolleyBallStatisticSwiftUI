//
//  UserDefaultsManager.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 30.03.2023.
//

import Foundation

class UserDefaultsManager {
    
    let playersKey = "players"
    let teamsKey = "teams"
    let picturesKey = "pictures"
   
    private init() {
            UserDefaults.standard.register(defaults: [
                playersKey : "",
                picturesKey: [:]
            ])
        }
        
        static let shared = UserDefaultsManager()
        // TODO: add playerColor
        var pictures: [UUID: Data] {
            get {
                if let savedPictures = UserDefaults.standard.dictionary(forKey: picturesKey) as? [String: Data] {
                    var pictures = [UUID: Data]()
                    for (key, value) in savedPictures {
                        if let uuid = UUID(uuidString: key) {
                            pictures[uuid] = value
                        }
                    }
                    return pictures
                } else {
                    return [:]
                }
            }
            set {
                var dictionary = [String: Data]()
                for (key, value) in newValue {
                    dictionary[key.uuidString] = value
                }
                UserDefaults.standard.set(dictionary, forKey: picturesKey)
            }
    }
    
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
    
    var teams: [Team] {
        get {
            var teams = [Team(id: UUID(), name: "", players: nil)]
           
            if let data = UserDefaults.standard.data(forKey: teamsKey) {
                do {
                    let decoder = JSONDecoder()
                    
                    let decodeData = try decoder.decode([Team].self, from: data)
                    
                    teams = decodeData

                } catch {
                    print("Unable to Decode Data (\(error))")
                }
            }
            return teams
        }
    }
    
    func addTeam(_ team: Team) {
        var teams = UserDefaultsManager.shared.teams
        var count = 0
        teams.forEach { item in
            if item.id == team.id {
                teams.remove(at: count)
            }
            count += 1
        }
        teams.append(team)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(teams)
            UserDefaults.standard.set(data, forKey: teamsKey)
        } catch {
            print("Unable to Encode Array of Data (\(error))")
        }
    }

}
