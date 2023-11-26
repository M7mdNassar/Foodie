import UIKit
import MapKit

class RestaurantDetails: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var restaurantMapView: MKMapView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!

    // MARK: - Properties
    var restaurant: Restaurant = Restaurant(name: "", isFavorite: false, imageName: "", coordinates: .init(longitude: 1.0, latitude: 1.0), description: " ", city: " ", category: " ")

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureMapView()
        setUpRestaurant()
        setUpFontLabels()
        addTapGestureToMapView()
    }

    // MARK: - Private Methods
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        title = NSLocalizedString(restaurant.name, comment: "")
    }

}

    // MARK: - Map View
extension RestaurantDetails: MKMapViewDelegate {
    
    func configureMapView() {
        restaurantMapView.delegate = self
        let initialLocation = CLLocation(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
        setStartingLocation(location: initialLocation, distance: 100)
        addAnnotation()
    }

    func setStartingLocation(location: CLLocation, distance: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        restaurantMapView.setRegion(region, animated: true)
        restaurantMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 300000)
        restaurantMapView.setCameraZoomRange(zoomRange, animated: true)
    }

    func addAnnotation() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
        pin.title = NSLocalizedString(restaurant.name, comment: "")
        restaurantMapView.addAnnotation(pin)
    }

    // MARK: - Map Tap Gesture
    @objc func mapTapped(gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: restaurantMapView)
        let locationOnMap = restaurantMapView.convert(locationInView, toCoordinateFrom: restaurantMapView)
        showMapOptions(coordinate: locationOnMap)
    }

    func addTapGestureToMapView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        restaurantMapView.addGestureRecognizer(tapGesture)
    }

    func showMapOptions(coordinate: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "Open in Maps", message: "Choose a maps application", preferredStyle: .actionSheet)

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { _ in
                self.openGoogleMap(coordinate: coordinate)
            }
            alertController.addAction(googleMapsAction)
        }

        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) { _ in
            self.openAppleMap(coordinate: coordinate)
        }
        alertController.addAction(appleMapsAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func openAppleMap(coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = restaurant.name
        let mapLaunchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: mapLaunchOptions)
    }

    func openGoogleMap(coordinate: CLLocationCoordinate2D) {
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        if let url = URL(string: "comgooglemaps://?q=\(coordinateString)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Google Maps app not installed.")
            }
        }
    }

}

    // MARK: - UI Setup
private extension RestaurantDetails {

    func setUpRestaurant() {
        setUpImageAsCircleWithShadowAndBorder()
        restaurantNameLabel.text = NSLocalizedString(restaurant.name, comment: "")
        restaurantDescriptionLabel.text = NSLocalizedString(restaurant.description, comment: "")
        restaurantCityLabel.text = NSLocalizedString(restaurant.city, comment: "")
    }

    func setUpImageAsCircleWithShadowAndBorder() {
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

   
    func setUpFontLabels() {
        if let customFont = UIFont(name: "Harmattan-Regular", size: 31.0) {
               restaurantNameLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
           }
           
           if let customFont = UIFont(name: "Harmattan-Regular", size: 17.0) {
               restaurantCityLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
           }
           
           if let customFont = UIFont(name: "Harmattan-Regular", size: 20.0) {
               restaurantDescriptionLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
           }
    }


}






