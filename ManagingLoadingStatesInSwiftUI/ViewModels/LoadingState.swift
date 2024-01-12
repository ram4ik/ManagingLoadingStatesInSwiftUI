//
//  LoadingState.swift
//  ManagingLoadingStatesInSwiftUI
//
//  Created by test on 12.01.2024.
//

import Foundation

enum LoadingState<T: Codable & Equatable>: Equatable {
    case none
    case loading
    case success(T)
    case error(Error)
    
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.loading, .loading):
            return true
        case let (.success(lhsValue), .success(rhsValues)):
            return lhsValue == rhsValues
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
