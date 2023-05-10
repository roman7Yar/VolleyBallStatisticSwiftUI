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
