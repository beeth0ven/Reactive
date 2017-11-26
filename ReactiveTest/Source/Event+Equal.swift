//
//  Event+Equal.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/26.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public func ==<E: Equatable>(_ lhs: Event<E>, _ rhs: Event<E>) -> Bool {
    switch (lhs, rhs) {
    case let(.next(lElement), .next(rElement)):
        return lElement == rElement
    case let(.error(lError), .error(rError)):
        return lError == rError
    case (.completed, .completed):
        return true
    default:
        return false
    }
}

func ==(_ lhs: Error, _ rhs: Error) -> Bool {
    let (lhs, rhs) = (lhs as NSError, rhs as NSError)
    return lhs.domain == rhs.domain
        && lhs.code == rhs.code
}

