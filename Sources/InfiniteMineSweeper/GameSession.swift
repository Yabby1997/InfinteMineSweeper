//
//  GameSession.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 4/6/25.
//

import Foundation

actor GameSession {
    struct Snapshot: Codable {
        let id: String
        let date: Date
        let isStarted: Bool
        let isOver: Bool
    }
    
    let id: String
    let date: Date
    var isStarted: Bool
    var isOver: Bool
    
    init(snapshot: Snapshot) {
        id = snapshot.id
        date = snapshot.date
        isStarted = snapshot.isStarted
        isOver = snapshot.isOver
    }
    
    init(
        id: String = UUID().uuidString,
        date: Date = .now,
        isStarted: Bool = false,
        isOver: Bool = false
    ) {
        self.id = id
        self.date = date
        self.isStarted = isStarted
        self.isOver = isOver
    }
    
    func start() {
        isStarted = true
    }
    
    func gameOver() {
        isOver = true
    }
    
    func getSnapshot() -> Snapshot {
        .init(
            id: id,
            date: date,
            isStarted: isStarted,
            isOver: isOver
        )
    }
}
