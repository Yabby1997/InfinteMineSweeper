//
//  Cell.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

public enum Cell: Equatable {
    case mine
    case notDetermined
    case determined(Int)
}
