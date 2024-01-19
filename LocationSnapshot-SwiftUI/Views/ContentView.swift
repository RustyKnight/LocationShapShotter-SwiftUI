//
//  ContentView.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import SwiftUI
import MapKit
import Cadmus

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var mapSnaphot: Image?
    @State private var streetSnaphot: Image?

    @State private var error: Swift.Error?
    @State private var showError = false

    var body: some View {
        VStack(spacing: 8) {
            locationSnapShotView()
            streetViewSnapShotView()
        }
        .task {
            guard let location = locationManager.location else { return }
            log(debug: "locationManager.location = \(String(describing: locationManager.location))")
            do {
                async let snapShot: Void = loadMapSnapshot(location)
                async let streetView: Void = loadStreetViewAt(location)
                
                _ = try await (snapShot, streetView)
            } catch {
                log(error: error)
            }
        }
        .errorAlert(
            title: "Failed to set state",
            error: error,
            isShowing: $showError
        )
        .padding()
    }
    
    private func locationSnapShotView() -> some View {
        guard let mapSnaphot else {
            return AnyView(emptyView(systemName: "mappin.and.ellipse"))
        }
        
        return AnyView(
            framedView(content: mapSnaphot)
        )
    }
    
    private func streetViewSnapShotView() -> some View {
        guard let streetSnaphot else {
            return AnyView(emptyView(systemName: "camera.fill"))
        }
        
        return AnyView(
            framedView(content: streetSnaphot)
        )
    }

    private func emptyView(systemName: String) -> some View {
        let image = Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 64)
        return framedView(content: image)
    }
    
    private func framedView(content contentView: some View) -> some View {
        ZStack {
            // This makes sure that the area is sizable
            // based on my needs
            Rectangle()
                .foregroundColor(Color.darkGray)
            contentView
        }
        .background(Color.gray.brightness(-0.25))
        .frame(width: 256, height: 256)
        .fixedSize()
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
        .stroke(
            color: Color.secondary,
            width: 1
        )
    }
    
    private func loadStreetViewAt(_ location: CLLocation) async throws {
        guard
            let scene = try await MKLookAroundSceneRequest(
                coordinate: location.coordinate
            )
                .scene
        else { return }
        let options = MKLookAroundSnapshotter.Options()
        options.size = CGSize(width: 256, height: 256)
        
        let snapShot = try await MKLookAroundSnapshotter(
            scene: scene,
            options: options
        )
        .snapshot
        
        #if canImport(AppKit)
        streetSnaphot = Image(nsImage: snapShot.image)
        #elseif canImport(UIKit)
        streetSnaphot = Image(uiImage: snapShot.image)
        #endif
    }
    
    private func loadMapSnapshot(_ location: CLLocation) async throws {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        options.showsBuildings = true
        
        let config = MKStandardMapConfiguration()
        config.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [])
        options.preferredConfiguration = config
        
        let snapshot = try await MKMapSnapshotter(options: options).start()
        
        mapSnaphot = snapshot
            .drawDropPin(
                Assets.beerPin,
                at: snapshot.point(for: location.coordinate)
            )
    }
}

#Preview {
    ContentView()
}
