//
//  Subject.swift
//  Reactive
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class PublishSubject<E> {
    
    public typealias Observer = (Event<E>) -> Void
    private var _observers: Bag<Observer> = Bag()
    
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let key = _observers.insert(observer)
        return Disposable {
            _ = self._observers.removeElement(for: key)
        }
    }
    
    public func on(_ event: Event<E>) {
        _observers.forEach { $0(event) }
    }
}

public struct Bag<E> {
    
    public typealias Key = Int
    private var _stores: [Key: E] = [:]
    private var _nextKey: Key = 0
    
    public var elements: [E] { return Array(_stores.values) }

    public mutating func insert(_ element: E) -> Key {
        let currentKey = _nextKey
        _stores[currentKey] = element
        _nextKey += 1
        return currentKey
    }
    
    public mutating func removeElement(for key: Key) -> E? {
        return _stores.removeValue(forKey: key)
    }
}

extension Bag: Sequence {
    
    public typealias Element = E
    
    public func makeIterator() -> AnyIterator<E> {
        return AnyIterator(_stores.values.makeIterator())
    }
}
