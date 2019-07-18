//
//  FoundationExtensions.swift
//  Spotflock
//
//  Created by Krish on 18/07/19.
//  Copyright © 2019 Krish. All rights reserved.
//

import Foundation

extension URLResponse {
    var isSuccess: Bool {
        guard let response  = self as? HTTPURLResponse else { return false }
        return [200, 201].contains(response.statusCode)
    }
}


func onMainQueue(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async {
        closure()
    }
}
