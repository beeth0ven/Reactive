//
//  Record.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/24.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public struct RecordedEvent<Element: Equatable> {
    public let time: VirtualTimeScheduler.VirtualTime
    public let event: Event<Element>
}

extension RecordedEvent: Equatable {
    public static func ==(lhs: RecordedEvent<Element>, rhs: RecordedEvent<Element>) -> Bool {
        return lhs.time == rhs.time
            && lhs.event == rhs.event
    }
}

func ==<E: Equatable>(_ lhs: Event<E>, _ rhs: Event<E>) -> Bool {
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

