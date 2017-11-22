//
//  Observer.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public protocol ObserverType {
    associatedtype E
    func on(_ event: Event<E>)
}

public class AnyObserver<Element>: ObserverType {
    
    public typealias E = Element
    
    private let _on: (Event<E>) -> Void
    
    public init(_ on: @escaping (Event<E>) -> Void) {
        _on = on
    }
    
    public func on(_ event: Event<E>) {
        _on(event)
    }
}
