//
//  Cell.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

// TODO: Customize decoding/encoding to minimize disk usage.
public enum Cell: Equatable, Codable, Sendable {
    case mine
    case notDetermined
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    init?(from mineCount: Int) {
        switch mineCount {
        case 0: self = .zero
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        case 4: self = .four
        case 5: self = .five
        case 6: self = .six
        case 7: self = .seven
        case 8: self = .eight
        default: return nil
        }
    }
    
    public var isDetermined: Bool {
        switch self {
        case .mine, .notDetermined:
            return false
        default:
            return true
        }
    }
    
    var debugSymbol: String {
        switch self {
        case .mine: "*"
        case .notDetermined: "?"
        case .zero: "0"
        case .one: "1"
        case .two: "2"
        case .three: "3"
        case .four: "4"
        case .five: "5"
        case .six: "6"
        case .seven: "7"
        case .eight: "8"
        }
    }
}
