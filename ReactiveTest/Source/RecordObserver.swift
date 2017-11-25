//
//  RecordObserver.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/24.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public class RecordObserver<Element: Equatable>: ObserverType {
    public typealias E = Element
    
    public private(set) var recordedEvents: [RecordedEvent<E>] = []
    private let _scheduler: VirtualTimeScheduler
    
    init(scheduler: VirtualTimeScheduler) {
        _scheduler = scheduler
    }
    
    public func on(_ event: Event<E>) {
        let recordedEvent = RecordedEvent(time: _scheduler.clock, event: event)
        recordedEvents.append(recordedEvent)
    }
}

