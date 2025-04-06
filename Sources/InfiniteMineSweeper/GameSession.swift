//
//  GameSession.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 4/6/25.
//

import Foundation

struct GameSession: Codable {
    let id: String
    let date: Date
    let isStarted: Bool
    
    init(
        id: String = UUID().uuidString,
        date: Date = .now,
        isStarted: Bool = false
    ) {
        self.id = id
        self.date = date
        self.isStarted = isStarted
    }
    
    func started() -> GameSession {
        .init(isStarted: true)
    }
}
