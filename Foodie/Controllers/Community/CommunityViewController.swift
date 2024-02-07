
import UIKit
import FirebaseDatabase
import SDWebImage
import SKPhotoBrowser

class CommunityViewController: UIViewController {

    // MARK: Properties
    
    var posts: [Post] = []
    var stories: [Story] = []
    var currentUser = User.currentUser
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideLoadingView() }
        
        setUpTable()
        setUpCollection()
        getPosts()
        populateStories()
        
        print("End Point URL : " , Env().configure(InfoPlistKey.EndpointURL))
    }
    
    func getPosts(){
        RealtimeDatabaseManager.shared.getPostsFromRTDatabase { posts in
            
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
  
}

// MARK: UIColletionDataSource , Delegate

extension CommunityViewController: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = stories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! StoryCollectionViewCell
        cell.configure(userName: data.userName, storyImage: data.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
}


// MARK: UITableViewDatasource & Delegate

extension CommunityViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        let cell = tableView.dequeue() as PostCell
        cell.delegate = self
        cell.textPostLabel.isExpaded = false

        cell.configure(post: post)
      
        return cell
    }
    
}



 // MARK: Methods
extension CommunityViewController{
    
    func setUpTable() {
       tableView.dataSource = self
       tableView.delegate = self
       tableView.register(Cell: PostCell.self)
    
        
       tableView.separatorStyle = .none
       tableView.rowHeight = UITableView.automaticDimension
       tableView.estimatedRowHeight = 44
       tableView.allowsSelection = false
   }
    
    func setUpCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "StoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "storyCell")
    }
    
  
    
    func populateStories(){
        
        stories = [
            Story(userName: "Mohammed", image: UIImage(named: "1001")!),
            Story(userName: "Ammar", image: UIImage(named: "1002")!),
            Story(userName: "Oday", image: UIImage(named: "1003")!),
            Story(userName: "Ahmad", image: UIImage(named: "1004")!),
            Story(userName: "Ahmad", image: UIImage(named: "1003")!),
            Story(userName: "Ahmad", image: UIImage(named: "1005")!)
        
        ]
        
    }

}


// MARK: - Loading View
extension CommunityViewController {
    private func showLoadingView() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.tag = 123 // Set a unique tag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        let loadingViewTag = 123 // Assign a unique tag to your loading view
        if let loadingView = view.viewWithTag(loadingViewTag) {
            loadingView.removeFromSuperview()
        }
    }
}



// MARK: Show the image from post cell

extension CommunityViewController: PostCellDelegate {

    func postCell(_ cell: PostCell, didSelectImageAt indexPath: IndexPath) {
        guard let imageUrl = cell.postImages[indexPath.item] else {
            return
        }

        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(imageUrl)
        photo.shouldCachePhotoURLImage = false
        images.append(photo)

        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)

        // Here you can present the SKPhotoBrowser
        present(browser, animated: true, completion: nil)
    }
}
