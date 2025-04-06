//
//  GameBoard.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/30/25.
//

import Foundation

actor GameBoard: NSObject {
    private var sessionID: String?
    private var chunks: NSCache<NSString, Chunk> = NSCache()
    
    override init() {
        super.init()
        chunks.countLimit = 1000
        chunks.delegate = self
    }
    
    func setup(sessionID: String) {
        self.sessionID = sessionID
    }
    
    func getCell(for coordinate: Coordinate) async -> Cell? {
        guard let chunk = chunks.object(forKey: coordinate.chunkID as NSString) else {
            let _ = await loadChunk(of: coordinate.chunkID)
            return nil
        }
        return await chunk.getCell(for: coordinate)
    }
    
    func setCell(_ cell: Cell, for coordinate: Coordinate) async {
        guard let chunk = chunks.object(forKey: coordinate.chunkID as NSString) else {
            let newChunk = await loadChunk(of: coordinate.chunkID)
            await newChunk.setCell(cell, for: coordinate)
            return
        }
        await chunk.setCell(cell, for: coordinate)
    }
    
    private func loadChunk(of id: String) async -> Chunk {
        if let sessionID, let snapshot: Chunk.Snapshot = await Serializer.shared.deserialize(name: sessionID + id) {
            let chunk = Chunk(from: snapshot)
            chunks.setObject(chunk, forKey: id as NSString)
            return chunk
        } else {
            let chunk = Chunk(id: id)
            chunks.setObject(chunk, forKey: id as NSString)
            return chunk
        }
    }
    
    private func unloadChunk(_ chunk: Chunk) async {
        guard let sessionID else { return }
        await Serializer.shared.serialize(object: await chunk.snapshot, name: sessionID + chunk.id)
    }
}

extension GameBoard: NSCacheDelegate {
    @preconcurrency nonisolated func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let chunk = obj as? Chunk else { return }
        Task { await unloadChunk(chunk) }
    }
}

extension Coordinate {
    var chunkID: String { "x\(x / 128)y\(y / 128)" }
}
