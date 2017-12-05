//
//  ColdObservable.swift
//  ReactiveTest
//
//  Created by luojie on 2017/12/5.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public class ColdObservable<Element: Equatable>: ObservableType {
    
    public typealias E = Element
    private let _scheduler: VirtualTimeScheduler
    private let _recordedEvents: [RecordedEvent<E>]
    public private(set) var subscriptions: Subscriptions
    
    public init(sheduler: VirtualTimeScheduler, recordedEvents: [RecordedEvent<E>]) {
        _scheduler = sheduler
        _recordedEvents = recordedEvents
        subscriptions = Subscriptions()
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Element == O.E {
        var isDisposed = false
        _recordedEvents.forEach { recordedEvent in
            _scheduler.schedule(after: recordedEvent.time) {
                guard !isDisposed else { return }
                observer.on(recordedEvent.event)
            }
        }
        let index = subscriptions.addNewSubscription(atTime: _scheduler.clock)
        return Disposer { [_scheduler] in
            isDisposed = true
            self.subscriptions.dispose(atIndex: index, atTime: _scheduler.clock)
        }
    }
}
