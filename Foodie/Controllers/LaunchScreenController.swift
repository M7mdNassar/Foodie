
import UIKit
import Lottie

class LaunchScreenController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpAnimation()
        
    }
    
    // MARK: - Methods
    
    func setUpAnimation(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2
        animationView.play { _ in
            self.transitionToMain()
        }
    }
    
    func transitionToMain() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(),
           let window = windowScene.windows.first {
            window.rootViewController = mainViewController
        }
    }

}


