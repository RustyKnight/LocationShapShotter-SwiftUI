//
//  Assets.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(AppKit)
extension NSImage.Name {
    static let beer = NSImage.Name("Beer")
}
#endif

struct Assets {
    // We should be able to gurentee that the images
    // from the asset cataglog are loadable, if they're
    // not then that's a issue we need to correct
    #if canImport(UIKit)
    static var beerPin: UIImage = {
        UIImage(named: "Beer")!
    }()
    #elseif canImport(AppKit)
    static var beerPin: NSImage = {
        NSImage(named: .beer)!
    }()
    #endif
}
