//
//  VirtualTimeScheduler.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import ReactiveTest
@testable import Reactive

class VirtualTimeSchedulerTests: XCTestCase {
    
    func testExample() {
        
        let testScheduler = VirtualTimeScheduler()
        let subject = PublishSubject<String>()
        let observer = RecordObserver<String>(scheduler: testScheduler)
        
        testScheduler.schedule(at: 200) { _ = subject.subscribe(observer) }
        testScheduler.schedule(at: 300) { subject.on(.next("300")) }
        testScheduler.schedule(at: 400) { subject.on(.next("400")) }
        testScheduler.schedule(at: 500) { subject.on(.next("500")) }
        testScheduler.schedule(at: 600) { subject.on(.completed) }
        testScheduler.schedule(at: 700) { subject.on(.next("700")) }
        testScheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            RecordedEvent(time: 300, event: .next("300")),
            RecordedEvent(time: 400, event: .next("400")),
            RecordedEvent(time: 500, event: .next("500")),
            RecordedEvent(time: 600, event: .completed),
            RecordedEvent(time: 700, event: .next("700")),
            ])

    }
    
    func testColdObservable() {
        
        let testScheduler = VirtualTimeScheduler()

        let observable = AnyObservable<String>.create { observer in
            testScheduler.schedule(after: 300) { observer.on(.next("300")) }
            testScheduler.schedule(after: 400) { observer.on(.next("400")) }
            testScheduler.schedule(after: 500) { observer.on(.next("500")) }
            testScheduler.schedule(after: 600) { observer.on(.completed) }
            testScheduler.schedule(after: 700) { observer.on(.next("700")) }
            return Disposable()
        }
        
        let observer = RecordObserver<String>(scheduler: testScheduler)

        testScheduler.schedule(at: 200) { _ = observable.subscribe(observer) }
        testScheduler.start()
        
        print("recordedEvents:", observer.recordedEvents)

    }
    
}
