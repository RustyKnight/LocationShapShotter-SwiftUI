//
//  NSImage+Graphics.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

#if canImport(AppKit)
import AppKit

extension NSImage {
    convenience init(size: CGSize, actions: (CGContext) -> Void) {
        self.init(size: size)
        lockFocusFlipped(false)
        actions(NSGraphicsContext.current!.cgContext)
        unlockFocus()
    }
}
#endif
