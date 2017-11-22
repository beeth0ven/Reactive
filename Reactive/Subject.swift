//
//  Subject.swift
//  Reactive
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class PublishSubject<Element>: ObservableType, ObserverType {

    public typealias E = Element
    
    private var _observers: Bag<AnyObserver<E>> = Bag()
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where E == O.E {
        let anyObserver = AnyObserver(observer.on)
        let key = _observers.insert(anyObserver)
        return Disposable {
            _ = self._observers.removeElement(for: key)
        }
    }
    
    public func on(_ event: Event<E>) {
        _observers.forEach { $0.on(event) }
    }
}
