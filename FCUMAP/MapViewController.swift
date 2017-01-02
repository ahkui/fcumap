//
//  ViewController.swift
//  FCUMAP
//
//  Created by RTC18 on 2016/12/9.
//  Copyright © 2016年 AhKui-D0562215. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var map: MKMapView!
    @IBOutlet var focusButton:UIButton!
    @IBOutlet var infoView:UIView!
    @IBOutlet var infoSearchBottom: NSLayoutConstraint!
    @IBOutlet var infoSearchLabel:UILabel!
    let dijkstra = Dijkstra()
    let locationManager = CLLocationManager()
    var reallat:Double?
    var reallong:Double?
    var isFocus = true
    var geodesic:MKGeodesicPolyline?
    var _direct:MKGeodesicPolyline?
    var route:MKPolyline?
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.borderColor = UIColor(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        infoView.layer.shadowColor = UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5).cgColor
        infoView.layer.borderWidth = 1.5
        infoView.layer.shadowOpacity = 1.0
        infoView.layer.shadowRadius = 2.0
        infoView.layer.shadowOffset = CGSize(width: 2, height: 2)
        focusButton.layer.borderColor = UIColor(colorLiteralRed: 100.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 1.0).cgColor
        focusButton.layer.shadowColor = UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5).cgColor
        focusButton.adjustsImageWhenHighlighted = false
        focusTouchUp()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.map.showsUserLocation = true
            self.map.showsScale = false
            self.map.showsCompass = true
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func infoSearchShow(){
        UIView.animate(withDuration: 1, animations: {
            self.infoSearchBottom.constant = 20
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func infoSearchHide(){
        UIView.animate(withDuration: 1, animations: {
            self.infoSearchBottom.constant = -80
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func focusToggle(_ sender: UIButton){
        focusTouchUp()
        if isFocus {
            isFocus = false
            focusButton.tintColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
        }else{
            let center = CLLocationCoordinate2D(latitude: reallat!, longitude: reallong!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
            self.map.setRegion(region, animated: true)
            isFocus = true
            focusButton.tintColor = UIColor(colorLiteralRed: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
        }
        
    }
    
    @IBAction func focusTouchDown(){
        focusButton.layer.borderWidth = 0
        focusButton.layer.shadowOpacity = 1.0
        focusButton.layer.shadowRadius = 0.0
        focusButton.layer.shadowOffset = CGSize.zero
        
    }
    
    func focusTouchUp(){
        focusButton.layer.borderWidth = 1.5
        focusButton.layer.shadowOpacity = 1.0
        focusButton.layer.shadowRadius = 2.0
        focusButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        loading.stopAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isFocus {
            let location = locations.last!
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
            self.map.setRegion(region, animated: true)
        }
        if let lat_long = manager.location?.coordinate {
            reallat = lat_long.latitude
            reallong = lat_long.longitude
        }
        //        if isSearch {
        //            if let _direct_ = _direct {
        //
        //            }else if let route_ = route {
        //
        //            }
        //        }
    }
    
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        if let searchcontroller = sender.source as? SearchViewController {
            _clearMapItem()
            loading.startAnimating()
            isFocus = false
            let end = searchcontroller.end!
            var pathList = [CLLocationCoordinate2D]()
            var result = dijkstra.proccessreal(lat: reallat!, long: reallong!, end: end)
            if result.count > 1 {
                for point in result{
                    pathList += [CLLocationCoordinate2DMake((dijkstra.points[point]?.lat)!, (dijkstra.points[point]?.long)!)]
                }
                let sourcePlacemark = MKPlacemark(coordinate: pathList.first!, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: pathList.last!, addressDictionary: nil)
                let sourceAnnotation = MKPointAnnotation()
                let destinationAnnotation = MKPointAnnotation()
                if let location = sourcePlacemark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
                if let location = destinationPlacemark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
                sourceAnnotation.title = "目前位置"
                destinationAnnotation.title = dijkstra.points[end]?.name!
                geodesic = MKGeodesicPolyline(coordinates: pathList, count: pathList.count)
                self.map.addAnnotations([destinationAnnotation])
                self.map.add(geodesic!)
                
            }else{
                result = dijkstra.proccess(start: "out_main", end: end)
                for point in result{
                    pathList += [CLLocationCoordinate2DMake((dijkstra.points[point]?.lat)!, (dijkstra.points[point]?.long)!)]
                }
                let realPoint = CLLocationCoordinate2DMake(reallat!, reallong!)
                let sourcePlacemark = MKPlacemark(coordinate: realPoint, addressDictionary: nil)
                let centerPlacemark = MKPlacemark(coordinate: pathList.first!, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: pathList.last!, addressDictionary: nil)
                let sourceAnnotation = MKPointAnnotation()
                let destinationAnnotation = MKPointAnnotation()
                if let location = sourcePlacemark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
                if let location = destinationPlacemark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
                sourceAnnotation.title = "目前位置"
                destinationAnnotation.title = dijkstra.points[end]?.name!
                geodesic = MKGeodesicPolyline(coordinates: pathList, count: pathList.count)
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = MKMapItem(placemark: sourcePlacemark)
                directionRequest.destination = MKMapItem(placemark: centerPlacemark)
                directionRequest.transportType = .automobile
                let directions = MKDirections(request: directionRequest)
                directions.calculate {
                    (response, error) -> Void in
                    if let response = response {
                        self.route = (response.routes[0]).polyline
                        self.map.add((self.route)!)
                    } else {
                        self._direct = MKGeodesicPolyline(coordinates: [realPoint,pathList.first!], count: 2)
                        self.map.add((self._direct)!)
                    }
                    
                    self.map.addAnnotations([destinationAnnotation])
                    self.map.add(self.geodesic!)
                    
                    
                }
                
            }
            self.loading.stopAnimating()
            self.infoSearchShow()
            self.infoSearchLabel.text = "目前位置 -> \((self.dijkstra.points[end]?.name)!)"
            let center = CLLocationCoordinate2D(latitude: reallat!, longitude: reallong!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
            self.map.setRegion(region, animated: true)
            self.isFocus = true
            self.focusButton.tintColor = UIColor(colorLiteralRed: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFocus {
            isFocus = false
            focusButton.tintColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    @IBAction func removeSearch(_ sender:UIButton){
        _clearMapItem()
        infoSearchHide()
    }
    public func _clearMapItem(){
        map.removeAnnotations(map.annotations)
        let queue1 = DispatchQueue(label: "clear geodesic line")
        let queue2 = DispatchQueue(label: "clear route line")
        let queue3 = DispatchQueue(label: "clear custom line")
        queue1.async{
            if let line = self.geodesic {
                self.map.remove(line)
            }
            
        }
        queue2.async{
            if let line = self.route {
                self.map.remove(line)
            }
        }
        queue3.async{
            if let line = self._direct {
                self.map.remove(line)
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            infoSearchHide()
            let destinationController = segue.destination as! SearchViewController
            destinationController.searchList = dijkstra.searchList
        }
    }
    
}

