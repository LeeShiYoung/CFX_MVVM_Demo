//
//  ViewController.swift
//  CFX_MVVM_Demo
//
//  Created by Young_Dev on 2019/4/3.
//  Copyright © 2019 Young_Dev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, View {
    
    @IBOutlet weak var accountLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        reactor = ViewModel()
        
    }
    
    func bind(reactor: ViewModel) {
        
        Observable
            .combineLatest(accountLabel.rx.text, passwordLabel.rx.text)
            .map { (account, password) -> Rc.Action in
                return Rc.Action.verify(account: account!, password: password!)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        loginButton
            .rx
            .tap
            .map { [weak self] in
                Rc.Action.login(account: (self?.accountLabel.text)!, password: (self?.passwordLabel.text)!)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor
            .state
            .map { $0.isVerify }
            .map { $0 ? "符合规则" : "不符合规则" }
            .bind(to: warningLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor
            .state
            .map { $0.isVerify }
            .map { $0 ? .blue : .red }
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    
        
        reactor
            .state
            .map { $0.isVerify }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor
            .state
            .subscribe(onNext: { state in
                print(state)
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UIButton {
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { button, color in
            button.backgroundColor = color
        }
    }
}

private var bagKey: UInt = 0
extension NSObject: AssociatedObjectStore {
    
    var disposeBag: DisposeBag {
        return associatedObject(forKey: &bagKey, default: DisposeBag())
        
    }
}


