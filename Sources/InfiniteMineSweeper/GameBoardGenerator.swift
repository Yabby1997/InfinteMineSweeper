//
//  GameBoardGenerator.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

protocol GameBoardGeneratorDelegate: Actor, AnyObject {
    func gameBoardGenerator(_ generator: GameBoardGenerator, didGenerate cell: Cell, at coordinate: Coordinate) async
    func gameBoardGeneratorDidStartGenerating(_ generator: GameBoardGenerator) async
}

protocol GameBoardGeneratorDataSource: Actor, AnyObject {
    func gameBoardGeneratorIsStarted(_ generator: GameBoardGenerator) async -> Bool
    func gameBoardGenerator(_ generator: GameBoardGenerator, cellAtCoordinate coordinate: Coordinate) async -> Cell?
}

actor GameBoardGenerator {
    private weak var delegate: GameBoardGeneratorDelegate?
    private weak var dataSource: GameBoardGeneratorDataSource?
    
    func setup(delegate: GameBoardGeneratorDelegate, dataSource: GameBoardGeneratorDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func openCell(at coordinate: Coordinate) async {
        guard let delegate, let dataSource else { return }
        guard await dataSource.gameBoardGeneratorIsStarted(self) else {
            for each in coordinate.cluster {
                await delegate.gameBoardGenerator(self, didGenerate: .notDetermined, at: each)
            }
            await determine(for: coordinate)
            await delegate.gameBoardGeneratorDidStartGenerating(self)
            return
        }
        
        guard await cell(for: coordinate) == .notDetermined else { return }
        await determine(for: coordinate)
    }
    
    // TODO: Improve probability logic.
    private func cell(for coordinate: Coordinate) async -> Cell {
        if let cell = await dataSource?.gameBoardGenerator(self, cellAtCoordinate: coordinate) {
            return cell
        }
        let newCell: Cell = (Int.random(in: 1...100) < 20) ? .mine : .notDetermined
        await delegate?.gameBoardGenerator(self, didGenerate: newCell, at: coordinate)
        return newCell
    }
    
    private func determine(for coordinate: Coordinate) async {
        guard let delegate, let dataSource else { return }
        var coordinateQueue = Queue<Coordinate>()
        var visited: Set<Coordinate> = []
        coordinateQueue.enqueue(coordinate)
        visited.insert(coordinate)
        while let currentCoordinate = coordinateQueue.dequeue() {
            guard let currentCell = await dataSource.gameBoardGenerator(self, cellAtCoordinate: currentCoordinate),
                  currentCell == .notDetermined else { continue }
            var adjacentMines: Int = .zero
            for each in currentCoordinate.neighbors {
                adjacentMines += await cell(for: each) == .mine ? 1 : .zero
            }
            guard let cell = Cell(from: adjacentMines) else { return }
            await delegate.gameBoardGenerator(self, didGenerate: cell, at: currentCoordinate)
            guard adjacentMines == 0 else { continue }
            currentCoordinate.neighbors
                .filter { visited.contains($0) == false }
                .forEach {
                    coordinateQueue.enqueue($0)
                    visited.insert($0)
                }
        }
    }
}
