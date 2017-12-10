//
//  TraitObservable.swift
//  Reactive
//
//  Created by luojie on 2017/12/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public struct TraitObservable<Trait, E> {
    
    public let raw: AnyObservable<E>
    
    public init(raw: AnyObservable<E>) {
        self.raw = raw
    }
    
    public init<Observable: ObservableType>(source: Observable) where Observable.Element == E {
        self.raw = AnyObservable(source)
    }
}

