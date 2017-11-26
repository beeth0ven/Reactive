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
            .next(300, "300"),
            .next(400, "400"),
            .next(500, "500"),
            .completed(600),
            .next(700, "700")
            ])
    }
    
    func testHotObservable() {
        
        let testScheduler = VirtualTimeScheduler()
        
        
        let hotObservable = HotObservable(scheduler: testScheduler, recordedEvents: [
            .next(300, "300"),
            .next(400, "400"),
            .next(500, "500"),
            .completed(600),
            .next(700, "700")
            ])
        
        let observer = RecordObserver<String>(scheduler: testScheduler)
        
        var subscription: Subscription!
        testScheduler.schedule(at: 200) { subscription = hotObservable.subscribe(observer) as! Subscription }
        testScheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(300, "300"),
            .next(400, "400"),
            .next(500, "500"),
            .completed(600),
            .next(700, "700")
            ])
        
        print("subscription:", subscription.subscribeAt, subscription.disposeAt ?? "")
    }
    
//    func testColdObservable() {
//
//        let testScheduler = VirtualTimeScheduler()
//        var subscription = Subscription()
//
//        let observable = AnyObservable<String>.create { observer in
//            subscription.subscribeAt = testScheduler.clock
//            testScheduler.schedule(after: 300) { observer.on(.next("300")) }
//            testScheduler.schedule(after: 400) { observer.on(.next("400")) }
//            testScheduler.schedule(after: 500) { observer.on(.next("500")) }
//            testScheduler.schedule(after: 600) { observer.on(.completed) }
//            testScheduler.schedule(after: 700) { observer.on(.next("700")) }
//            return Disposable {
//                subscription.disposeAt = testScheduler.clock
//            }
//        }
//
//        let observer = RecordObserver<String>(scheduler: testScheduler)
//
//        testScheduler.schedule(at: 200) { _ = observable.subscribe(observer) }
//        testScheduler.start()
//
//        XCTAssertEqual(observer.recordedEvents, [
//            .next(500, "300"),
//            .next(600, "400"),
//            .next(700, "500"),
//            .completed(800)
//            ])
//
//        XCTAssertEqual(subscription, Subscription(
//            subscribeAt: 200,
//            disposeAt: 800
//        ))
//    }
    
}
