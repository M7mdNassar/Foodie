import UIKit
import FirebaseDatabase
import FirebaseStorage
import Gallery
import ProgressHUD

class AddPostViewController: UIViewController {
   
  // MARK: Properties
   
  let currentUser = User.currentUser
  var communityViewController: CommunityViewController?
  var images: [UIImage] = []
  var gallery: GalleryController!
   
   
  // MARK: Outlets
   
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var postContent: UITextView!
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeightConstrain: NSLayoutConstraint!
    
    
   // MARK: Life Cycle Controller
     
    override func viewDidLoad() {
      super.viewDidLoad()
      setUpView()
      setUpCollection()
      setUpTextView()
       
    }

    
  // MARK: Actions
   
  @IBAction func backButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
    
    @IBAction func postButton(_ sender: UIButton) {
        guard
            let userImageUrl = currentUser?.avatarLink,
            let userName = currentUser?.userName,
            let content = postContent.text else {
                return
        }
        
        var imageUrls: [String] = []
        let dispatchGroup = DispatchGroup() // dispatch group to track completion of all image uploads
        
        for image in images {
            dispatchGroup.enter() // Enter the dispatch group before starting each image upload
            
            uploadPostImages(image: image) { imageUrl in
                if let imageUrl = imageUrl {
                    imageUrls.append(imageUrl)
                } else {
                    ProgressHUD.error("Failed to upload post images.")
                }
                
                dispatchGroup.leave() // Leave the dispatch group after each image upload is completed
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // All image uploads are completed
            let post = Post(postId: UUID().uuidString, userName: userName, userImageUrl: userImageUrl, content: content, imageUrls: imageUrls, likes: 0, comments: [])
            
            
            
            // Check if the presenting view controller is a tab bar controller
            if let tabBarController = self.presentingViewController as? UITabBarController {
                        // Set the selectedIndex to the index of the first tab (CommunityViewController)
                        tabBarController.selectedIndex = 0
                    }
                    
            // go to community
            if let communityViewController = self.communityViewController {
                        if let tableView = communityViewController.tableView {
                            
                            RealtimeDatabaseManager.shared.addPost(post: post)
                            self.dismiss(animated: true)

                            ProgressHUD.success("Post added successfully!")
                        }
                    }
          
        }
    }

    func uploadPostImages(image: UIImage, completion: @escaping (String?) -> Void) {
        let fileDirectory = "PostImages/" + "_\(UUID().uuidString)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { imageUrl in
            completion(imageUrl)
        }
    }


  @IBAction func addImages(_ sender: UIButton) {
      showGallery()
      
  }
   
}

// MARK: Gallery

extension AddPostViewController : GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        self.collectionViewHeightConstrain.constant = 100
        for image in images{
            image.resolve { image in
                if let image = image{
                    self.images.append(image)
                    self.collectionView.reloadData()
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
        Config.Camera.imageLimit = 10
        Config.initialTab = .imageTab
        self.present(self.gallery, animated: true)
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
      self.userImageView.sd_setImage(with: URL(string: self.currentUser!.avatarLink))
      self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
      
    self.userNameLabel.text = self.currentUser!.userName

    self.postButton.layer.cornerRadius = 15
    self.postButton.clipsToBounds = true
     
//    self.addImageButton.layer.cornerRadius = 15
//    self.addImageButton.clipsToBounds = true
  }
}

