//
//  LoadingWrapperView.swift
//  ManagingLoadingStatesInSwiftUI
//
//  Created by test on 12.01.2024.
//

import SwiftUI

struct LoadingWrapperView<T: Codable & Equatable, Content: View, LoadingContent: View, SuccessContent: View, FailureContent: View>: View {
    
    let loadingState: LoadingState<T>
    let content: () -> Content
    let loadingContent: () -> LoadingContent
    let successContent: (T) -> SuccessContent
    let failureContent: (Error) -> FailureContent
    
    init(loadingState: LoadingState<T>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder loadingContent: @escaping () -> LoadingContent, @ViewBuilder successContent: @escaping (T) -> SuccessContent, @ViewBuilder failureContent: @escaping (Error) -> FailureContent) {
        self.loadingState = loadingState
        self.content = content
        self.loadingContent = loadingContent
        self.successContent = successContent
        self.failureContent = failureContent
    }
    
    var body: some View {
        VStack {
            content()
            
            switch loadingState {
            case .none:
                EmptyView()
            case .loading:
                loadingContent()
            case .success(let value):
                successContent(value)
            case .error(let error):
                failureContent(error)
            }
        }
    }
}
