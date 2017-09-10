//
//  ReactiveTests.swift
//  ReactiveTests
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class ReactiveTests: XCTestCase {
    
    func testExample() {
        
        let numbers: Observable<Int> = { observer -> Disposable in
            observer(.next(0))
            observer(.next(1))
            observer(.next(2))
            observer(.next(3))
            observer(.next(4))
            observer(.completed)
            observer(.next(5))
            return {
                print("on Dispose.")
            }
        }
        
        let doubled = map(numbers) { $0 * 2 }
        
        let disposable = doubled { event in
            switch event {
            case .next(let value):
                print("on Next:", value)
            case .error(let error):
                print("on Error:", error)
            case .completed:
                print("completed.")
            }
        }
        
        disposable()
    }
}
