//
//  Record.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/24.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public struct RecordedEvent<E: Equatable> {
    public let time: VirtualTimeScheduler.VirtualTime
    public let event: Event<E>
}

extension RecordedEvent: Equatable {
    public static func ==(lhs: RecordedEvent<E>, rhs: RecordedEvent<E>) -> Bool {
        return lhs.time == rhs.time
            && lhs.event == rhs.event
    }
}

extension RecordedEvent {
    
    public static func next(_ time: VirtualTimeScheduler.VirtualTime, _ element: E) -> RecordedEvent<E> {
        return RecordedEvent(time: time, event: .next(element))
    }
    
    public static func error(_ time: VirtualTimeScheduler.VirtualTime, _ error: Error) -> RecordedEvent<E> {
        return RecordedEvent(time: time, event: .error(error))
    }
    
    public static func completed(_ time: VirtualTimeScheduler.VirtualTime) -> RecordedEvent<E> {
        return RecordedEvent(time: time, event: .completed)
    }
    
}
