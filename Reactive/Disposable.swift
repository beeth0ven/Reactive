//
//  Disposable.swift
//  Reactive
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//


public protocol Disposable {
    
    func dispose()
}

public protocol Cancelable: Disposable {
    
    var isDisposed: Bool { get }
}

class Disposables: Disposable {
    
    public static func create(_ dispose: @escaping () -> Void) -> Disposable {
        return Disposables(dispose)
    }
    
    private let _dispose: () -> Void
    
    private init(_ dispose: @escaping () -> Void) {
        _dispose = dispose
    }
    
    func dispose() {
        _dispose()
    }
}

class Disposer: Cancelable {
    
    private enum State {
        case notSet
        case didSet
        case disposed
    }
    
    var isDisposed: Bool = false
    private let lock = NSRecursiveLock()
    private var state: State = .notSet
    private var _sink: Disposable?
    private var _subscription: Disposable?
    
    func setSinkAndSubscription(sink: Disposable, subscription: Disposable) {
        lock.lock(); defer { lock.unlock() }
        
        switch state {
        case .notSet:
            state = .didSet
            _sink = sink
            _subscription = subscription
        case .didSet:
            fatalError("Sink and subscription has already been set before.")
        case .disposed:
            sink.dispose()
            subscription.dispose()
            
            _sink = nil
            _subscription = nil
        }
    }
    
    func dispose() {
        
        lock.lock(); defer { lock.unlock() }
        
        guard state != .disposed else { return }
        
        state = .disposed
        isDisposed = true
        
        _sink?.dispose()
        _subscription?.dispose()
        
        _sink = nil
        _subscription = nil
        
    }
}
