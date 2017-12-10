//
//  Single.swift
//  Reactive
//
//  Created by luojie on 2017/12/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public enum SingleTrait {}
public typealias Single<E> = TraitObservable<SingleTrait, E>

public enum SingleEvent<E> {
    case success(E)
    case error(Error)
}

extension Single {
    
    public typealias Observer = (SingleEvent<E>) -> Void

    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        var emmitted = false
        return raw.subscribe(AnyObserver { event in
            guard !emmitted else { return }
            emmitted = true
            switch event {
            case .next(let element):
                observer(.success(element))
            case .error(let error):
                observer(.error(error))
            case .completed:
                fatalError("Single should not emit completed event.")
            }
        })
    }
}

extension Single {
    
    public func map<R>(_ transform: @escaping (E) -> R) -> Single<R> {
        return Single(raw: raw.map(transform))
    }
}

