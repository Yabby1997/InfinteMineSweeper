//
//  Queue.swift
//  InfiniteMineSweeper
//
//  Created by Seunghun on 3/28/25.
//

import Foundation

// TODO: Improve performance of Queue
struct Queue<T> {
    private var enqueueStack: [T] = []
    private var dequeueStack: [T] = []

    var isEmpty: Bool {
        return enqueueStack.isEmpty && dequeueStack.isEmpty
    }

    var peek: T? {
        if !dequeueStack.isEmpty {
            return dequeueStack.last
        }
        return enqueueStack.first
    }

    mutating func enqueue(_ element: T) {
        enqueueStack.append(element)
    }

    mutating func dequeue() -> T? {
        if dequeueStack.isEmpty {
            dequeueStack = enqueueStack.reversed()
            enqueueStack.removeAll()
        }
        return dequeueStack.popLast()
    }
}
