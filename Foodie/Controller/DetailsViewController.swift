
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
    
        circleImage()
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
    

    func circleImage(){
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.size.width / 2
        restaurantImageView.layer.borderWidth = 6.0
        restaurantImageView.layer.borderColor = UIColor.white.cgColor
        

        restaurantImageView.layer.shadowColor = UIColor.black.cgColor
        restaurantImageView.layer.shadowOpacity = 0.5
        restaurantImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        restaurantImageView.layer.shadowRadius = 4.0
        restaurantImageView.superview?.backgroundColor = UIColor.clear // Set a background color
        restaurantImageView.superview?.alpha = 1.0 // Ensure non-zero alpha
        
        

    
    }
  
    
    
    
}
