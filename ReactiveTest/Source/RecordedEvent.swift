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

extension RecordedEvent {
    
    public static func next(_ time: VirtualTimeScheduler.VirtualTime, _ element: Element) -> RecordedEvent<Element> {
        return RecordedEvent(time: time, event: .next(element))
    }
    
    public static func error(_ time: VirtualTimeScheduler.VirtualTime, _ error: Error) -> RecordedEvent<Element> {
        return RecordedEvent(time: time, event: .error(error))
    }
    
    public static func completed(_ time: VirtualTimeScheduler.VirtualTime) -> RecordedEvent<Element> {
        return RecordedEvent(time: time, event: .completed)
    }
    
}
