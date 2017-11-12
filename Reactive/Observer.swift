//
//  Observer.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class Observer<E> {
    
    public let on: (Event<E>) -> Void
    
    public init(_ on: @escaping (Event<E>) -> Void) {
        self.on = on
    }
}
