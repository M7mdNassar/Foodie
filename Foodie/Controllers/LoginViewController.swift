import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var userPasswordLabel: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // MARK: - Properties
    var defaults = UserDefaults.standard

    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        configure()
        setUpUI()
        setUpBackground()
    }
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: UIButton) {
            if attemptLogin() {
                // Fetch user data after successful login
                Task {
                    do {
                        let user = try await UserApi().fetchData().results.first
                        DispatchQueue.main.async {
                            self.handleSuccessfulLogin(user: user!)
                        }
                    } catch {
                        print("Error fetching data: \(error)")
                    }
                }
            } else {
                return
            }
        }

        // MARK: - Private Methods
        private func attemptLogin() -> Bool {
            guard let username = userNameLabel.text,
                  let password = userPasswordLabel.text,
                  !username.isEmpty, !password.isEmpty else {
                return false
            }
            defaults.set(username, forKey: "username")
            defaults.set(password, forKey: "password")

            return true
        }

        private func handleSuccessfulLogin(user: User) {
            // Save the user to UserDefaults
            UserManager.saveUserToUserDefaults(user: user)

            // Transition to the home screen with the user data
            transitionToHomeScreen()
        }
    
    private func transitionToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    // MARK: - Set Up UI
    private func setUpBackground() {
        let foodieColor = UIColor(named: "FoodieLightGreen")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [foodieColor!.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.2]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setUpUI() {
        welcomeLabel.text = NSLocalizedString("welcome", comment: "greeting")
        
        // make the image as a circle
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        // make corner for Button
        loginButton.layer.cornerRadius = 18.0
        loginButton.clipsToBounds = true
        loginButton.setTitle(NSLocalizedString("loginButton", comment: "Login Button Title"), for: .normal)
    }

    
}

    // MARK: - UITextFieldDelegate
    extension LoginViewController: UITextFieldDelegate {
        func configure() {
            userNameLabel.delegate = self
            userPasswordLabel.delegate = self
            userNameLabel.placeholder = NSLocalizedString("userName", comment: "")
            userPasswordLabel.placeholder = NSLocalizedString("password", comment: "")
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
