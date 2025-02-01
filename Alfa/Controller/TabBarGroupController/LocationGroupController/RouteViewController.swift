//
//  RouteViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/21/1401 AP.
//

import UIKit
import GoogleMaps
import RestfulAPI
import SwiftyJSON
import ProgressHUD
import ProgressHUD

/// This class `RouteViewController` is used to manage specific logic in the application.
class RouteViewController: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
/// This variable `timer` is used to store a specific value in the application.
    var timer: Timer?
/// This variable `currentTimerStep` is used to store a specific value in the application.
    var currentTimerStep: Int = 0
    
/// This variable `locationManager` is used to store a specific value in the application.
    var locationManager = CLLocationManager()
    
/// This variable `sourceMarker` is used to store a specific value in the application.
    let sourceMarker = GMSMarker()
/// This variable `destinationMarker` is used to store a specific value in the application.
    let destinationMarker = GMSMarker()
/// This variable `carMarker` is used to store a specific value in the application.
    let carMarker = GMSMarker()
/// This variable `polyline` is used to store a specific value in the application.
    var polyline: GMSPolyline?
/// This variable `redPolyline` is used to store a specific value in the application.
    var redPolyline: GMSPolyline?
    
/// This variable `startDate` is used to store a specific value in the application.
    var startDate: Date?
/// This variable `endDate` is used to store a specific value in the application.
    var endDate: Date?
/// This variable `selectedIndex` is used to store a specific value in the application.
    var selectedIndex: Int?
/// This variable `routeItems` is used to store a specific value in the application.
    var routeItems: [RouteItem]?
/// This variable `deviceLocalSetting` is used to store a specific value in the application.
    var deviceLocalSetting: DeviceLocalSetting?
    
/// This variable `imeiPoints` is used to store a specific value in the application.
    var imeiPoints: [IMEIPoint]?
    
/// This variable `markerContentView` is used to store a specific value in the application.
    let markerContentView = MarkerContentView(frame: CGRect(x: 0, y: 0, width: 240, height: 64))
    
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
        
        if selectedIndex == nil && endDate == nil && startDate == nil {
            showAlerInScreen(body: "مسیری یافت نشد!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let startDate = startDate, let endDate = endDate {
            self.fetchPointsByDates(startDate: startDate, toDate: endDate)
        }
        
        if let selectedIndex = selectedIndex, let routeItems = routeItems {
/// This variable `routeItem` is used to store a specific value in the application.
            let routeItem = routeItems[selectedIndex]
            if let id = routeItem.id {
                self.fetchPointsByRouteID(id: "\(id)")
            }
        }
    }
    
/// This method `startRouteAnimate` is used to perform a specific operation in a class or struct.
    func startRouteAnimate(objects: [IMEIPoint]) {
/// This variable `objectsCount` is used to store a specific value in the application.
        let objectsCount = objects.count
/// This variable `staticTimeInterval` is used to store a specific value in the application.
        let staticTimeInterval: TimeInterval = 10
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
                        if let object = objects.first, let speed = object.speed?.toDouble()?.rounded(toPlaces: 1) {
                            self.markerContentView.descriptionLabel.text = "سرعت \(speed)"
                        }
                        if let object = objects.first, let zaman = object.zaman {
                            if let time = zaman.toDate()?.toString(format: "HH:mm") {
                                self.markerContentView.titleLabel.text = "زمان \(time)"
                            }
                        }
                        
                        self.carMarker.position = CLLocationCoordinate2D(latitude: firstPosition.latitude, longitude: firstPosition.longitude)
                        self.carMarker.iconView = self.markerContentView
                        
                        self.polyline?.map = nil
                        self.polyline = nil
                    }
                    
                    self.polyline = self.drawRoute(coordinates: positionsObjects, polylineStrokeColor: .blue)
                    self.polyline?.map = self.mapView
                }
                
                self.currentTimerStep += 1
//                if objects.count == self.currentTimerStep {
//                    self.currentTimerStep = 0
//                    self.timer?.invalidate()
//                    self.timer = nil
//                }
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
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 130))
        CATransaction.commit()
    }
    
