//
//  GameBoardGenerator.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

actor GameBoardGenerator {
    private var isBoardGenerationStarted = false
    private(set) var board = GameBoard()
    
    func openCell(at coordinate: Coordinate) async {
        guard isBoardGenerationStarted else {
            for each in coordinate.cluster {
                await board.setCell(.notDetermined, for: each)
            }
            await determine(for: coordinate)
            isBoardGenerationStarted = true
            return
        }
        
        guard await cell(for: coordinate) == .notDetermined else { return }
        await determine(for: coordinate)
    }
    
    // TODO: Improve probability logic.
    private func cell(for coordinate: Coordinate) async -> Cell {
        if let cell = await board.getCell(for: coordinate) { return cell }
        let newCell: Cell = (Int.random(in: 1...100) < 20) ? .mine : .notDetermined
        await board.setCell(newCell, for: coordinate)
        return newCell
    }
    
    private func determine(for coordinate: Coordinate) async {
        var coordinateQueue = Queue<Coordinate>()
        var visited: Set<Coordinate> = []
        coordinateQueue.enqueue(coordinate)
        visited.insert(coordinate)
        while let currentCoordinate = coordinateQueue.dequeue() {
            guard let currentCell = await board.getCell(for: currentCoordinate), currentCell == .notDetermined else { continue }
            var adjacentMines: Int = .zero
            for each in currentCoordinate.neighbors {
                adjacentMines += await cell(for: each) == .mine ? 1 : .zero
            }
            guard let cell = Cell(from: adjacentMines) else { return }
            await board.setCell(cell, for: currentCoordinate)
            guard adjacentMines == 0 else { continue }
            currentCoordinate.neighbors
                .filter { visited.contains($0) == false }
                .forEach {
                    coordinateQueue.enqueue($0)
                    visited.insert($0)
                }
        }
    }
    
    // TODO: Remove after game implementation. Only for debugging.
    func draw() async {
        for y in -30...30 {
            var row: String = ""
            for x in -30...30 {
                row += await board.getCell(for: .init(x: x, y: y))?.debugSymbol ?? "."
            }
            print(row)
        }
        print("====================")
    }
}

// TODO: Remove after game implementation. Only for debugging.
public actor GameBoardGeneratorTest {
    private let generator = GameBoardGenerator()
    
    public init() {}
    
    public func start() async {
        while let line = readLine() {
            let components = line.components(separatedBy: ", ")
            guard let x = Int(components[0]), let y = Int(components[1]) else { continue }
            await generator.openCell(at: .init(x: x, y: y))
            await generator.draw()
        }
    }
    
    public func test() async {
        for y in -64...64 {
            for x in -64...64 {
                await generator.openCell(at: .init(x: x, y: y))
                await generator.draw()
            }
        }
    }
}
