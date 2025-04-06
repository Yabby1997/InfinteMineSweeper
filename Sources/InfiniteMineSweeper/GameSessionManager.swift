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
    
    func isSessionStarted() async -> Bool {
        await session?.isStarted ?? false
    }
    
    func isSessionOver() async -> Bool {
        await session?.isOver ?? false
    }
    
    func setup() async {
        session = await startOrGetSession()
    }
    
    func sessionStart() async {
        guard let session else { return }
        await session.start()
        await setGameSession(session)
    }
    
    func sessionOver() async {
        guard let session else { return }
        await session.gameOver()
        await setGameSession(session)
    }
    
    private func startOrGetSession() async -> GameSession {
        if let existingSession = getGameSession(), await existingSession.isOver == false {
            return existingSession
        } else {
            let newSession = GameSession(date: .now, isStarted: false)
            await setGameSession(newSession)
            return newSession
        }
    }
    
    private func getGameSession() -> GameSession? {
        if let savedData = userDefaults.data(forKey: "gameSession") {
            let decoder = JSONDecoder()
            if let snapshot = try? decoder.decode(GameSession.Snapshot.self, from: savedData) {
                return GameSession(snapshot: snapshot)
            }
        }
        return nil
    }
    
    private func setGameSession(_ session: GameSession) async {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(await session.getSnapshot()) {
            userDefaults.set(encoded, forKey: "gameSession")
        }
    }
}
