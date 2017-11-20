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
    
    func testSyncExample() {
        
        print("---------Before testSyncExample---------")
        
        let observable = AnyObservable<String> { observer in
            observer.on(.next("Sync 0"))
            observer.on(.next("Sync 1"))
            observer.on(.next("Sync 2"))
            observer.on(.completed)
            observer.on(.next("Sync 3"))
            return Disposable {
                print("Dispose")
            }
        }
        
        let observer = AnyObserver<String> { event in
            switch event {
            case .next(let element):
                print("next:", element)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }
        }
        
        let disposable = observable.subscribe(observer)
        
        //        disposable.dispose()
        
        print("---------After testSyncExample---------")
        
    }
    
    func testAsyncExample() {
        
        print("---------Before testAsyncExample---------")
        
        let observable = AnyObservable<String> { observer in
            DispatchQueue.main.async {
                print("---------Before testAsyncExample---------")
                observer.on(.next("Async 0"))
                observer.on(.next("Async 1"))
                observer.on(.next("Async 2"))
                observer.on(.completed)
                observer.on(.next("Async 3"))
                print("---------After testAsyncExample---------")
            }
            return Disposable {
                print("Dispose")
            }
        }
        
        let observer = AnyObserver<String> { event in
            switch event {
            case .next(let element):
                print("next:", element)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }
        }
        
        let disposable = observable.subscribe(observer)
        
        //        disposable.dispose()
        
        print("---------After testAsyncExample---------")
        
    }
}

