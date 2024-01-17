import UIKit

class AddPostViewController: UIViewController {
    
    // MARK: Properties
    
    let currentUser = UserManager.getUserFromUserDefaults()
    var communityViewController: CommunityViewController?
    var images: [UIImage] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var addImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        let post = Post(postId: "uniqueID", username: "currentUser", content: postContent.text, images: images, likes: 0, comments: [])
        // Check if communityViewController is not nil and its tableView is not nil
         if let tableView = self.communityViewController?.tableView {
             self.communityViewController?.posts.insert(post, at: 0)
             print("dose execute ?")
             tableView.reloadData()
         }

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImages(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpCollection()
        setUpTextView()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension AddPostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

// MARK: UIImagePickerControllerDelegate

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            images.append(pickedImage)
            collectionView.reloadData()
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextViewDelegate

extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder when the user starts typing
        if textView.text == "اكتب منشورك هنا..." {
            textView.text = ""
            textView.textColor = UIColor.black // Set text color to black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Add placeholder if the text is empty
        if textView.text.isEmpty {
            textView.text = "اكتب منشورك هنا..."
            textView.textColor = UIColor.lightGray // Set text color to lightGray
        }
    }
}
// MARK: Private Methods

private extension AddPostViewController {
    func setUpCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCell")
    }
    
    func setUpTextView() {
        postContent.delegate = self
        postContent.text = "اكتب منشورك هنا..." // Set the initial placeholder
        postContent.textColor = UIColor.lightGray
    }
    
    func setUpView() {
        self.userImageView.load(from: (self.currentUser?.picture.large)!)
        self.userNameLabel.text = self.currentUser?.name.first
        
        self.postButton.layer.cornerRadius = 15
        self.postButton.clipsToBounds = true
        
//        self.addImageButton.layer.cornerRadius = 15
//        self.addImageButton.clipsToBounds = true
    }
}
