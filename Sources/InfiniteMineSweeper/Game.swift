//
//  Game.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 4/6/25.
//

import Foundation

public actor Game {
    private let sessionManager = GameSessionManager()
    private let board = GameBoard()
    private let generator = GameBoardGenerator()
    
    public init() {}
    
    public func setup() async {
        await sessionManager.setup()
        guard let sessionID = await sessionManager.sessionID else { return }
        await board.setup(sessionID: sessionID)
        await generator.setup(delegate: self, dataSource: self)
    }
    
    // TODO: Add game over
    public func openCell(at coordinate: Coordinate) async {
        await generator.openCell(at: coordinate)
        if await board.getCell(for: coordinate) == .mine {
            await sessionManager.sessionOver()
        }
    }
    
    // TODO: Add flags
    
    public func getCell(at coordinate: Coordinate) async -> Cell? {
        guard let cell = await board.getCell(for: coordinate) else { return nil }
        switch cell {
        case .zero: return .zero
        case .one: return .one
        case .two: return .two
        case .three: return .three
        case .four: return .four
        case .five: return .five
        case .six: return .six
        case .seven: return .seven
        case .eight: return .eight
        case .mine: return .mine
        case .notDetermined: return nil
        }
    }
}

extension Game: GameBoardGeneratorDelegate {
    func gameBoardGenerator(_ generator: GameBoardGenerator, didGenerate cell: Cell, at coordinate: Coordinate) async {
        await board.setCell(cell, for: coordinate)
    }
    
    func gameBoardGeneratorDidStartGenerating(_ generator: GameBoardGenerator) async {
        await sessionManager.sessionStart()
    }
}

extension Game: GameBoardGeneratorDataSource {
    func gameBoardGeneratorIsStarted(_ generator: GameBoardGenerator) async -> Bool {
        await sessionManager.isSessionStarted()
    }
    
    func gameBoardGenerator(_ generator: GameBoardGenerator, cellAtCoordinate coordinate: Coordinate) async -> Cell? {
        await board.getCell(for: coordinate)
    }
}
