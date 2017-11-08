//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation

public class Observable<E> {
    
    public let subscribe: (Observer<E>) -> Disposable
    
    init(_ subscribe: @escaping (Observer<E>) -> Disposable) {
        self.subscribe = subscribe
    }
}
