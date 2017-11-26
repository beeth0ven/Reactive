//
//  HotObservable.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/26.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public class HotObservable<Element: Equatable>: ObservableType {
    
    public typealias E = Element
    
    private let _scheduler: VirtualTimeScheduler
    private var _observers: Bag<AnyObserver<E>> = Bag()
    
    public init(scheduler: VirtualTimeScheduler, recordedEvents: [RecordedEvent<E>]) {
        _scheduler = scheduler
        recordedEvents.forEach(schedule)
    }
    
    private func schedule(recordedEvent: RecordedEvent<E>) {
        _scheduler.schedule(at: recordedEvent.time) { self.on(recordedEvent.event) }
    }
    
    private func on(_ event: Event<E>) {
        _observers.forEach { $0.on(event) }
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Element == O.E {
        let anyObserver = AnyObserver(observer.on)
        let key = _observers.insert(anyObserver)
        return Subscription(scheduler: _scheduler) {
            _ = self._observers.removeElement(for: key)
        }
    }
    
}
