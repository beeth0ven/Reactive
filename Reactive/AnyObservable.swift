//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

//public typealias Observable<E> = AnyObservable<E>

public protocol ObservableType {
    associatedtype E
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E
}

public class AnyObservable<Element>: ObservableType {
    
    public typealias E = Element
    
    private let _subscribe: (AnyObserver<E>) -> Disposable
    
    public init(_ subscribe: @escaping (AnyObserver<E>) -> Disposable) {
        _subscribe = subscribe
    }
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        let anyObserver = AnyObserver(observer.on)
        return _subscribe(anyObserver)
    }
}

extension AnyObservable {
    
    public static func create(_ subscribe: @escaping (AnyObserver<E>) -> Disposable) -> AnyObservable<E> {
        
        return AnyObservable { [subscribe] observer in
            
            let _disposer = Disposable()
            
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
