/*
 * Copyright 2020 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import GoogleMaps
import RestfulAPI
import SwiftyJSON

/// This class `RouteXXViewController` is used to manage specific logic in the application.
class RouteXXViewController: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
/// This variable `timer` is used to store a specific value in the application.
    var timer: Timer?
/// This variable `currentTimerStep` is used to store a specific value in the application.
    var currentTimerStep: Int = 0
    
/// This variable `locationManager` is used to store a specific value in the application.
    var locationManager = CLLocationManager()

    // MARK: Define the source latitude and longitude
/// This variable `sourceLat` is used to store a specific value in the application.
    let sourceLat = 35.734888
/// This variable `sourceLng` is used to store a specific value in the application.
    let sourceLng = 51.438199
    
    // MARK: Define the destination latitude and longitude
/// This variable `destinationLat` is used to store a specific value in the application.
    let destinationLat = 35.737897
/// This variable `destinationLng` is used to store a specific value in the application.
    let destinationLng = 51.432008
    
/// This variable `sourceMarker` is used to store a specific value in the application.
    let sourceMarker = GMSMarker()
/// This variable `destinationMarker` is used to store a specific value in the application.
    let destinationMarker = GMSMarker()
/// This variable `carMarker` is used to store a specific value in the application.
    let carMarker = GMSMarker()

/// This variable `polyline` is used to store a specific value in the application.
    var polyline: GMSPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        fetchCoordinatePoints()
    }
    
/// This method `startRouteAnimate` is used to perform a specific operation in a class or struct.
    func startRouteAnimate(objects: [IMEIPoint]) {
/// This variable `objectsCount` is used to store a specific value in the application.
        let objectsCount = objects.count
/// This variable `staticTimeInterval` is used to store a specific value in the application.
        let staticTimeInterval: TimeInterval = 6.0
/// This variable `timeIntervalSpeed` is used to store a specific value in the application.
        let timeIntervalSpeed = staticTimeInterval/TimeInterval(objectsCount)
        
        timer = Timer.scheduledTimer(withTimeInterval: timeIntervalSpeed, repeats: true, block: { [weak self] timer in
            if let self = self {
/// This variable `positionsObjects` is used to store a specific value in the application.
                var positionsObjects = objects.map { item -> CLLocationCoordinate2D in
                    if let latitude = item.latitude, let longitude = item.longitude {
/// This variable `latDouble` is used to store a specific value in the application.
                        let latDouble = self.toANS(latlong: latitude)
/// This variable `longDouble` is used to store a specific value in the application.
                        let longDouble = self.toANS(latlong: longitude)
                        
/// This variable `lat` is used to store a specific value in the application.
                        let lat = CLLocationDegrees(latDouble)
/// This variable `long` is used to store a specific value in the application.
                        let long = CLLocationDegrees(longDouble)
                        
                        return CLLocationCoordinate2D(latitude: lat, longitude: long)
                    }
                    
                    return CLLocationCoordinate2D()
                }
                
/// This variable `objects` is used to store a specific value in the application.
                var objects = objects
                
                if self.currentTimerStep < objects.count {
                    if self.currentTimerStep > 0 {
/// This variable `deletedRange` is used to store a specific value in the application.
                        let deletedRange = 0...self.currentTimerStep
                        
                        positionsObjects.removeSubrange(deletedRange)
                        objects.removeSubrange(deletedRange)
                    }
                    
                    if let firstPosition = positionsObjects.first {
/// This variable `markerContentView` is used to store a specific value in the application.
                        let markerContentView = MarkerContentView(frame: CGRect(x: 0, y: 0, width: 240, height: 64))
                        if let object = objects.first, let speed = object.speed?.toDouble()?.rounded(toPlaces: 1) {
                            markerContentView.descriptionLabel.text = "سرعت \(speed)"
                        }
                        if let object = objects.first, let _ = object.zaman {
                            markerContentView.titleLabel.text = "زمان \(15):\(22)"
                        }

                        self.carMarker.position = CLLocationCoordinate2D(latitude: firstPosition.latitude, longitude: firstPosition.longitude)
                        self.carMarker.iconView = markerContentView

                        self.polyline?.map = nil
                        self.polyline = nil
                    }
                    
                    self.polyline = self.drawRoute(coordinates: positionsObjects, polylineStrokeColor: .blue)
                    self.polyline?.map = self.mapView
                }
                
                self.currentTimerStep += 1
                if objects.count == self.currentTimerStep {
                    self.currentTimerStep = 0
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        })
    }
    
/// This method `drawRoute` is used to perform a specific operation in a class or struct.
    func drawRoute(coordinates: [CLLocationCoordinate2D], polylineStrokeColor: UIColor) -> GMSPolyline {
/// This variable `path` is used to store a specific value in the application.
        let path = GMSMutablePath()
        
        for coord in coordinates {
            path.add(coord)
        }
        
/// This variable `polyline` is used to store a specific value in the application.
        let polyline = GMSPolyline(path: path)
        
        polyline.strokeColor = polylineStrokeColor
        polyline.strokeWidth = 3.0
        
        return polyline
    }
    
/// This method `moveCameraOn` is used to perform a specific operation in a class or struct.
    func moveCameraOn(position1: CLLocationCoordinate2D, position2: CLLocationCoordinate2D) {
        CATransaction.begin()
/// This variable `path` is used to store a specific value in the application.
        let path = GMSMutablePath()
        path.add(position1)
        path.add(position2)
/// This variable `bounds` is used to store a specific value in the application.
        let bounds = GMSCoordinateBounds.init(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
        CATransaction.commit()
    }
    
/// This method `fetchCoordinatePoints` is used to perform a specific operation in a class or struct.
    func fetchCoordinatePoints() {
        Auth.shared.authenticate(with: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIxMjMiLCJJc0Jsb2NrZWQiOiJGYWxzZSIsIm5iZiI6MTY1NzM2MjU0NSwiZXhwIjoxNjU3MzczMzQ1LCJpYXQiOjE2NTczNjI1NDUsImlzcyI6Imh0dHA6Ly9jb2Rpbmdzb25hdGEuY29tIiwiYXVkIjoiaHR0cDovL2NvZGluZ3NvbmF0YS5jb20ifQ.vOiGphw6dfWWNWeHIHiAVdIXkjt-Ag-vh46R27VPXxo")
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<[IMEIPoint]>>
            .init(path: "/GetRoute")
            .with(queries: [
                //                "imei":"865328023778128",
                //                "startDate":"210701123344",
                //                "endDate":"220703123344",
                "routeId":"12897858"
            ])
            .with(auth: .auth1)
        
        handleRequestByUI(network) { [weak self] data in
            if let self = self {
                if let items = data {
/// This variable `coordinates` is used to store a specific value in the application.
                    let coordinates = items.map { item -> CLLocationCoordinate2D in
                        if let latitude = item.latitude, let longitude = item.longitude {
/// This variable `latDouble` is used to store a specific value in the application.
                            let latDouble = self.toANS(latlong: latitude)
/// This variable `longDouble` is used to store a specific value in the application.
                            let longDouble = self.toANS(latlong: longitude)
                            
/// This variable `lat` is used to store a specific value in the application.
                            let lat = CLLocationDegrees(latDouble)
/// This variable `long` is used to store a specific value in the application.
                            let long = CLLocationDegrees(longDouble)
                            
                            return CLLocationCoordinate2D(latitude: lat, longitude: long)
                        }
                        
                        return CLLocationCoordinate2D()
                    }
                    
                    if let firstCoordinate = coordinates.first, let lastCoordinate = coordinates.last {
                        // DRAW
                        self.drawRoute(coordinates: coordinates, polylineStrokeColor: .red).map = self.mapView
                        // A
                        self.sourceMarker.position = firstCoordinate
                        self.sourceMarker.title = ""
                        self.sourceMarker.snippet = ""
                        self.sourceMarker.icon = UIImage(named: "apoint")
                        self.sourceMarker.map = self.mapView
                        // B
                        self.destinationMarker.position = lastCoordinate
                        self.destinationMarker.title = ""
                        self.destinationMarker.snippet = ""
                        self.destinationMarker.icon = UIImage(named: "bpoint")
                        self.destinationMarker.map = self.mapView
                        
                        // CAR MARKER
/// This variable `markerContentView` is used to store a specific value in the application.
                        let markerContentView = MarkerContentView(frame: CGRect(x: 0, y: 0, width: 240, height: 64))
                        if let object = items.first, let speed = object.speed?.toDouble()?.rounded(toPlaces: 2) {
                            markerContentView.descriptionLabel.text = "سرعت \(speed)"
                        }
                        if let object = items.first, let _ = object.zaman {
                            markerContentView.titleLabel.text = "زمان \(15):\(22)"
                        }
                        
                        self.carMarker.position = CLLocationCoordinate2D(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                        self.carMarker.iconView = markerContentView
                        self.carMarker.title = ""
                        self.carMarker.snippet = ""
                        self.carMarker.map = self.mapView
                        
                        self.moveCameraOn(position1: firstCoordinate, position2: lastCoordinate)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        self.startRouteAnimate(objects: items)
                    }
                }
            }
        }
    }
    
    public func toANS(latlong: String) -> Double {
/// This variable `latLong` is used to store a specific value in the application.
        let latLong: Double = Double(latlong)!
/// This variable `ans` is used to store a specific value in the application.
        var ans: Double = latLong / 100;
/// This variable `deg` is used to store a specific value in the application.
        let deg: Double = floor(ans)
/// This variable `min` is used to store a specific value in the application.
        var min: Double = ans - deg;
        min = min * 10 / 6;
        ans = deg + min;
        return ans;
    }
}

extension RouteXXViewController: GMSMapViewDelegate, CLLocationManagerDelegate {

/// This method `locationManager` is used to perform a specific operation in a class or struct.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

/// This variable `camera` is used to store a specific value in the application.
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 16)
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
}


//    func drawRoute(position1: CLLocationCoordinate2D, position2: CLLocationCoordinate2D, polylineStrokeColor: UIColor) {
//        // MARK: Create source location and destination location so that you can pass it to the URL
//        let sourceLocation = "\(sourceLat),\(sourceLng)"
//        let destinationLocation = "\(destinationLat),\(destinationLng)"
//
//        // MARK: Create URL
//        let url = "https://api.neshan.org/v4/direction/no-traffic?origin=\(sourceLocation)&destination=\(destinationLocation)"
//
//        var request = URLRequest(url: URL(string: url)!)
//        request.addValue("service.40cb5b98717e4514ae1cfd5815ff3a34", forHTTPHeaderField: "Api-Key")
//
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
//            if let self = self {
//                if let data = data {
//                    DispatchQueue.main.async {
//                        let jsonData = try? JSON(data: data)
//                        if let jsonData = jsonData {
//                            let routes = jsonData["routes"].arrayValue
//
//                            for route in routes {
//                                let overview_polyline = route["overview_polyline"].dictionary
//                                let points = overview_polyline?["points"]?.string
//
//                                let path = GMSPath.init(fromEncodedPath: points ?? "")
//
//                                self.polyline = GMSPolyline.init(path: path)
//                                self.polyline?.strokeColor = polylineStrokeColor
//                                self.polyline?.strokeWidth = 5
//                                self.polyline?.map = self.mapView
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        task.resume()
//    }
