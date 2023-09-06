//
//  AlertDisplayable.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 06.09.23.
//

import UIKit

protocol AlertDisplayable: AnyObject {
    func showButtonAlert(_ model: ButtonAlertModel)
}

struct ButtonAlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let buttonAction: ((UIAlertAction) -> Void)?
    
    init(title: String,
         message: String,
         buttonTitle: String,
         buttonAction: ((UIAlertAction) -> Void)?) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
}

extension UIViewController: AlertDisplayable {
    
    func showButtonAlert(_ model: ButtonAlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: model.buttonTitle,
                                      style: .default,
                                      handler: model.buttonAction))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPairButtonAlert(_ model: ButtonAlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: model.buttonTitle,
                                      style: .default,
                                      handler: model.buttonAction))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
