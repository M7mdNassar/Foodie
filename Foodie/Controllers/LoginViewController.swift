import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var userPasswordLabel: UITextField!

    // MARK: - Properties
    var defaults = UserDefaults.standard

    // MARK: - Life Cycle Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpUI()
        setUpBackground()
<<<<<<< HEAD
        // store this values in defaults
#warning("why u need to set the user name and pass here?")
       defaults.set("m", forKey: "username")
       defaults.set("1", forKey: "password")

=======
        
>>>>>>> testLogin
    }

    // MARK: - Methods
    @IBAction func loginButton(_ sender: UIButton) {
        
        if attemptLogin(){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        }else {
            return
        }
    }

    private func attemptLogin() -> Bool{
        guard let username = userNameLabel.text,
              let password = userPasswordLabel.text , !username.isEmpty, !password.isEmpty else {
            return false
        }

        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
        return true
       
    }
    

}

// MARK: - Set Up UI
private extension LoginViewController {
    func setUpBackground() {
        let foodieColor = UIColor(named: "FoodieLightGreen")

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [foodieColor!.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.2]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setUpUI() {
        // make the image as a circle
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2

        // make corner for Button
        loginButton.layer.cornerRadius = 18.0
        loginButton.clipsToBounds = true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func configure() {
        userNameLabel.delegate = self
        userPasswordLabel.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameLabel {
            userPasswordLabel.becomeFirstResponder()
        } else if textField == userPasswordLabel {
            textField.resignFirstResponder()
        }

        return true
    }
    
}
