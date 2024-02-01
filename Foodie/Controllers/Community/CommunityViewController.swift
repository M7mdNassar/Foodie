
import UIKit
import FirebaseDatabase

class CommunityViewController: UIViewController {

    // MARK: Properties
    
    var posts: [Post] = []
    var stories: [Story] = []
    var currentUser = UserManager.getUserFromUserDefaults()
    
    var ref: DatabaseReference!
    var databaseHandle : DatabaseHandle!
    
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
        
        ref = Database.database().reference().child("posts")
        observePosts()
        
        populateStories()
        
        print("End Point URL : " , Env().configure(InfoPlistKey.EndpointURL))
    }
    
    
    // MARK: Methods
      func observePosts() {
          databaseHandle = ref.observe(.value, with: { snapshot in
              self.posts.removeAll() // Clear the existing posts
              
              for case let child as DataSnapshot in snapshot.children {
                  if let postDict = child.value as? [String: Any],
                     let postId = postDict["postId"] as? String,
                     let username = postDict["username"] as? String,
                     let content = postDict["content"] as? String,
                     let imageUrls = postDict["imageUrls"] as? [String] {
                      let post = Post(postId: postId, username: username, content: content, images: imageUrls , likes: 0,comments: [])
                      self.posts.append(post)
                  }
              }
              
              self.tableView.reloadData()
          })
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
        cell.configure(userName: data.username, storyImage: data.image)
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

        cell.textPostLabel.isExpaded = false

        cell.configure(userImage: currentUser?.picture.large, post: post)
      
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
        Story(username: "Mohammed", image: UIImage(named: "1001")!),
        Story(username: "Ammar", image: UIImage(named: "1002")!),
        Story(username: "Oday", image: UIImage(named: "1003")!),
        Story(username: "Ahmad", image: UIImage(named: "1004")!),
        Story(username: "Ahmad", image: UIImage(named: "1003")!),
        Story(username: "Ahmad", image: UIImage(named: "1005")!)
        
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
