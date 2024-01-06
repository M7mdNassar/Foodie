
import UIKit

class CommunityViewController: UIViewController {

    // MARK: Properites
    var selectedImage: UIImage?
    var postText: String?

    var posts: [Post] = []
    var stories: [Story] = []
    let currentUser = UserManager.getUserFromUserDefaults()
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!


    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpTable()
        setUpCollection()
        populatePosts()
        populateStories()

    }
    
    // MARK: Actions
    
    @IBAction func addPostButton(_ sender: UIButton) {
        showPostAlert()
    }

    func showPostAlert() {
        let alertController = UIAlertController(title: "انشاء منشور", message: "", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "اكتب منشورك هنا ..."
            textField.text = self.postText // Set the stored text back to the text field
        }

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        let addImageAction = UIAlertAction(title: "اضافه صوره", style: .default) { _ in
            self.postText = alertController.textFields?.first?.text // Store the text before presenting image picker
            self.present(imagePicker, animated: true, completion: nil)
        }

        let addAction = UIAlertAction(title: "انشر", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let text = alertController.textFields?.first?.text, !text.isEmpty {

                let newPost: Post
                if let selectedImage = self.selectedImage {
                    newPost = Post(postId: UUID().uuidString, username: self.currentUser?.name.first, content: text, images: selectedImage, likes: 0, comments: [])
                } else {
                    newPost = Post(postId: UUID().uuidString, username: self.currentUser?.name.first, content: text, images: nil, likes: 0, comments: [])
                }

                self.posts.insert(newPost, at: 0) // Insert at the beginning of the array
                self.tableView.reloadData()
                self.selectedImage = nil
                self.postText = nil // Reset the stored text after adding the post
            }
        }

        let cancelAction = UIAlertAction(title: "تجاهل", style: .cancel, handler: nil)

        alertController.addAction(addImageAction)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
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
    
    func setUpNavigationItem() {
       navigationController?.setNavigationBarHidden(false, animated: false)
   }
    
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
        
            Post(postId: "1", username: currentUser?.name.first,content: "Hello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need helpHello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need helpHello , i need help !Hello , i need help Hello , i need help Hello , i need help Hello , i need help Hello , i need help " , images: UIImage(named: "1002")! ,likes: 10, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images:UIImage(named: "1003")! , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images:UIImage(named: "1005")! , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")]) ,
            Post(postId: "2", username: currentUser?.name.first,content: "Hello" ,images:UIImage(named: "1004")! , likes: 13, comments: [Comment(username: "Mohammed", text: "Good") , Comment(username: "Ahmad", text: "Nice!")])
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


extension CommunityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.selectedImage = pickedImage
        }

        picker.dismiss(animated: true) {
            self.showPostAlert() // Call showPostAlert after dismissing image picker
        }
    }
}


