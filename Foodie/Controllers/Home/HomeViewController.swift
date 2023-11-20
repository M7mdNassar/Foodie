
import UIKit
import Lottie

class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimation()
       
    }
    
    // MARK: - Methods
    
     func setUpAnimation(){
        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    
    }
    
}
