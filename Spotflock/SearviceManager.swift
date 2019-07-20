//
//  SearviceManager.swift
//  Spotflock
//
//  Created by Krish on 17/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import Foundation

enum ServiceType {
    case login
    case register
    case feed
    
    var url: String {
        switch self {
        case .login:
            return AppConstants.loginURL
        case .register:
            return AppConstants.registerURL
        case .feed:
            return AppConstants.feedURL
        }
    }
    
    var isFeed: Bool {
        switch self {
        case .feed:
            return true
        default:
            return false
        }
    }
    
    var httpMethod: String {
        switch self {
        case .feed:
            return "GET"
        default:
            return "POST"
        }
    }
}

class SearviceManager {
    
    public fileprivate(set) static var sharedInstance = SearviceManager()
    
    fileprivate var token: String? {
        return UserDefaults.standard.string(forKey: AppConstants.tokenDefaultsKey)
    }
    
    fileprivate func createURLRequest(for service: ServiceType, body: String, urlString: String? = nil) -> URLRequest? {
        guard let url = URL(string: urlString ?? service.url) else { return nil }
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        if service.isFeed {
            request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = service.httpMethod
        return request
    }
    
    func login(with userName: String, password: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        guard let urlRequest = createURLRequest(for: .login, body: "{\"\(AppConstants.emailURLKey)\":\"\(userName)\",\"\(AppConstants.passwordURLKey)\":\"\(password)\"}") else {
            completion(AppConstants.urlError)
            return
        }
        sendRequest(urlRequest) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription)
            }
            if let data = data {
                do {
                    guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        completion(AppConstants.invalidResponseError)
                        return
                    }
                    if response?.isSuccess ?? false, let user = dict?[AppConstants.userKey] as? [String: Any] {
                        UserDefaults.standard.set(user[AppConstants.apiTokenKey], forKey: AppConstants.tokenDefaultsKey)
                        completion(nil)
                    } else if let message = dict?[AppConstants.messageKey] as? String {
                        completion(message)
                    } else {
                        completion(AppConstants.invalidResponseError)
                    }
                }
            }
        }
    }
    
    func register(with body:  String, completion: @escaping (_ message: String, _ isSuccessful: Bool) -> Void) {
        guard let urlRequest = createURLRequest(for: .register, body: body) else {
            completion(AppConstants.urlError, false)
            return
        }
        sendRequest(urlRequest) { [unowned self] (data, response, error) in
            if let error = error {
                completion(error.localizedDescription, false)
            }
            if let data = data {
                do {
                    guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        completion(AppConstants.invalidResponseError, false)
                        return
                    }
                    if response?.isSuccess ?? false,let message = dict?[AppConstants.messageKey] as? String {
                        completion(message, true)
                    } else {
                        
                        completion(self.parseErrorMessage(from: dict), false)
                    }
                    print(dict as Any)
                }
            }
        }
    }
    
    fileprivate func sendRequest(_ urlRequest: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            completion(data, response, error)
        })
        task.resume()
    }
    
    func fetchFeed(from urlString: String? = nil, completion: @escaping (_ stream: StreamData) -> Void) {
        guard let urlRequest = createURLRequest(for: .feed, body: "") else { return }
        sendRequest(urlRequest) { [unowned self] (data, response, responseError) in
            guard response?.isSuccess ?? false,
                let data = data else { return }
            
            do {
                let streamData = try JSONDecoder().decode(StreamData.self, from: data)
                completion(streamData)
                //                if let url = streamData.kstream.next_page_url {
                //                    self.fetchFeed(from: url, completion: { (streamData) in
                //                        completion(streamData)
                //                    })
                //                }
            } catch {
                print(error)
            }
        }
    }
    
    fileprivate func parseErrorMessage(from dict: [String: Any]?) -> String {
        guard let errorDict = dict?[AppConstants.errorURLKey] as? [String: Any] else { return AppConstants.invalidResponseError }
        for (_, value) in errorDict {
            guard let value = value as? [String], value.count > 0 else { continue }
            return value.first!
        }
        return AppConstants.invalidResponseError
    }
    
    func cancelAllRequests() {
        URLSession.shared.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
    }
}
