//
//  Event.swift
//  Reactive
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public enum Event<E> {
    case next(E)
    case error(Swift.Error)
    case completed
}

extension Event: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .next(let element):
            return "next: \(element)"
        case .error(let error):
            return "error: \(error)"
        case .completed:
            return "completed"
        }
    }
}
