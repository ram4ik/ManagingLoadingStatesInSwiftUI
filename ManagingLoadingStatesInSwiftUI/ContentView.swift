//
//  ContentView.swift
//  ManagingLoadingStatesInSwiftUI
//
//  Created by test on 12.01.2024.
//

import SwiftUI

enum LoadingState: Equatable {
    case none
    case loading
    case success(String)
    case error(Error)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
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

struct ContentView: View {
    
    @State private var loadingState: LoadingState = .none
    
    private func performTimeConsumingOperation() async throws -> String {
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return "Batman"
    }
    
    var body: some View {
        VStack {
            Button("Perform Time Consuming Operation") {
                loadingState = .loading
            }.buttonStyle(.borderedProminent)
            
            switch loadingState {
            case .none:
                EmptyView()
            case .loading:
                ProgressView("Loading...")
            case .success(let movieName):
                Text(movieName)
            case .error(let error):
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .task(id: loadingState) {
            if loadingState == .loading {
                do {
                    let movieName = try await performTimeConsumingOperation()
                    loadingState = .success(movieName)
                } catch {
                    loadingState = .error(error)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
