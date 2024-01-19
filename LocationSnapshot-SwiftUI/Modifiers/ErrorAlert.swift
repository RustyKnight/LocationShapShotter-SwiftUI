//
//  ErrorAlert.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import Foundation
import SwiftUI

public struct ErrorAlert: ViewModifier {
    public let title: String
    public let message: String?
    public var error: Error?
    @Binding public var isShowing: Bool
    
    public func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isShowing) {
                OkayButton()
            } message: {
                VStack {
                    if let message {
                        Text(message)
                    }
                    if let error {
                        Text(error.localizedDescription)
                            .padding(.top)
                    } else {
                        EmptyView()
                    }
                }
            }
        
    }
}

public extension View {
    func errorAlert(
        title: String,
        message: String? = nil,
        error: Error?,
        isShowing: Binding<Bool>
    ) -> some View {
        self.modifier(
            ErrorAlert(
                title: title,
                message: message,
                error: error,
                isShowing: isShowing
            )
        )
    }
}
