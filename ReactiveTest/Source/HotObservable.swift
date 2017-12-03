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
    public private(set) var subscriptions: Subscriptions
    
    public init(scheduler: VirtualTimeScheduler, recordedEvents: [RecordedEvent<E>]) {
        _scheduler = scheduler
        subscriptions = Subscriptions(scheduler: _scheduler)
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
        let index = subscriptions.addNewSubscription()
        return Disposer {
            _ = self._observers.removeElement(for: key)
            self.subscriptions.dispose(atIndex: index)
        }
    }
}

public class ColdObservable<Element: Equatable>: ObservableType {
    
    public typealias E = Element
    private let _scheduler: VirtualTimeScheduler
    private let _recordedEvents: [RecordedEvent<E>]
    public private(set) var subscriptions: Subscriptions

    public init(sheduler: VirtualTimeScheduler, recordedEvents: [RecordedEvent<E>]) {
        _scheduler = sheduler
        _recordedEvents = recordedEvents
        subscriptions = Subscriptions(scheduler: _scheduler)
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Element == O.E {
        var isDisposed = false
        _recordedEvents.forEach { recordedEvent in
            _scheduler.schedule(after: recordedEvent.time) {
                guard !isDisposed else { return }
                observer.on(recordedEvent.event)
            }
        }
        let index = subscriptions.addNewSubscription()
        return Disposer {
            isDisposed = true
            self.subscriptions.dispose(atIndex: index)
        }
    }
}

