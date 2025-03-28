//
//  main.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import InfiniteMineSweeper

let gameBoard = GameBoard()

while let line = readLine() {
    let components = line.components(separatedBy: ", ")
    if let x = Int(components[0]), let y = Int(components[1]) {
        gameBoard.openCell(at: .init(x: x, y: y))
        gameBoard.draw()
    }
}
