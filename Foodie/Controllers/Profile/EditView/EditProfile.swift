
import UIKit
import IQKeyboardManagerSwift
import Gallery
import ProgressHUD

class EditProfile: UIViewController {
    
    // MARK: - Variables
    
    var gallery: GalleryController!

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

        showUserInformation()
        
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
        
        
        // Update currentUser with modified values
        if var user = User.currentUser{
        
            user.userName = userNameTextField.text!
            user.country = userCityTextField.text!
            user.phoneNumber = userPhoneTextField.text!
            // Convert Date to String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            user.date = dateFormatter.string(from: userBirthDatePicker.date)
            
            saveUserLocally(user: user)
            FUserListener.shared.saveUserToFierbase(user: user)
            
            // Dismiss the current view controller
            navigationController?.popViewController(animated: true)
        }
    }

    
    // MARK: - Private Methods
    
    private func showUserInformation(){
        if let user = User.currentUser {
            userNameTextField.text = user.userName
            userEmailTextField.text = user.email
            userCityTextField.text = user.country
            userPhoneTextField.text = user.phoneNumber
            // Convert string date to Date object using the extension
                if let date = user.date.toDate() {
                    userBirthDatePicker.date = date
                }
            
            if user.avatarLink != ""{
                self.userImageView.load(from: user.avatarLink)
            }
            
         }
    }
    
    func uploadAvatarImage(image:UIImage){
           let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
           FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
               if var user = User.currentUser{
                   user.avatarLink = avatarLink ?? ""
                   saveUserLocally(user: user)
                   FUserListener.shared.saveUserToFierbase(user: user)
               }
               
               //.. save file loccally in device
               
               FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
           }
       }



    
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
        showGallery()
    }
    
    // MARK: - Set Up UI
    
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

// MARK: Gallery

extension EditProfile : GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count > 0{
            images.first!.resolve { (avatarImage) in
                if avatarImage != nil {
                    //... uplaod image
                    self.uploadAvatarImage(image: avatarImage!)
                    self.userImageView.image = avatarImage
                }
                else{
                    ProgressHUD.error("No Image")
                }
            }
        }
        
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    // this methods i dont need , so dismiss it
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func showGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab , .cameraTab]
        Config.Camera.imageLimit = 1 // just chose one image
        Config.initialTab = .imageTab
        self.present(self.gallery, animated: true)
    }
}



// MARK: - UITextField Delegate

extension EditProfile: UITextFieldDelegate {
func configureTextFields() {
    
    IQKeyboardManager.shared.enable = true
    
    userNameTextField.delegate = self
    userCityTextField.delegate = self
    userPhoneTextField.delegate = self
    userNameTextField.clearButtonMode = .whileEditing
    userCityTextField.clearButtonMode = .whileEditing
    userPhoneTextField.clearButtonMode = .whileEditing

    
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
