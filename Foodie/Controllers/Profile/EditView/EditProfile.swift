
import UIKit
import IQKeyboardManagerSwift

class EditProfile: UIViewController {
    
    // MARK: - Variables
    
    var currentUser = UserManager.getUserFromUserDefaults()
    weak var delegate: EditProfileDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userCityTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userBirthDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextFields()
        setUpButton()
        setUpImageAsCircleWithShadowAndBorder()
        tapGesture()
        populateUserData()

        userBirthDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
    }
    
    // MARK: - Actions
    
    @objc func datePickerValueChanged() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let phoneNumber = userPhoneTextField.text, phoneNumber.count <= 10 else {
            showAlert(message: "يجب ألا يتجاوز رقم الهاتف 10 أرقام", title: "رقم هاتف غير صالح")
            return
        }
        
        guard let name = userNameTextField.text, name.count >= 3 else {
            showAlert(message: "يجب ان يتكون الاسم من ٣ أحرف على الأقل", title: "اسم المستخدم")
            return
        }
        
        
        currentUser!.name.first = userNameTextField.text!
        currentUser!.location?.city = userCityTextField.text!
        currentUser!.phone = userPhoneTextField.text!
        // Convert Date to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from: userBirthDatePicker.date)
        currentUser!.dob.date = dateString
        
        delegate?.didUpdateUser(currentUser!)
        delegate?.saveUpdatedUserToUserDefaults(updatedUser: currentUser!)

        // Dismiss the current view controller
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cameraIconImageView.isUserInteractionEnabled = true
        cameraIconImageView.addGestureRecognizer(tap)
    }
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Set Up UI
    
    private func populateUserData() {
        guard let user = currentUser else { return }
        userNameTextField.text = user.name.first
        userEmailTextField.text = user.email
        userCityTextField.text = user.location?.city
        userPhoneTextField.text = user.phone
        // Convert the string dob.date to a Date object
        userBirthDatePicker.date = toDateFormat(dateString: user.dob.date)
        // Load image
        loadUserImage(from: user.picture.large)
        setUpFont()
    }
    
    private func toDateFormat(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    private func loadUserImage(from urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: urlString),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            }
        }
    }
    
    private func setUpImageAsCircleWithShadowAndBorder() {
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
        
        tapGesture()

    }
    
    private func setUpFont() {
                
                let maximumFontSize: CGFloat = 30.0
                let maximumEmailFontSize : CGFloat = 26.0
                
                if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0) {
                    let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
                    userNameTextField.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSize))
                }
                
                if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0) {
                    let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
                    userEmailTextField.font = scaledFont.withSize(min(scaledFont.pointSize, maximumEmailFontSize))
                }
                if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0) {
                    let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
                    userCityTextField.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSize))
                }
                
                if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0) {
                    let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
                    userPhoneTextField.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSize))
                }
    }
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.foodieLightGreen
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
   
        title = NSLocalizedString("Edit Profile", comment: "")
    }
    
    private func setUpButton() {
        saveButton.layer.cornerRadius = 18.0
        saveButton.clipsToBounds = true
        saveButton.setTitle(NSLocalizedString("save", comment: "save Button Title"), for: .normal)
    }
}

// MARK: - UIImage Picker Delegate

extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Assistance Protocol

protocol EditProfileDelegate: AnyObject {
    func didUpdateUser(_ user: User)
    func saveUpdatedUserToUserDefaults(updatedUser: User)
}


// MARK: - UITextField Delegate

extension EditProfile: UITextFieldDelegate {
func configureTextFields() {
    
    IQKeyboardManager.shared.enable = true
    
    userNameTextField.delegate = self
    userCityTextField.delegate = self
    userPhoneTextField.delegate = self
    
    userNameTextField.placeholder = NSLocalizedString("userName", comment: "")
    userCityTextField.placeholder = NSLocalizedString("userCity", comment: "")
    userPhoneTextField.placeholder = NSLocalizedString("userPhone", comment: "")
    
    // Make userEmailTextField 'Read Only'
    userEmailTextField.isUserInteractionEnabled = false

}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == userNameTextField {
        userCityTextField.becomeFirstResponder()
    } else if textField == userCityTextField {
        userPhoneTextField.becomeFirstResponder()
        
    }
    else {
        textField.becomeFirstResponder()
    }

    return true
}

}
