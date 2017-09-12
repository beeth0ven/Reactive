//
//  Observer.swift
//  Reactive
//
//  Created by luojie on 2017/9/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public protocol IsObserver {
    associatedtype E
    func on(_ event: Event<E>)
}

extension IsObserver {
    
    public func asObserver() -> AnyObserver<E> {
        return AnyObserver(on)
    }
}

public class AnyObserver<Element>: IsObserver {
    public typealias E = Element
    
    private let _on: (Event<E>) -> Void
    
    init<O: IsObserver>(_ observer: O) where O.E == E {
        _on = observer.on
    }
    
    public init(_ on: @escaping (Event<E>) -> Void) {
        _on = on
    }
    
    public func on(_ event: Event<E>) {
        _on(event)
    }
}

class Sink<O: IsObserver>: Cancelable {
    
    var isDisposed: Bool = false
    private let lock = NSRecursiveLock()
    private let _observer: O
    private let _cancel: Cancelable
    
    init(observer: O, cancel: Cancelable) {
        _observer = observer
        _cancel = cancel
    }
    
    final func forwardOn(_ event: Event<O.E>) {
        lock.lock(); defer { lock.unlock() }
        guard !isDisposed else { return }
        
        _observer.on(event)
        
        switch event {
        case .error, .completed:
            dispose()
        default:
            break
        }
    }
    
    func dispose() {
        lock.lock(); defer { lock.unlock() }
        guard !isDisposed else { return }
        isDisposed = true
        _cancel.dispose()
    }
}

class CreateSink<O: IsObserver>:
    Sink<O>,
    IsObserver {
    typealias E = O.E
    
    func on(_ event: Event<E>) {
        forwardOn(event)
    }
}
