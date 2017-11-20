//
//  Subject.swift
//  Reactive
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class PublishSubject<E> {
    
    private var _observers: Bag<AnyObserver<E>> = Bag()
    
    public func subscribe(_ observer: AnyObserver<E>) -> Disposable {
        return AnyObservable<E> { _observer in
            let key = self._observers.insert(_observer)
            return Disposable {
                _ = self._observers.removeElement(for: key)
            }
        }.subscribe(observer)
    }
    
    public func on(_ event: Event<E>) {
        _observers.forEach { $0.on(event) }
    }
}

public protocol ObserverType {
    associatedtype E
    func on(_ event: Event<E>)
}

public protocol ObservableType {
    associatedtype E
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E
}
