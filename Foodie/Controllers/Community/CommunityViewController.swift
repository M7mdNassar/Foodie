
import UIKit
import FirebaseDatabase
import SDWebImage
import SKPhotoBrowser

class CommunityViewController: UIViewController {

    // MARK: Properties
    
    var posts: [Post] = []
    var stories: [Story] = []
    var currentUser = User.currentUser
    let realtimeDatabaseManager = RealtimeDatabaseManager()
    // MARK: Outlets
    
    @IBOutlet weak var storiesCollectionView: UICollectionView!
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
        
        if post.imageUrls.isEmpty{
            
        let cell = tableView.dequeue() as TextPostCell
            cell.textPostLabel.isExpaded = false
            cell.configure(post: post)
            return cell
        }
        
        else
        {
            let cell = tableView.dequeue() as MixedPostCell
            cell.delegate = self
            cell.textPostLabel.isExpaded = false
            cell.configure(post: post)
            return cell
        }

    }
    
    private func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        // Load more data when the user reaches near the bottom
        if position > (contentHeight - screenHeight) {
            guard !realtimeDatabaseManager.isPagination else {
                // We are already fetching more data
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()

            // Start fetching more data
            realtimeDatabaseManager.isPagination = true
            let lastPostId = posts.last?.postId // Retrieve the last post ID from the current posts
            realtimeDatabaseManager.getPostsFromRTDatabase(startingAfter: lastPostId) { [weak self] additionalPosts in
                guard let self = self else { return }

                // Check if there are additional posts
                if additionalPosts.isEmpty {
                    // No more posts to fetch
                    self.realtimeDatabaseManager.isPagination = false
                    self.tableView.tableFooterView = nil
                    return
                }

                // Append the additional posts to the existing array
                self.posts.append(contentsOf: additionalPosts)

                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    // Reload the table view with the new data
                    self.tableView.reloadData()
                    self.realtimeDatabaseManager.isPagination = false
                }
            }
        }
    }


}



 // MARK: Methods
extension CommunityViewController{
    
    func setUpTable() {
       tableView.dataSource = self
       tableView.delegate = self
       tableView.register(Cell: MixedPostCell.self)
        tableView.register(Cell: TextPostCell.self)
        
       tableView.separatorStyle = .none
       tableView.rowHeight = UITableView.automaticDimension
       tableView.estimatedRowHeight = 44
       tableView.allowsSelection = false
   }
    
    func setUpCollection(){
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        let nib = UINib(nibName: "StoryCollectionViewCell", bundle: nil)
        storiesCollectionView.register(nib, forCellWithReuseIdentifier: "storyCell")
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

extension CommunityViewController: MixedPostCellDelegate {

    func mixedPostCell(_ cell: MixedPostCell, didSelectImageAt indexPath: IndexPath) {
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
