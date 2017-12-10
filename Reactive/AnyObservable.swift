//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

//public typealias Observable<E> = AnyObservable<E>

public protocol ObservableType {
    associatedtype Element
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element
}

public class AnyObservable<E>: ObservableType {
    
    public typealias Element = E
    
    private let _subscribe: (AnyObserver<E>) -> Disposable
    
    public init(_ subscribe: @escaping (AnyObserver<E>) -> Disposable) {
        _subscribe = subscribe
    }
    
    public init<Observable: ObservableType>(_ source: Observable) where Observable.Element == E {
        _subscribe = source.subscribe
    }
    
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == E {
        let anyObserver = AnyObserver(observer.on)
        return _subscribe(anyObserver)
    }
}

extension AnyObservable {
    
    public static func create(_ subscribe: @escaping (AnyObserver<E>) -> Disposable) -> AnyObservable<E> {
        
        return AnyObservable { [subscribe] observer in
            
            let _disposer = Disposer()
            
            let _disposable = subscribe(AnyObserver { [observer] event in
                guard !_disposer.isDisposed else { return }
                switch event {
                case .next(let element):
                    observer.on(.next(element))
                case .error(let error):
                    observer.on(.error(error))
                    _disposer.dispose()
                case .completed:
                    observer.on(.completed)
                    _disposer.dispose()
                }
            })
            
            _disposer.setDispose(_disposable.dispose)
            return _disposer
        }
    }
}

extension ObservableType {
    
    public func asObservable() -> AnyObservable<Element> {
        return AnyObservable.create(self.subscribe)
    }
}
