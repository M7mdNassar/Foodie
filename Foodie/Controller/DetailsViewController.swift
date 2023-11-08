
import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var restaurantMapView: MKMapView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var restaurant: Restaurant =
    Restaurant (name: "", isFavorite: false, imageName: "", coordinates: .init(longitude: 1.0, latitude: 1.0), description: " ", city: " ")  // defualt values
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        title = restaurant.name
        setUpRestaurant()
    }
        
}


private extension DetailsViewController{
    
    // MARK: - Map View Methods
    
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
        pin.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
        pin.title = restaurant.name
        restaurantMapView.addAnnotation(pin)
    }
    
}

private extension DetailsViewController{
    
    // MARK: - UI Setup Method
    
    private func setUpRestaurant(){
        let initialLocation = CLLocation(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
        setStartingLocation(location: initialLocation, distance: 100)
        setUpImageAsCircleWithShadowAndBorder()
        restaurantNameLabel.text = restaurant.name
        restaurantDescriptionLabel.text = restaurant.description
        restaurantCityLabel.text = restaurant.city

    }
    
    func setUpImageAsCircleWithShadowAndBorder(){
                
        // Make view as circle shape & apply a shadow
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 1
        circleView.layer.shadowOffset = CGSize.zero
        circleView.layer.shadowRadius = 10
        circleView.clipsToBounds = false
        
        // Make image as circle shape & apply a border
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.size.width / 2
        restaurantImageView.layer.borderWidth = 4.0
        restaurantImageView.layer.borderColor = UIColor.white.cgColor
        restaurantImageView.image = UIImage(named: restaurant.imageName)
    }
}
