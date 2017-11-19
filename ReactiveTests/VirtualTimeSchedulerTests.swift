//
//  VirtualTimeScheduler.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class VirtualTimeSchedulerTests: XCTestCase {
    
    func testExample() {
        
        var testScheduler = VirtualTimeScheduler()
        let subject = PublishSubject<String>()
        let observer = Observer<String> { print($0) }
        
        testScheduler.schedule(at: 200) { _ = subject.subscribe(observer.on) }
        testScheduler.schedule(at: 300) { subject.on(.next("300")) }
        testScheduler.schedule(at: 400) { subject.on(.next("400")) }
        testScheduler.schedule(at: 500) { subject.on(.next("500")) }
        testScheduler.schedule(at: 600) { subject.on(.completed) }
        testScheduler.schedule(at: 700) { subject.on(.next("700")) }
        testScheduler.start()
    }
}
