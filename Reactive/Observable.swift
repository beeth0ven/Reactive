//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/9/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//


public protocol HasObservable {
    associatedtype E
    func asObservable() -> Observable<E>
}

public protocol IsObservable: HasObservable {
    func subscribe<O: IsObserver>(_ observer: O) -> Disposable where O.E == E
}

extension IsObservable {
    
    public func asObservable() -> Observable<E> {
        return AnyObservable.create(subscribe)
    }
}

public class Observable<Element>: IsObservable {
    
    public typealias E = Element
    
    public func subscribe<O: IsObserver>(_ observer: O) -> Disposable where O.E == E {
        fatalError("This is an abstract method.")
    }
}

class Producer<Element>: Observable<Element> {
    
    override func subscribe<O: IsObserver>(_ observer: O) -> Disposable where O.E == E {
        let disposer = Disposer()
        let (sink, subscription) = run(observer, cancel: disposer)
        disposer.setSinkAndSubscription(sink: sink, subscription: subscription)
        return disposer
    }
    
    func run<O>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable)  where Element == O.E, O : IsObserver {
        fatalError("This is an abstract method.")
    }
}

class AnyObservable<Element>: Producer<Element> {
    
    typealias SubscribeHandler = (AnyObserver<Element>) -> Disposable
    private let _subscribeHandler: SubscribeHandler
    
    init(_ subscribeHandler: @escaping SubscribeHandler) {
        _subscribeHandler = subscribeHandler
    }
    
    override func run<O>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Element == O.E, O : IsObserver {
        let sink = CreateSink(observer: observer, cancel: cancel)
        let subscription = _subscribeHandler(AnyObserver(sink))
        return (sink: sink, subscription: subscription)
    }
    
}

extension IsObservable {
    
    public static func create(_ subscribe: @escaping (AnyObserver<E>) -> Disposable) -> Observable<E> {
        return AnyObservable(subscribe)
    }
}
