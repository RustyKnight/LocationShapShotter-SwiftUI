//
//  MKMapSnapshotterSnapshot+DropPin.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 20/1/2024.
//

import Foundation
import MapKit
import SwiftUI

// An extension which decouples the rendering of a "drop pin" into
// a snap shot image.  It also reduces the amount of additional
// code which gets crammed into a View
extension MKMapSnapshotter.Snapshot {
    #if canImport(AppKit)
    func drawDropPin(_ pin: NSImage, at point: NSPoint) -> Image {
        let snapshotImage = image
        let pinnedImage = NSImage(size: snapshotImage.size) { ctx in
            snapshotImage.draw(
                at: .zero,
                from: NSRect(origin: .zero, size: snapshotImage.size),
                operation: .sourceOver,
                fraction: 1.0
            )
            
            let fixedPinPoint = CGPoint(
                x: point.x - pin.size.width / 2,
                y: point.y - pin.size.height
            )
            pin.draw(
                at: fixedPinPoint,
                from: NSRect(origin: .zero, size: snapshotImage.size),
                operation: .sourceOver,
                fraction: 1.0
            )
        }
        return Image(nsImage: pinnedImage)
    }
    #elseif canImport(UIKit)
    func drawDropPin(_ pin: UIImage, at point: CGPoint) -> Image {
        let snapshotImage = image
        let renderer = UIGraphicsImageRenderer(size: snapshotImage.size)
        let pinnedImage = renderer.image(actions: { ctx in
            snapshotImage.draw(at: CGPoint.zero)
            pin.draw(
                at: CGPoint(
                    x: point.x - pin.size.width / 2,
                    y: point.y - pin.size.height
                )
            )
        })
        return Image(uiImage: pinnedImage)
    }
    #endif
}
