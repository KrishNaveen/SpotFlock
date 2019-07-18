//
//  ViewController.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import UIKit

struct AppConstants {
    static let appName = "Spot Flock"
    static let invalidEmailAlertText = "Please enter valid Email"
    static let emptyPasswordAlertText = "Please enter Password"
    static let okTitle = "OK"
    static let emptyNameAlertText = "Please enter Name"
    static let emptyEmailAlertText = "Please enter Name"
    static let emptyPasswordConfirmationAlertText = "Please confirm Password"
    static let emptyMobileAlertText = "Please enter Mobile Number"
    static let passwordMismatchAlertText = "Please make sure passwork and confirm password should match"
    static let invalidMobileNumberAlertText = "Please enter valid Mobile number"
    
    static let tokenDefaultsKey = "Token"
    static let nameURLKey = "name"
    static let emailURLKey = "email"
    static let passwordURLKey = "password"
    static let confirmationPasswordURLKey = "password_confirmation"
    static let mobileURLKey = "mobile"
    static let genderURLKey = "gender"
    static let userKey = "user"
    static let apiTokenKey = "api_token"
    static let messageKey = "message"
    static let errorURLKey = "errors"
    
    static let maleString = "Male"
    static let femaleString = "Female"
    
    static let urlError = "Cannot send request"
    static let invalidResponseError = "Invalid Response"
    
    static let segueKeyToNavigateFeeds = "showFeed"
    
    static let loginMessage = "Logging in..."
    static let registerProgressMessage = "Registering..."
    
    
    static let registerURL = "https://gospark.app/api/v1/register"
    static let loginURL = "https://gospark.app/api/v1/login"
    static let feedURL = "https://gospark.app/api/v1/kstream"
}