/// This method `begin` is used to perform a specific operation in a class or struct.
    func begin(items: [IMEIPoint]) {
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
            self.redPolyline = self.drawRoute(coordinates: coordinates, polylineStrokeColor: .red)
            self.redPolyline?.map = self.mapView
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
            if let object = items.first, let zaman = object.zaman {
                if let time = zaman.toDate()?.toString(format: "HH:mm") {
                    markerContentView.titleLabel.text = "زمان \(time)"
                }
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
    
    @IBAction func reloadAnimate() {
        if let imeiPoints = imeiPoints {
            self.redPolyline?.map = nil
            self.redPolyline = nil
            self.currentTimerStep = 0
            self.timer?.invalidate()
            self.timer = nil
            self.polyline?.map = nil
            self.polyline = nil
            self.begin(items: imeiPoints)
        }
    }
    
    @IBAction func nextTapped() {
        if let selectedIndex = selectedIndex, let routeItems = routeItems {
/// This variable `nextIndex` is used to store a specific value in the application.
            let nextIndex = selectedIndex + 1
            self.selectedIndex = nextIndex
            if nextIndex <= routeItems.count-1 && nextIndex >= 0 {
/// This variable `routeItem` is used to store a specific value in the application.
                let routeItem = routeItems[nextIndex]
                if let id = routeItem.id {
                    self.redPolyline?.map = nil
                    self.redPolyline = nil
                    self.currentTimerStep = 0
                    self.timer?.invalidate()
                    self.timer = nil
                    self.polyline?.map = nil
                    self.polyline = nil
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                        self.fetchPointsByRouteID(id: "\(id)")
                    }
                }
            }
            if nextIndex == routeItems.count-1 && nextIndex >= 0 {
                ProgressHUD.show("انتهای مسیر", interaction: true)
            }
        }
    }
    
    @IBAction func behindTapped() {
        if let selectedIndex = selectedIndex, let routeItems = routeItems {
/// This variable `backIndex` is used to store a specific value in the application.
            let backIndex = selectedIndex - 1
            self.selectedIndex = backIndex
            if backIndex >= 0 && backIndex <= routeItems.count-1 {
/// This variable `routeItem` is used to store a specific value in the application.
                let routeItem = routeItems[backIndex]
                if let id = routeItem.id {
                    self.redPolyline?.map = nil
                    self.redPolyline = nil
                    self.currentTimerStep = 0
                    self.timer?.invalidate()
                    self.timer = nil
                    self.polyline?.map = nil
                    self.polyline = nil
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                        self.fetchPointsByRouteID(id: "\(id)")
                    }
                }
            }
            if backIndex == 0 && backIndex <= routeItems.count-1 {
                ProgressHUD.show("ابتدای مسیر", interaction: true)
            }
        }
    }
    
    deinit {
        ProgressHUD.dismiss()
    }
}

extension RouteViewController: GMSMapViewDelegate, CLLocationManagerDelegate {
    
/// This method `locationManager` is used to perform a specific operation in a class or struct.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
/// This variable `camera` is used to store a specific value in the application.
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 16)
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
}

extension RouteViewController {
/// This method `fetchPointsByDates` is used to perform a specific operation in a class or struct.
    func fetchPointsByDates(startDate: Date, toDate: Date) {
        if let deviceLocalSetting = deviceLocalSetting {
/// This variable `network` is used to store a specific value in the application.
            let network = RestfulAPI<EMPTYMODEL,GenericModel<[IMEIPoint]>>
                .init(path: "GetImeiPoints")
                .with(queries: [
                    "imei": deviceLocalSetting.car.imei,
                    "startDate": startDate.toStringEn(format: "yyMMddHHmmss"),
                    "endDate": toDate.toStringEn(format: "yyMMddHHmmss"),
                ])
                .with(auth: .auth1)
            
            handleRequestByUI(network, animated: true) { [weak self] items in
                if let self = self {
                    if let items = items {
                        self.imeiPoints = items
                        self.begin(items: items)
                    }
                }
            }
        }
    }
    
/// This method `fetchPointsByRouteID` is used to perform a specific operation in a class or struct.
    func fetchPointsByRouteID(id: String) {
        // send Req then
/// This variable `network` is used to store a specific value in the application.
        let network = RestfulAPI<EMPTYMODEL,GenericModel<[IMEIPoint]>>
            .init(path: "GetRoute")
            .with(queries: [
                "routeId":id
            ])
            .with(auth: .auth1)
        
        handleRequestByUI(network, animated: true) { [weak self] items in
            if let self = self {
                if let items = items {
                    self.imeiPoints = items
                    self.begin(items: items)
                }
            }
        }
    }
}
