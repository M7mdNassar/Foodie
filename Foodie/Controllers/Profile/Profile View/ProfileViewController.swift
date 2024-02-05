import UIKit
import ProgressHUD

   // MARK: - Option Struct

struct Option {
    let title: String
    let icon: UIImage
}

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Variables
    
    let backButton = UIBarButtonItem()
    
    let options:[Option] = [
        Option(title: "تعديل الملف الشخصي", icon: UIImage(systemName: "person.crop.circle.fill")!),
        Option(title: "تفعيل بطاقه هديه", icon: UIImage(systemName: "giftcard.fill")!),
        Option(title: "تواصل معنا", icon: UIImage(systemName: "message.fill")!),
        Option(title: "دعوه صديق", icon: UIImage(systemName: "person.crop.circle.badge.plus")!),
        Option(title: "سياسه الخصوصيه", icon: UIImage(systemName: "lock.circle.fill")!),
        Option(title: "تسجيل الخروج", icon: UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")!)
    ]
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTable()
        PlaceholderForImage()
        configureNavigationBar()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.tertiarySystemGroupedBackground
        setupUI()
    }
    
    func setupUI(){
        setUpFont()
        setShadowAroundImage()
        
        if let user = User.currentUser{
            
            self.userNameLabel.text = user.userName
            
            if user.avatarLink != ""{
                FileStorage.downloadImage(imageUrl: user.avatarLink) { avatarImage in
                    self.userImageView.image = avatarImage?.circleMasked
                }
            }
            
        }
    }
    
  
    
    // MARK: - Methods
    
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        contentView.layer.cornerRadius = 15 //make corner around the table content
    }
    
    func configureNavigationBar() {
        backButton.title = NSLocalizedString("رجوع", comment: "")
        self.navigationItem.backBarButtonItem = backButton
        let scaledFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize))
        backButton.setTitleTextAttributes([.font: scaledFont], for: .normal)

    }
    
    func configureTabBar() {
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: nil)
        if let tabBarItem = self.tabBarItem {
            let scaledFont = UIFont.systemFont(ofSize: UIFont.labelFontSize).withSize(12.0)
            tabBarItem.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
    }
    
 
    
    func logout() {
        let alert = UIAlertController(title: "تسجيل الخروج", message:"هل أنت متأكد أنك تريد تسجيل الخروج؟", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "تسجيل الخروج", style: .destructive, handler: { action in
            // Perform logout actions
            
            
            FUserListener.shared.logoutUser { error in
                
                if error == nil{
                    let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                    
                    loginView.modalPresentationStyle = .fullScreen
                    
                    DispatchQueue.main.async {
                        self.present(loginView, animated: true)
                    }
                }
                else{
                    ProgressHUD.error(error?.localizedDescription)
                }
                
            }
            
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}

// MARK: - TableView Delegate

extension ProfileViewController: UITableViewDelegate {
    
}

// MARK: - TableView Data Source

extension ProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        let option = options[indexPath.row]
        cell.setUpCell(optionTitle: option.title, optionIcon: option.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = indexPath.row
        if selectedOption == 0 {
            performSegue(withIdentifier: "goToEdit", sender: self)
        }
       
        else if selectedOption == 2 {
            performSegue(withIdentifier: "goToChat", sender: self)
        }
        else if selectedOption == 5 {
            logout()
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private Methods For UI

private extension ProfileViewController {
    
    func PlaceholderForImage() {
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.borderWidth = 4.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.clipsToBounds = true
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.clipsToBounds = false
    }
    
    func setShadowAroundImage() {
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 0.7
        circleView.layer.shadowOffset = CGSize.zero
        circleView.layer.shadowRadius = 7
    }
    
    func setUpFont() {
        let maximumFontSize: CGFloat = 40.0
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            userNameLabel.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSize))
        }
    }
}


