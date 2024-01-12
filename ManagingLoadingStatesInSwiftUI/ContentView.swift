//
//  ContentView.swift
//  ManagingLoadingStatesInSwiftUI
//
//  Created by test on 12.01.2024.
//

import SwiftUI

enum LoadingState {
    case none
    case loading
    case success(String)
    case error(Error)
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
                Task {
                    do {
                        try await performTimeConsumingOperation()
                    } catch {
                        
                    }
                }
            }.buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
