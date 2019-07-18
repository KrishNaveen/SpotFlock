//
//  LoginViewController.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome!"
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if userNameField.isValidEmail == false {
            showAlert(with: AppConstants.invalidEmailAlertText, actions: nil)
        } else if passwordField.text?.isEmpty ?? true {
            showAlert(with: AppConstants.emptyPasswordAlertText, actions: nil)
        } else {
            KRProgressHUD.show(withMessage: AppConstants.loginMessage)
            SearviceManager.sharedInstance.login(with: userNameField.unWrappedText, password: passwordField.unWrappedText) { [unowned self] (string) in
                print(string ?? "")
                onMainQueue {
                    if let errorMessage = string {
                        KRProgressHUD.showError()
                        self.showAlert(with: errorMessage)
                    } else {
                        KRProgressHUD.dismiss()
                        self.performSegue(withIdentifier: AppConstants.segueKeyToNavigateFeeds, sender: self)
                    }
                }
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
