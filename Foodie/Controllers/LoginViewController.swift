
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    // MARK: - Properties
    
    var defaults = UserDefaults.standard
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var userPasswordLabel: UITextField!
    
        // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageAsCircle()
        setUpBackground()
        // store this values in defaults
#warning("why u need to set the user name and pass here?")
       defaults.set("m", forKey: "username")
       defaults.set("1", forKey: "password")

    }
    
        // MARK: - Methods
    
    @IBAction func loginButton(_ sender: UIButton) {
        attemptLogin()
    }

    func attemptLogin() {
       
        guard let username = userNameLabel.text,
              let password = userPasswordLabel.text else {
            return
        }
        if isValidUser(username: username, password: password) {
            performSegue(withIdentifier: "goToHome", sender: self)
        } else {
            showAlert(message: "Invalid username or password")
        }
    }
    
    func isValidUser(username: String, password: String) -> Bool {
        
           let userName = defaults.string(forKey: "username")
           let userPassword = defaults.string(forKey: "password")
           return username == userName && password == userPassword
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
}

    // MARK: - Set Up UI

private extension LoginViewController {
    func setUpBackground() {
        let foodieColor = UIColor(named: "FoodieLightGreen")

            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
        gradientLayer.colors = [foodieColor!.cgColor, UIColor.white.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            view.layer.insertSublayer(gradientLayer, at: 0)

    }

    func setUpImageAsCircle() {        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}
