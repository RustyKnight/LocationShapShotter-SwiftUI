//
//  OkayButton.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import Foundation
import SwiftUI

public typealias ActionHandler = () -> Void

public struct OkayButton: View {
    public var text: String = "Okay"
    public var action: ActionHandler? = nil
    public var body: some View {
        Button(text) {
            action?()
        }
    }
    
    public init(text: String = "Okay", action: ActionHandler? = nil) {
        self.text = text
        self.action = action
    }
}
