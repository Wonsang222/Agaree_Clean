//
//  ConnectionError.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError,
              error.isInternetConnectionError else {
                  return false
              }
        return true
    }
}
