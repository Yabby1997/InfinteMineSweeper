//
//  GameBoard.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

// TODO: Change to internal after game logic implementation.
public final class GameBoard {
    private var isBoardGenerationStarted = false
    private(set) var cells: [Coordinate: Cell] = [:]
    
    public init() {}
    
    public func openCell(at coordinate: Coordinate) {
        guard isBoardGenerationStarted else {
            coordinate.cluster.forEach { cells[$0] = .notDetermined }
            determine(for: coordinate)
            isBoardGenerationStarted = true
            return
        }
        
        guard cell(for: coordinate) == .notDetermined else { return }
        determine(for: coordinate)
    }
    
    private func cell(for coordinate: Coordinate) -> Cell {
        if let cell = cells[coordinate] { return cell }
        let newCell: Cell = (Int.random(in: 1...100) < 20) ? .mine : .notDetermined
        cells[coordinate] = newCell
        return newCell
    }
    
    private func determine(for coordinate: Coordinate) {
        var coordinateQueue = Queue<Coordinate>()
        var visited: Set<Coordinate> = []
        coordinateQueue.enqueue(coordinate)
        visited.insert(coordinate)
        while let currentCoordinate = coordinateQueue.dequeue() {
            guard let currentCell = cells[currentCoordinate], currentCell == .notDetermined else { continue }
            let adjacentMines = currentCoordinate.neighbors.map { cell(for: $0) }.count { $0 == .mine }
            cells[currentCoordinate] = .determined(adjacentMines)
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
    public func draw() {
        (-10...10).forEach { y in
            let row = (-10...10).map { x in
                let coordinate = Coordinate(x: x, y: y)
                switch cells[coordinate] {
                case .mine: return "*"
                case .determined(let count): return "\(count)"
                case .notDetermined: return "?"
                default: return "."
                }
            }.joined(separator: " ")
            print(row)
        }
        print("====================")
    }
}
