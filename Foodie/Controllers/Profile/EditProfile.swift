
import UIKit

class EditProfile: UIViewController {
    
    // MARK: - Variables
    
    var user: User?
    weak var delegate: EditProfileDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCityTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userBirthDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUserData()
        configureNavigationBar()
        configureTextFields()
        setUpButton()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButton(_ sender: UIButton) {
        
            var updatedUser = user!
            updatedUser.name.first = userNameTextField.text!
            updatedUser.location?.city = userCityTextField.text!
            updatedUser.phone = userPhoneTextField.text!
            // convert Date to String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let dateString = dateFormatter.string(from: userBirthDatePicker.date)
            updatedUser.dob.date = dateString

            delegate?.didUpdateUser(updatedUser)
            // Dismiss the current view controller
            navigationController?.popViewController(animated: true)
            
    }
    
    // MARK: Methods
    
    func tapgasture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

    // MARK: - Set Up UI

private extension EditProfile{
    
    func populateUserData() {
        guard let user = user else { return }
        userNameTextField.text = user.name.first
        userEmailLabel.text = user.email
        userCityTextField.text = user.location?.city
        userPhoneTextField.text = user.phone
        // Convert the string dob.date to a Date object
           let dateString = user.dob.date
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
               if let date = dateFormatter.date(from: dateString) {
                   userBirthDatePicker.date = date
               }
           
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: user.picture.large),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self.setUpImageAsCircleWithShadowAndBorder()
                    self.userImageView.image = image
                }
            }
        }
        setUpFont()
        
       }
    
    func setUpImageAsCircleWithShadowAndBorder() {
        // Make view as circle shape & apply a shadow
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 0.7
        circleView.layer.shadowOffset = CGSize.zero
        circleView.layer.shadowRadius = 7
        circleView.clipsToBounds = false

        // Make image as circle shape & apply a border
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.borderWidth = 4.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        
        tapgasture()

    }
    
    func setUpFont(){
       //let maximumFontSizeRestaurantName: CGFloat = 50.0
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            userNameTextField.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            userEmailLabel.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            userCityTextField.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            userPhoneTextField.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
        
    }
    
     func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        title = NSLocalizedString("Edit Profile", comment: "")
    }
    
    func setUpButton(){
        saveButton.layer.cornerRadius = 18.0
        saveButton.clipsToBounds = true
        saveButton.setTitle(NSLocalizedString("saveButton", comment: "save Button Title"), for: .normal)
    }
}

    // MARK: - UIImage Picker Delegate

extension EditProfile: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Assistance Protocol

protocol EditProfileDelegate: AnyObject {
    func didUpdateUser(_ user: User)
}

    // MARK: - UITextField Delegate

extension EditProfile: UITextFieldDelegate {
    func configureTextFields() {
        userNameTextField.delegate = self
        userCityTextField.delegate = self
        userPhoneTextField.delegate = self
        
        userNameTextField.placeholder = NSLocalizedString("userName", comment: "")
        userCityTextField.placeholder = NSLocalizedString("userCity", comment: "")
        userPhoneTextField.placeholder = NSLocalizedString("userPhone", comment: "")

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userCityTextField.becomeFirstResponder()
        } else if textField == userCityTextField {
            userPhoneTextField.becomeFirstResponder()
            
        }
        else {
            textField.resignFirstResponder()
        }

        return true
    }
}
