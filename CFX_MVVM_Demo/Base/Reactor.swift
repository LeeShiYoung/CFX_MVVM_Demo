//
//  Reactor.swift
//  CFX_MVVM_Demo
//
//  Created by Young_Dev on 2019/4/3.
//  Copyright © 2019 Young_Dev. All rights reserved.
//

import Foundation
import RxSwift

protocol View: class, AssociatedObjectStore {
    
    associatedtype Rc: Reactor
    
    var reactor: Rc? { set get }
    
    func bind(reactor: Rc)
}

private var reactorKey: UInt = 0

extension View {
    var reactor: Rc? {
        set {
            self.setAssociatedObject(newValue, forKey: &reactorKey)
            
            if let reactor = newValue {
                self.bind(reactor: reactor)
            }
        }
        
        get {
            return self.associatedObject(forKey: &reactorKey)
        }
    }
}


protocol Reactor: class, AssociatedObjectStore {
    
    associatedtype Action
    
    associatedtype State
    
    func handleAction(action: Action) -> State

    var action: PublishSubject<Action> { get }
    
    var initialState: State { set get }
    
    var currentState: State { get }
    
    var state: Observable<State> { get }

    
}

private var stateKey: UInt = 0
private var actionKey: UInt = 0
private var observableStateKey: UInt = 0

extension Reactor {
    var currentState: State {
        return associatedObject(forKey: &stateKey, default: self.initialState)
    }
    
    var action: PublishSubject<Action> {
        return associatedObject(forKey: &actionKey, default: .init())
    }
    
    var state: Observable<State> {
        return associatedObject(forKey: &observableStateKey, default: createStateObservable())
    }
    
    
    func createStateObservable() -> Observable<State> {
        return self.action.map({[weak self] action -> State in
            self!.handleAction(action: action)
        })
    }
}

