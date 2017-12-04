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
        
        testScheduler.schedule(at: 200) {
            _ = hotObservable.asObservable().subscribe(observer)
        }
        testScheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(300, "300"),
            .next(400, "400"),
            .next(500, "500"),
            .completed(600)
            ])
        
        XCTAssertEqual(hotObservable.subscriptions, [
            Subscription(200, 600)
            ])
        
        print("-- subscriptions:", hotObservable.subscriptions)
    }
    
    func testColdObservable() {

        let testScheduler = VirtualTimeScheduler()
        let coldObservable = ColdObservable(sheduler: testScheduler, recordedEvents: [
            .next(300, "+300"),
            .next(400, "+400"),
            .next(500, "+500"),
            .completed(600),
            .next(700, "+700")
            ])

        let observer = RecordObserver<String>(scheduler: testScheduler)

        testScheduler.schedule(at: 200) {
            _ = coldObservable.asObservable().subscribe(observer)
        }
        testScheduler.start()

        XCTAssertEqual(observer.recordedEvents, [
            .next(500, "+300"),
            .next(600, "+400"),
            .next(700, "+500"),
            .completed(800)
            ])
        
        XCTAssertEqual(coldObservable.subscriptions, [
            Subscription(200, 800)
            ])
        
        print("-- subscriptions:", coldObservable.subscriptions)
    }
}
