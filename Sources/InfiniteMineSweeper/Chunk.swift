//
//  File.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/31/25.
//

import Foundation

actor Chunk {
    struct Snapshot: Codable {
        let id: String
        let cells: [Coordinate: Cell]
    }
    
    let id: String
    private var cells: Dictionary<Coordinate, Cell> = [:]
    var snapshot: Snapshot { Snapshot(id: id, cells: cells) }
    
    init(id: String) {
        self.id = id
    }
    
    init(from snapshot: Snapshot) {
        self.id = snapshot.id
        self.cells = snapshot.cells
    }
    
    func getCell(for coordinate: Coordinate) -> Cell? {
        cells[coordinate]
    }
    
    func setCell(_ cell: Cell, for coordinate: Coordinate) {
        cells[coordinate] = cell
    }
}
