//
//  Serializer.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/31/25.
//

import Foundation

// TODO: Change to specify certain directory, add error handlings, add directory removing method.
actor Serializer {
    static var shared = Serializer()
    private let fileManager = FileManager.default
    
    private init() {}
    
    func serialize<T: Encodable>(object: T, name: String) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(name)
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(object)
        try? jsonData?.write(to: fileURL)
    }
    
    func deserialize<T: Decodable>(name: String) -> T? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(name)
        guard let jsonData = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: jsonData)
    }
}
