//
//  LastLocationViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit
import GoogleMaps

/// This class `LastLocationViewController` is used to manage specific logic in the application.
class LastLocationViewController: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
/// This variable `deviceLocalSettings` is used to store a specific value in the application.
    var deviceLocalSettings: [DeviceLocalSetting]?
    
/// This variable `locationManager` is used to store a specific value in the application.
    var locationManager = CLLocationManager()
    

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let deviceLocalSettings = deviceLocalSettings {
            deviceLocalSettings.forEach { deviceLocalSetting in
                if let lat = deviceLocalSetting.car.lastLatitude, let long = deviceLocalSetting.car.lastLongitude {
/// This variable `coordinate` is used to store a specific value in the application.
                    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(toANS(latlong: lat)), longitude: toANS(latlong: long))
/// This variable `mapMarker` is used to store a specific value in the application.
                    let mapMarker = GMSMarker()

                    mapMarker.position = coordinate
                    if let lastDate = deviceLocalSetting.car.lastZaman, let timeAgo = lastDate.toDateX()?.timeAgoDisplay() {
                        print(lastDate, timeAgo)
                        mapMarker.title = "\(timeAgo)"
                    }
                    mapMarker.tracksInfoWindowChanges = true
                    mapMarker.icon = UIImage(named: "car2")
                    mapMarker.map = self.mapView
                }
            }
            
            if deviceLocalSettings.count == 1 {
                if let lat = deviceLocalSettings[0].car.lastLatitude, let long = deviceLocalSettings[0].car.lastLongitude {
/// This variable `coordinate` is used to store a specific value in the application.
                    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(toANS(latlong: lat)), longitude: toANS(latlong: long))
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                        self.moveCameraOn(position: coordinate)
                    }
                }

            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
/// This variable `positions` is used to store a specific value in the application.
                    let positions = deviceLocalSettings.map { deviceLocalSetting -> CLLocationCoordinate2D in
                        if let lat = deviceLocalSetting.car.lastLatitude, let long = deviceLocalSetting.car.lastLongitude {
/// This variable `coordinate` is used to store a specific value in the application.
                            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.toANS(latlong: lat)), longitude: self.toANS(latlong: long))
                            return coordinate
                        } else {
                            return CLLocationCoordinate2D()
                        }
                    }
                    
                    self.moveCameraOn(positions: positions)
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
    
/// This method `moveCameraOn` is used to perform a specific operation in a class or struct.
    func moveCameraOn(position: CLLocationCoordinate2D) {
/// This variable `camera` is used to store a specific value in the application.
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 16)
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
/// This method `moveCameraOn` is used to perform a specific operation in a class or struct.
    func moveCameraOn(positions: [CLLocationCoordinate2D]) {
        CATransaction.begin()
/// This variable `path` is used to store a specific value in the application.
        let path = GMSMutablePath()
        positions.forEach { position in
            path.add(position)
        }
/// This variable `bounds` is used to store a specific value in the application.
        let bounds = GMSCoordinateBounds.init(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
        CATransaction.commit()
    }
}

extension LastLocationViewController: GMSMapViewDelegate, CLLocationManagerDelegate {
    
/// This method `locationManager` is used to perform a specific operation in a class or struct.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

/// This variable `camera` is used to store a specific value in the application.
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 16)
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
}
