
//
//  ViewModel.swift
//  CFX_MVVM_Demo
//
//  Created by Young_Dev on 2019/4/3.
//  Copyright © 2019 Young_Dev. All rights reserved.
//

import UIKit
import RxSwift

class ViewModel: Reactor {
  
    enum Action {
        case verify(account: String, password: String)
        case login(account: String, password: String)
    }
    
    struct State {
        var model = Model(account: "", password: "")
        
        var isVerify: Bool = false
        
        var isLogined: Bool = false
        
    }
    
    var initialState = State()
    
    func handleAction(action: ViewModel.Action) -> ViewModel.State {
        
        print(#function)
        
        var state = initialState
        
        switch action {
        case let .verify(account, password):
            state.isVerify = (account.count > 5 && password.count > 6) ? true : false
            return state
            
        case let .login(account, password):
            state.model.account = account
            state.model.password = password
            state.isLogined = true
            return state
        }
    }
}
