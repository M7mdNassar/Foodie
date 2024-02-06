import UIKit
import IQKeyboardManagerSwift
import ProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    //Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    //TextFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //Buttons
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    // MARK: Actions
    
    @IBAction func forgetPasswordButton(_ sender: UIButton) {
        if isInputDataValid(mode: "forgetPassword"){
            
            forgetPassword()
        }
        else{
            ProgressHUD.error("All Fields requierd")
        }
    }
    
    
    @IBAction func resendEmailButton(_ sender: UIButton) {
      
        resendEmailVerfication()
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        if isInputDataValid(mode: isLogin ? "login" : "register"){
            
            // Login or Register
            
            isLogin ? loginUser() : registerUser()
           
        }
        else{
            ProgressHUD.error("All Fields requierd")
            
        }
        
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        updateUIMode(mode : isLogin)
    }
    
    // MARK: Variables
    
    var isLogin : Bool = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setupLabels()
        configureTextFields()
        setupBackgroundGesture()
        updateUIMode(mode: false)
    }
    
    // MARK: Methods
    
    func setupLabels(){
        emailLabel.text = ""
        passwordLabel.text = ""
        confirmPasswordLabel.text = ""
    }
    
    func configureTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordField.delegate = self
        
        self.emailTextField.layer.cornerRadius = 15
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.masksToBounds = true
        self.confirmPasswordField.layer.cornerRadius = 15
        self.confirmPasswordField.layer.masksToBounds = true
    }
    
    func updateUIMode(mode:Bool){
        if !mode{
            titleLabel.text = "Login"
            confirmPasswordLabel.isHidden = true
            confirmPasswordField.isHidden = true
            loginButtonOutlet.setTitle("Register", for: .normal)
            registerButtonOutlet.setTitle("Login", for: .normal)
            haveAnAccountLabel.text = "New Here ?"
            resendEmailButtonOutlet.isHidden = true
            forgetPasswordButtonOutlet.isHidden = false
            
        }
        else{
            titleLabel.text = "Register"
            confirmPasswordLabel.isHidden = false
            confirmPasswordField.isHidden = false
            loginButtonOutlet.setTitle("Login", for: .normal)
            registerButtonOutlet.setTitle("Register", for: .normal)
            haveAnAccountLabel.text = "Have An Account ?"
            resendEmailButtonOutlet.isHidden = false
            forgetPasswordButtonOutlet.isHidden = true

        }
        
        isLogin.toggle()
    }
    
    // MARK: Helpers
    
    func isInputDataValid (mode: String) -> Bool{
        
        switch (mode)
        {
        case "login":
            return emailTextField.hasText && passwordTextField.hasText
            
        case "register":
            return emailTextField.hasText && passwordTextField.hasText && confirmPasswordField.hasText
            
        case "forgetPassword":
            return emailTextField.hasText
            
        default :
            return false
            
        }
    }
    
    // MARK: Background Tap Gesture
    
    func setupBackgroundGesture(){
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
    
    func registerUser(){
        if passwordTextField.text == confirmPasswordField.text{
            FUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                
                if error == nil{
                    ProgressHUD.success("Verification Email Sent , please check you email :)")
                }else {
                    ProgressHUD.error(error?.localizedDescription)
                }
            }
        }else {
            ProgressHUD.error("Not matching in Password")
        }
    }
    
    
    func loginUser(){
        FUserListener.shared.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            
            if error == nil{
                
                if isEmailVerified{
                    
                    self.goToApp()
                    
                }else{
                    ProgressHUD.failed("Please check you email to verify and complet registration")
                }
                
            }
            else{
                ProgressHUD.error(error?.localizedDescription)
            }
            
        }
        
        
    }
    
    func resendEmailVerfication(){
        
        FUserListener.shared.resendVerficationEmailWith(email: emailTextField.text!) { error in
            if error == nil{
                ProgressHUD.succeed("Verfication Email Send :)")
            }
            else{
                ProgressHUD.error(error?.localizedDescription)
            }
        }
    }
    
    func forgetPassword(){
        FUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil{
                ProgressHUD.success("Email for reset your password has been sent !")
            }else{
                ProgressHUD.failed(error?.localizedDescription)
            }
        }
        
    }
    
    
    // Navigation to app
    
    func goToApp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
    
    // MARK: - Set Up UI
    private func setUpBackground() {
//        let foodieColor = UIColor(named: "FoodieLightGreen")
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [foodieColor!.cgColor, UIColor.white.cgColor]
//        gradientLayer.locations = [0.0, 1.2]
//        view.layer.insertSublayer(gradientLayer, at: 0)
//        
        
        
        self.registerButtonOutlet.layer.cornerRadius = 20
        
    }

    
}

// MARK: UITextFieldDelegate

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = emailTextField.hasText ? "Email" : ""
        passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        confirmPasswordLabel.text = confirmPasswordField.hasText ? "Confirm Password" : ""
    }
    
}

