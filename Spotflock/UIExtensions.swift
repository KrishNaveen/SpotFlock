//
//  UIExtensions.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with body: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: AppConstants.appName, message: body, preferredStyle: .alert)
        add(actions: actions, for: alert)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func add(actions: [UIAlertAction]?, for alert: UIAlertController) {
        if let actions = actions, actions.count > 0 {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: AppConstants.okTitle, style: .default, handler: nil))
        }
    }
}

extension UITextField {
    var unWrappedText: String {
        return text ?? ""
    }
    
    var isValidEmail: Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", EMAIL_REGEX)
        return emailPredicate.evaluate(with: text)
    }
    
    var isValidMobileNumber: Bool {
        let PHONE_REGEX = "^[6-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phonePredicate.evaluate(with: text)
    }
}
