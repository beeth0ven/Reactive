//
//  Disposable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation

public class Disposable {
    
    public let dispose: () -> Void
    
    public init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
}
