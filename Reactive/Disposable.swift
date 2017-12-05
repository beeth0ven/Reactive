//
//  Disposable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public protocol Disposable {
    func dispose()
}

public class Disposer: Disposable {
    
    public var isDisposed = false
    private var _dispose: () -> Void

    public init(_ dispose: @escaping () -> Void = {}) {
        _dispose = dispose
    }
    
    public func dispose() {
        guard !isDisposed else { return }
        isDisposed = true
        _dispose()
    }
    
    public func setDispose(_ dispose: @escaping () -> Void) {
        guard !isDisposed else { return dispose() }
        _dispose = dispose
    }
}
