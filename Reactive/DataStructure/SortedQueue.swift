//
//  SortedQueue.swift
//  Reactive
//
//  Created by luojie on 2017/11/20.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

struct SortedQueue<E> {
    
    private let areInIncreasingOrder: (E, E) -> Bool
    private var _elements = [E]()
    
    init(sortBy areInIncreasingOrder: @escaping (E, E) -> Bool) {
        self.areInIncreasingOrder = areInIncreasingOrder
    }
    
    mutating func enqueue(_ element: E) {
        _elements.append(element)
        _elements.sort(by: areInIncreasingOrder)
    }
    
    mutating func dequeue() -> E? {
        return _elements.isEmpty ? nil : _elements.removeFirst()
    }
}
