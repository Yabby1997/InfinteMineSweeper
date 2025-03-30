//
//  Coordinate.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

// TODO: Customize decoding/encoding to minimize disk usage.
public struct Coordinate: Hashable, Codable, Sendable {
    public let x: Int
    public let y: Int
    
    public var neighbors: [Coordinate] {
        [
            .init(x: x - 1, y: y - 1),
            .init(x: x, y: y - 1),
            .init(x: x + 1, y: y - 1),
            .init(x: x - 1, y: y),
            .init(x: x + 1, y: y),
            .init(x: x - 1, y: y + 1),
            .init(x: x, y: y + 1),
            .init(x: x + 1, y: y + 1),
        ]
    }
    
    public var cluster: [Coordinate] { neighbors + [self] }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
