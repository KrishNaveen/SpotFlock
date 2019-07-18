//
//  RegistationViewController.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit
import KRProgressHUD

class RegistationViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    fileprivate let errorsList = [AppConstants.emptyNameAlertText, AppConstants.emptyEmailAlertText, AppConstants.emptyPasswordAlertText, AppConstants.emptyPasswordConfirmationAlertText, AppConstants.emptyMobileAlertText]
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if validateFields() {
            KRProgressHUD.show(withMessage: AppConstants.registerProgressMessage)
            sendRegistrationRequest()
        }
    }
    
    fileprivate func validateFields() -> Bool {
        for i in 1...5 {
            guard let field = view.viewWithTag(i) as? UITextField, field.text?.isEmpty ?? true else { continue }
            showAlert(with: errorsList[i - 1])
            return false
        }
        if !emailField.isValidEmail {
            showAlert(with: AppConstants.invalidEmailAlertText)
            return false
        }
        if passwordField.text != confirmPasswordField.text {
            showAlert(with: AppConstants.passwordMismatchAlertText)
            return false
        }
        if !mobileField.isValidMobileNumber {
            showAlert(with: AppConstants.invalidMobileNumberAlertText)
            return false
        }
        return true
    }
    
    fileprivate func sendRegistrationRequest() {
        SearviceManager.sharedInstance.register(with: prepareRequestBody()) { [unowned self] (message, isSuccess) in
            onMainQueue {
                KRProgressHUD.dismiss()
            }
            let alertAction = UIAlertAction(title: AppConstants.okTitle, style: .default, handler: { [unowned self, isSuccess] _ in
                if isSuccess {
                    onMainQueue {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            onMainQueue {
                self.showAlert(with: message, actions: [alertAction])
            }
        }
    }
    
    fileprivate func prepareRequestBody() -> String {
        return "{\"\(AppConstants.nameURLKey)\":\"\(nameField.unWrappedText)\", \"\(AppConstants.emailURLKey)\":\"\(emailField.unWrappedText)\", \"\(AppConstants.passwordURLKey)\":\"\(passwordField.unWrappedText)\", \"\(AppConstants.confirmationPasswordURLKey)\":\"\(confirmPasswordField.unWrappedText)\", \"\(AppConstants.mobileURLKey)\":\"\(mobileField.unWrappedText)\", \"\(AppConstants.genderURLKey)\":\"\(genderSegment.selectedSegmentIndex == 0 ? AppConstants.maleString : AppConstants.femaleString)\"}"
    }
    
}
