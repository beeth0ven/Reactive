//
//  SubscribeOn.swift
//  Reactive
//
//  Created by luojie on 2017/11/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension ObservableType {
    
    public func subscribeOn(_ scheduler: Scheduler) -> AnyObservable<Element> {
        
        return AnyObservable.create { [source = self, scheduler] observer in
            let _disposer = Disposer()
            scheduler.async { [source, observer, _disposer] in
                let disposable = source.subscribe(observer)
                _disposer.setDispose(disposable.dispose)
            }
            return _disposer
        }
    }
}

extension ObservableType {
    
    public func observeOn(_ scheduler: Scheduler) -> AnyObservable<Element> {
        
        return AnyObservable.create { [source = self, scheduler] observer in
            let _sourceDisposer = source.subscribe(AnyObserver { [scheduler, observer] event in
                scheduler.async {
                    observer.on(event)
                }
            })
            return _sourceDisposer
        }
    }
}
