//
//  ContentView.swift
//  ManagingLoadingStatesInSwiftUI
//
//  Created by test on 12.01.2024.
//

import SwiftUI

enum NetworkError: Error {
    case operationFailed
}

struct Movie: Codable, Equatable {
    let title: String
}

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

struct ContentView: View {
    
    @State private var loadingState: LoadingState<Movie> = .none
    
    private func performTimeConsumingOperation() async throws -> Movie {
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        //throw NetworkError.operationFailed
        return Movie(title: "Batman")
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
            case .success(let movie):
                Text(movie.title)
            case .error(let error):
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .task(id: loadingState) {
            if loadingState == .loading {
                do {
                    let movie = try await performTimeConsumingOperation()
                    loadingState = .success(movie)
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
