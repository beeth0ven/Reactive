//
//  Event.swift
//  Reactive
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public enum Event<E> {
    case next(E)
    case error(Swift.Error)
    case completed
}

public typealias Disposable = () -> ()
public typealias Observer<E> = (Event<E>) -> Void
public typealias Observable<E> = (Observer<E>) -> Disposable

public func map<E, R>(_ source: @escaping Observable<E>, transform: @escaping (E) throws -> R) -> Observable<R> {
    
    var isDisposed = false
    
    return { observer -> Disposable in
        
        let disposable = source { event in
            if isDisposed { return }
            switch event {
            case .next(let value):
                do {
                    let result = try transform(value)
                    observer(.next(result))
                } catch let error {
                    observer(.error(error))
                    isDisposed = true
                }
            case .error(let error):
                observer(.error(error))
                isDisposed = true
            case .completed:
                observer(.completed)
                isDisposed = true
            }
        }
        
        return {
            disposable()
            isDisposed = true
        }
    }
}
