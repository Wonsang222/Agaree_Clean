//
//  Observable.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/9/24.
//

import Foundation

final class Observable<T> {
    
    struct Observer {
        weak var observer: AnyObject?
        let block: (T) -> Void
    }
    
    init(value: T) {
        self.value = value
    }
    
    private var observers = [Observer]()
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.block(value)
        }
    }
    
    func observe(
        on object: AnyObject,
        block: @escaping (T) -> Void
    ) {
        let observer = Observer(observer: object, block: block)
        observers.append(observer)
    }
    
    func remove(on object: AnyObject) {
        observers = observers.filter { $0.observer !== object }
    }
}
