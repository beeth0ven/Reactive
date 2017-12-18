//
//  FilterTests.swift
//  Tests
//
//  Created by luojie on 2017/12/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
import ReactiveTest
@testable import Reactive


class FilterTests: XCTestCase {
    
    func testNormal() {
        
        let scheduler = VirtualTimeScheduler()
        
        let hotObservable = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(100, 15),
            .next(250, 20),
            .next(300, 50),
            .next(350, 75),
            .next(450, 85),
            .next(550, 35),
            .next(600, 95),
            .completed(800),
            .next(900, 105),
            ])
        
        let observer = RecordObserver<Int>(scheduler: scheduler)
        
        scheduler.schedule(at: 200) {
            _ = hotObservable
                .filter { $0 > 50 }
                .subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(350, 75),
            .next(450, 85),
            .next(600, 95),
            .completed(800)
            ])
        
        XCTAssertEqual(hotObservable.subscriptions, [
            Subscription(200, 800)
            ])
        
    }
    
    func testErrorOut() {
        
        let scheduler = VirtualTimeScheduler()
        
        let hotObservable = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(100, 15),
            .next(250, 20),
            .next(300, 50),
            .next(350, 75),
            .next(450, 85),
            .next(550, 35),
            .next(600, 95),
            .error(800, testError),
            .next(900, 105),
            ])
        
        let observer = RecordObserver<Int>(scheduler: scheduler)
        
        scheduler.schedule(at: 200) {
            _ = hotObservable
                .filter { $0 > 50 }
                .subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(350, 75),
            .next(450, 85),
            .next(600, 95),
            .error(800, testError)
            ])
        
        XCTAssertEqual(hotObservable.subscriptions, [
            Subscription(200, 800)
            ])
    }
    
    func testAllTrue() {
        
        let scheduler = VirtualTimeScheduler()
        
        let hotObservable = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(100, 15),
            .next(250, 30),
            .next(300, 55),
            .next(350, 75),
            .next(450, 80),
            .next(550, 35),
            .next(600, 95),
            .completed(800),
            .error(900, testError),
            ])
        
        let observer = RecordObserver<Int>(scheduler: scheduler)
        
        scheduler.schedule(at: 200) {
            _ = hotObservable.filter { x in true } .subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(250, 30),
            .next(300, 55),
            .next(350, 75),
            .next(450, 80),
            .next(550, 35),
            .next(600, 95),
            .completed(800),
            ])
        
        XCTAssertEqual(hotObservable.subscriptions, [
            Subscription(200, 800)
            ])
    }
}
