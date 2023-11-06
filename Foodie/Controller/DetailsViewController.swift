//
//  DetailsViewController.swift
//  Foodie
//
//  Created by Mac on 06/11/2023.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var restaurantImage : String?
    var restaurantName : String?
    var restaurantDescription: String?
    var restaurantCity: String?
    var longitude: Double?
    var latitude: Double?

    
    @IBOutlet weak var restaurantMapView: MKMapView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.orange

        title = restaurantName
        
        display()
    }
    
    
    func display(){
        let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        setStartingLocation(location: initialLocation, distance: 100)
        
        restaurantImageView.image = UIImage(named: restaurantImage!)
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.size.width / 2
        restaurantNameLabel.text = restaurantName!
        restaurantDescriptionLabel.text = restaurantDescription!
        restaurantCityLabel.text = restaurantCity!

    }
    
    
    
    func setStartingLocation(location: CLLocation , distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        restaurantMapView.setRegion(region, animated: true)
        restaurantMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 300000)
        restaurantMapView.setCameraZoomRange(zoomRange, animated: true)
        addAnnotation()
    }
    
    
    func addAnnotation(){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        pin.title = restaurantName!
        restaurantMapView.addAnnotation(pin)
        
    }
    

    
  
    
    
    
}
