//
//  Map.swift
//  Reactive
//
//  Created by luojie on 2017/9/13.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension IsObservable {
    
    public func map<R>(_ transform: @escaping (E) throws -> R) -> Observable<R> {
        return Map(source: self.asObservable(), transform: transform)
    }
}


private class MapSink<Element, O: IsObserver>: Sink<O>, IsObserver {
    typealias E = Element
    typealias R = O.E
    typealias Transform = (E) throws -> R
    
    private let _transform: Transform
    
    init(transform: @escaping Transform, observer: O, cancel: Cancelable) {
        _transform = transform
        super.init(observer: observer, cancel: cancel)
    }

    func on(_ event: Event<Element>) {
        switch event {
        case .next(let element):
            do {
                let result = try _transform(element)
                forwardOn(.next(result))
            } catch let error {
                forwardOn(.error(error))
            }
        case .error(let error):
            forwardOn(.error(error))
        case .completed:
            forwardOn(.completed)
        }
    }
}

private class Map<SourceElement, R>: Producer<R> {
    typealias Transform = (SourceElement) throws -> R

    private let _source: Observable<SourceElement>
    private let _transform: Transform
    
    init(source: Observable<SourceElement>, transform: @escaping Transform) {
        _source = source
        _transform = transform
    }
    
    override func run<O>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where R == O.E, O : IsObserver {
        let sink = MapSink(transform: _transform, observer: observer, cancel: cancel)
        let subscription = _source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}
