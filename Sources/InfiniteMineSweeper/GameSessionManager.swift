//
//  GameSessionManager.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 4/6/25.
//

import Foundation

actor GameSessionManager {
    private let userDefaults = UserDefaults.standard
    private var session: GameSession?
    var sessionID: String? { session?.id }
    var isStarted: Bool { session?.isStarted ?? false }

    func setup() {
        session = startOrGetSession()
    }
    
    func start() {
        guard let session else { return }
        self.session = session.started()
        setGameSession(session)
    }
    
    private func startOrGetSession() -> GameSession {
        if let existingSession = getGameSession() {
            return existingSession
        } else {
            let newSession = GameSession(date: .now, isStarted: false)
            setGameSession(newSession)
            return newSession
        }
    }
    
    private func getGameSession() -> GameSession? {
        if let savedData = userDefaults.data(forKey: "gameSession") {
            let decoder = JSONDecoder()
            if let session = try? decoder.decode(GameSession.self, from: savedData) {
                return session
            }
        }
        return nil
    }
    
    private func setGameSession(_ session: GameSession) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(session) {
            userDefaults.set(encoded, forKey: "gameSession")
        }
    }
}
