
import UIKit

class CommunityViewController: UIViewController {

    // MARK: Properties
    
    var posts: [Post] = []
    var stories: [Story] = []
    let currentUser = UserManager.getUserFromUserDefaults()

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpCollection()
        populatePosts()
        populateStories()
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
    
    func populatePosts(){
        
        posts = [
        
            Post(postId: "1", username: currentUser?.name.first,content: "Hello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need helpHello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need helpHello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need help " , images: [UIImage(named: "1002")!] ,likes: 10, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images: [UIImage(named: "1003")!] , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images: [UIImage(named: "1005")!] , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images: [UIImage(named: "1004")!] , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")])
        ]
        
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



