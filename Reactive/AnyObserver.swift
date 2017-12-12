//
//  Observer.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public protocol ObserverType {
    associatedtype Element
    func on(_ event: Event<Element>)
}

public class AnyObserver<E>: ObserverType {
    
    public typealias Element = E
    
    private let _on: (Event<E>) -> Void
    
    public init(_ on: @escaping (Event<E>) -> Void) {
        _on = on
    }
    
    public func on(_ event: Event<E>) {
        _on(event)
    }
}
