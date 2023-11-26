
import UIKit


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
    
    let individualApi = UserApi()
    let options:[Option] = [Option(title: "تعديل الملف الشخصي", icon:                               UIImage(systemName: "person.crop.circle.fill")!) ,
                            Option(title: "تفعيل بطاقه هديه", icon: UIImage(systemName: "giftcard.fill")!),
                            Option(title: "تواصل معنا", icon: UIImage(systemName: "message.fill")!),
                            Option(title: "دعوه صديق", icon: UIImage(systemName: "person.crop.circle.badge.plus")!),
                            Option(title: "سياسه الخصوصيه", icon: UIImage(systemName: "lock.circle.fill")!),
                            Option(title: "تسجيل الخروج", icon: UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")!)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTable()
        individualApi.delegate = self
        individualApi.feachData()
        
    }
    
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProfileTableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // this the default without scaling (average) .
        
        
    }
    
}

extension ProfileViewController: ApiDelegate{
    func didRetriveData(user: UserResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Perform the network operation in the background queue
            if let imageURL = URL(string: (user.results.first?.picture.large)!),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {

                DispatchQueue.main.async {
                    // Update UI on the main queue
                    self.setUpImageAsCircleWithShadowAndBorder()
                    self.userImageView.image = image
                    self.userNameLabel.text = user.results[0].name.first
                    self.setUpFont()
                }
            }
        }
    }
}


extension ProfileViewController: UITableViewDelegate{
    
}


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
    

}


extension ProfileViewController{
    
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
        
        // contentView corner
        contentView.layer.cornerRadius = 15
       
    }
    
    
    func setUpFontLabels(){
        
    }
    
    
    func setUpFont(){
//        let maximumFontSizeRestaurantName: CGFloat = 50.0
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            userNameLabel.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
    }

    func configureTabBar(){
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: nil)
        
        if let tabBarItem = self.tabBarItem {
            let scaledFont = UIFont.systemFont(ofSize: UIFont.labelFontSize).withSize(12.0) 
            tabBarItem.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
    }

    
}
