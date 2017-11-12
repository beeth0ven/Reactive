//
//  MapTest.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class MapTests: XCTestCase {
    
    func testExample() {
        print("---------Before testExample---------")
        
        let observable = Observable<String> { observer in
            observer.on(.next("Element 0"))
            observer.on(.next("Element 1"))
            observer.on(.next("Element 2"))
            observer.on(.completed)
            observer.on(.next("Element 3"))
            return Disposable {
                print("Dispose")
            }
        }
        
        let transformed = observable
            .map { text in "Mapped " + text }
        
        let observer = Observer<String> { event in
            switch event {
            case .next(let element):
                print("next:", element)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }
        }
        
        let disposable = transformed.subscribe(observer)
        
        print("---------After testSyncExample---------")
    }
}
