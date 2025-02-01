//
//  MKMapViewExtention.swift
//  JobLoyal
//
//  Created by Sina khanjani on 2/27/1400 AP.
//

import Foundation
import MapKit

public extension MKMapView {
/// This method `centerToLocation` is used to perform a specific operation in a class or struct.
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
/// This variable `coordinateRegion` is used to store a specific value in the application.
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        setRegion(coordinateRegion, animated: true)
        
/// This variable `mapCamera` is used to store a specific value in the application.
        let mapCamera = MKMapCamera(lookingAtCenter: coordinateRegion.center, fromDistance: regionRadius, pitch: 0, heading: 0)
        
        setCamera(mapCamera, animated: true)
    }
}
