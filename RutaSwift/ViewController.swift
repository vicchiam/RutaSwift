//
//  ViewController.swift
//  RutaSwift
//
//  Created by Victor Chisvert Amat on 27/1/16.
//  Copyright © 2016 Victor Chisvert Amat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var manejador = CLLocationManager()
    
    var distancia = 0.0
    private var posAnt : CLLocation! = nil
    
    @IBOutlet weak var mapa: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate=self
        manejador.desiredAccuracy=kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        
        //let region = MKCoordinateRegion(center: mapa.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //mapa.setRegion(region, animated: true)
        
        mapa.camera.altitude = 1000
        mapa.camera.centerCoordinate = mapa.centerCoordinate
        
    }    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                mapa.mapType = .Standard
            case 1:
                mapa.mapType = .Satellite
            default:
                mapa.mapType = .Hybrid
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapa.centerCoordinate = manager.location!.coordinate
        if posAnt == nil {
            posAnt = CLLocation(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        }
        
        let posActual = CLLocation(latitude:manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        if posActual.distanceFromLocation(posAnt) > 50 {
            
            let pin = MKPointAnnotation()
            pin.title = "\(posActual.coordinate.latitude),\(posActual.coordinate.longitude)"
            pin.subtitle = "\(distancia)"
            pin.coordinate = mapa.centerCoordinate
            mapa.addAnnotation(pin)
            
            distancia += posActual.distanceFromLocation(posAnt)
            
            posAnt = CLLocation(latitude: posActual.coordinate.latitude, longitude: posActual.coordinate.longitude)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

