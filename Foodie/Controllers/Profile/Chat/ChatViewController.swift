import UIKit
import IQKeyboardManagerSwift
import AVFoundation

class ChatViewController: UIViewController {

    // MARK: - Variables

    let currentUser = User.currentUser
    let otherUser = User(id: "123", userName: "Oday", email: "oday@gmail.com", pushId: "987" , avatarLink: "https://randomuser.me/api/portraits/women/77.jpg" , date: "" , phoneNumber:"224455" , country: "Jenin")
    
    private var messages: [Message] = []
    private var selectedImages: [UIImage] = []
    private let audioManager = AudioManager.shared
    private let testAudioURL = URL(fileURLWithPath: "/Users/mac/Library/Developer/mm.mp3")
    var isRecording = false
    private var isCancelled = false
    private var originalMicButtonCenter: CGPoint = .zero
    private var recordingTimer: Timer?
    private var recordingDuration: TimeInterval = 0
    
    
    // MARK: - Outlets

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var attach: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var selectedImagesCollectionView: UICollectionView!
    @IBOutlet weak var selectedImagesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelRecordingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        configureGestureRecognizer()
        setUpNavigationItem()
        setUpTable()
        setUpCollection()
        setUpTextView()
        populateMessages()
        addNotifications()
        sendButton.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }

    // MARK: - Actions

    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func sendButton(_ sender: UIButton) {
        sendMessage(text: textView.text, image: selectedImages.first)
    }

    @IBAction func sendImage(_ sender: UIButton) {
        showImagePicker()
    }

    private func sendMessage(text: String?, image: UIImage?) {
        guard text != "" || image != nil else {
            return
        }

        if text != nil && image == nil {
            let newMessage = Message(text: text, image: nil, audioURL: nil, sender: currentUser!, type: .text)
            messages.append(newMessage)
        } else if text == "" && image != nil {
            let newMessage = Message(text: nil, image: image, audioURL: nil, sender: currentUser!, type: .image)
            messages.append(newMessage)
        } else {
            let newMessage = Message(text: text, image: image, audioURL: nil, sender: currentUser!, type: .textAndImage)
            messages.append(newMessage)
        }

        tableView.reloadData()
        textView.text = nil
        sendButton.isHidden = true
        mic.isHidden = false
        selectedImages = []
        selectedImagesCollectionViewHeightConstraint.constant = 0
        selectedImagesCollectionView.isHidden = true
        scrollToBottom()
    }
    
    // MARK: - Private Methods

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    
        if gesture.state == .began {
            print("Long press began")
            if hasMicrophonePermission() {
                // Perform recording animation only if microphone permission is granted
                isRecording = true
                startRecordingAnnimation()
                originalMicButtonCenter = mic.center
                audioManager.startRecording()

            } else {
                // If microphone permission is not granted, show alert
                print("Microphone access is required to start recording.")
                requestMicrophonePermission()
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Only handle recording logic if the gesture was previously initiated
            guard isRecording else { return }
            print("Long press ended")
            isRecording = false // End of recording
            if !isCancelled {
                // Stop and send the recording if the gesture was not canceled
                audioManager.stopRecording()
                
                if let audioURL = self.audioManager.currentRecordingURL {
                    // Recording successful, create message and reload table
                    print("The Path is : \(audioURL)")
                    let newMessage = Message(text: nil, image: nil, audioURL: audioURL, sender: currentUser!, type: .audio)
                    messages.append(newMessage)
                    tableView.reloadData()
                    scrollToBottom()
                    print("created record")
                }
            } else {
                // Recording canceled
                print("Recording canceled")
                audioManager.cancelRecording()
                
            }
            // Stop recording animation and reset mic button position
            stopRecordingAnnimation()
            textView.text = ""
            isCancelled = false
            // Reset the microphone position with animation
            UIView.animate(withDuration: 0.3) {
                self.mic.center = self.originalMicButtonCenter
            }
        }
    }


    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
      
        if gesture.state == .changed {
            // Only handle pan gesture if long press is active
            guard isRecording else { return }

            let translation = gesture.translation(in: view)
            print("Pan gesture: \(translation)")
              
            // Check if the pan gesture is within the allowed range (-60 to 0)
            if translation.x >= -60 && translation.x <= 0 {
                mic.center.x = originalMicButtonCenter.x + translation.x
                
            } else if translation.x <= -60 {
                // Limit the pan gesture to -60 units
                mic.center.x = originalMicButtonCenter.x - 60
                isCancelled = true // Recording is canceled if dragged more than 60 units to the left
            }
        } 

    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = messages[indexPath.row].type
        let data = messages[indexPath.row]

        switch type {
        case .text:
            return configureTextCell(for: data, at: indexPath)

        case .image:
            return configureImageCell(for: data, at: indexPath)
        case .audio:
            return configureAudioCell(for: data, at: indexPath)

        case .textAndImage:
            return configureTextAndImageCell(for: data, at: indexPath)

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - Configure Cells Methods

private extension ChatViewController {

    func configureTextCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as TextOutgoingMessageCell
            cell.configure(messageText: data.text, userImageUrl: currentUser!.avatarLink)
            return cell
        } else {
            let cell = tableView.dequeue() as TextIncomingMessageCell
            cell.configure(messageText: data.text, userImageUrl: otherUser.avatarLink)
            return cell
        }
    }

    func configureImageCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as ImageOutgoingMessageCell
            cell.configure(messageImage: data.image, userImageUrl: currentUser!.avatarLink)
            return cell
        } else {
            let cell = tableView.dequeue() as ImageIncomingMessageCell
            cell.configure(messageImage: data.image, userImageUrl: otherUser.avatarLink)
            return cell
        }
    }

    func configureAudioCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as AudioOutgoingMessageCell
            cell.configure(audioURL: data.audioURL!, userImageUrl: currentUser!.avatarLink)
            return cell
        } else {
            let cell = tableView.dequeue() as AudioIncomingMessageCell
            cell.configure(audioURL: data.audioURL!, userImageUrl: otherUser.avatarLink)
            return cell
        }
    }

    func configureTextAndImageCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as TextAndImageOutgoingMessageCell
            cell.configure(messageText: data.text, messageImage: data.image, userImageUrl: currentUser!.avatarLink)
            return cell
        } else {
            let cell = tableView.dequeue() as TextAndImageIncomingMessageCell
            cell.configure(messageText: data.text, messageImage: data.image, userImageUrl: otherUser.avatarLink)
            return cell
        }
    }

}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let isTextViewEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            // Update the visibility of micButton and sendButton accordingly
            mic.isHidden = !isTextViewEmpty
            sendButton.isHidden = isTextViewEmpty
        
        updateTextViewHeight()
        scrollToBottom()
    }

    private func updateTextViewHeight() {
         let maxTextViewHeight: CGFloat = 50.0
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = min(newSize.height, maxTextViewHeight)
        textViewHeightConstraint.constant = newHeight
    }

}

// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        sendButton.isHidden = false
        mic.isHidden = true
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImages.append(pickedImage)
            selectedImagesCollectionViewHeightConstraint.constant = 80
            selectedImagesCollectionView.isHidden = false
            selectedImagesCollectionView.reloadData()
            dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

    // MARK: - Private Methods

private extension ChatViewController {
    
     func setUpTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell: TextOutgoingMessageCell.self)
        tableView.register(Cell: TextIncomingMessageCell.self)
        tableView.register(Cell: ImageIncomingMessageCell.self)
        tableView.register(Cell: ImageOutgoingMessageCell.self)
        tableView.register(Cell: AudioIncomingMessageCell.self)
        tableView.register(Cell: AudioOutgoingMessageCell.self)
        tableView.register(Cell: TextAndImageOutgoingMessageCell.self)
        tableView.register(Cell: TextAndImageIncomingMessageCell.self)

         let backgroundImage = UIImageView(image: UIImage(named: "whatsApp background"))
         backgroundImage.contentMode = .scaleAspectFill
         backgroundImage.clipsToBounds = true
         tableView.backgroundView = backgroundImage
         
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
    }

     func setUpNavigationItem() {
        navigationController?.setNavigationBarHidden(true, animated: false)
         self.userImageView.load(from : otherUser.avatarLink)
        userNameLabel.text = otherUser.userName
    }

     func setUpTextView() {
        textView.layer.cornerRadius = 15.0
        textView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        textView.layer.borderWidth = 1.0
        textView.delegate = self
    }


     func populateMessages() {
        messages = [
            Message(text: "Helo!Helo!Helo!Helo!Helo!Helo!Helo!Helo!Helo!", image: nil, audioURL: nil, sender: currentUser!, type: .text),
            Message(text: "Hi there!", image: nil, audioURL: nil, sender: otherUser, type: .text),
            Message(text: "Hi there!", image: nil, audioURL: nil, sender: currentUser!, type: .text),
            Message(text: "Helo!Helo!Helo!...", image: nil, audioURL: nil, sender: otherUser, type: .text),
            Message(text: nil, image: UIImage(named: "1005"), audioURL: nil, sender: currentUser!, type: .image),
            Message(text: nil, image: UIImage(named: "1002"), audioURL: nil, sender: otherUser, type: .image),
            Message(text: nil, image: UIImage(named: "1003"), audioURL: nil, sender: otherUser, type: .image),
            Message(text: nil, image: UIImage(named: "1004"), audioURL: nil, sender: currentUser!, type: .image),
            Message(text: nil, image: UIImage(named: "1001"), audioURL: nil, sender: currentUser!, type: .image),
            Message(text: nil, image: nil, audioURL: testAudioURL, sender: otherUser, type: .audio),
            Message(text: "mohamad hello", image: UIImage(named: "1005"), audioURL: nil, sender: currentUser!, type: .textAndImage),
            Message(text: nil, image: UIImage(named: "1004"), audioURL: nil, sender: otherUser, type: .image)
        ]
    }


     func scrollToBottom() {
        if tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: tableView.numberOfSections - 1) > 0 {
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1, section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    // Helper function to request microphone permission
     func requestMicrophonePermission() {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { [weak self] (granted) in
            guard let self = self else { return }
            
            if !granted {
      
                // Permission denied, request permission again
                let alertController = UIAlertController(title: "Microphone Access Required", message: "Please grant microphone access to start recording.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

}

// MARK: - Keyboard Handling

extension ChatViewController {

    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            bottomConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

            let lastRowIndex = self.tableView.numberOfRows(inSection: 0) - 1
            if lastRowIndex >= 0 {
                let indexPath = IndexPath(row: lastRowIndex, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        scrollToBottom()
    }

}

// MARK: Show Selected Image in the Collection View

extension ChatViewController : UICollectionViewDataSource , UICollectionViewDelegate{
    
    func setUpCollection() {
      selectedImagesCollectionView.delegate = self
        selectedImagesCollectionView.dataSource = self
      let nib = UINib(nibName: "selectedImagesCollectionViewCell", bundle: nil)
        selectedImagesCollectionView.register(nib, forCellWithReuseIdentifier: "selectedImagesCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return selectedImages.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedImagesCollectionViewCell", for: indexPath) as! selectedImagesCollectionViewCell
        cell.imageView.image = selectedImages[indexPath.row]
      return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 80, height: 80)
    }
    
    
}


 // MARK: Recording Annimations

extension ChatViewController {
    
    func startRecordingAnnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.07) {
                let scaled = CGAffineTransform(scaleX: 1.7, y: 1.7)
                self.mic.transform = scaled
                
                self.textView.isHidden = true
                self.cancelRecordingLabel.isHidden = false
                self.attach.isHidden = true
                                
            }
            
            // Animate the cancelRecordingLabel back and forth
            UIView.animate(withDuration: 0.8, delay: 0, options: [.autoreverse, .repeat]) {
                self.cancelRecordingLabel.alpha = 0.7
                self.cancelRecordingLabel.transform = CGAffineTransform(translationX: -35, y: 0)
            }
        }
    }
    
    func stopRecordingAnnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.07) {
                self.mic.transform = .identity
                self.textView.isHidden = false
                self.attach.isHidden = false
                self.cancelRecordingLabel.isHidden = true
                self.cancelRecordingLabel.alpha = 1
                self.cancelRecordingLabel.transform = .identity
            }
        }
    }
}

    // MARK: Gestures On Mic Button (Long + Pan)
extension ChatViewController: UIGestureRecognizerDelegate {
    
    func configureGestureRecognizer() {
        
        // Add a long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.2 // Adjust this as needed
        mic.addGestureRecognizer(longPressGesture)
        
        longPressGesture.delegate = self

           // Add a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.minimumNumberOfTouches = 1
        mic.addGestureRecognizer(panGesture)
        
       }

    // To let the long gesture work simultaneously with Pan
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: Timer For Duration label (Recording ..)

extension ChatViewController{
    private func startRecordingTimer() {
        durationLabel.isHidden = false
          recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRecordingDuration), userInfo: nil, repeats: true)
      }

      private func stopRecordingTimer() {
          recordingTimer?.invalidate()
          recordingTimer = nil
          recordingDuration = 0
          // Remove duration label
          durationLabel.isHidden = true
      }

      @objc private func updateRecordingDuration() {
          recordingDuration += 1
          updateDurationLabel()
      }

      private func updateDurationLabel() {
          let minutes = Int(recordingDuration) / 60
          let seconds = Int(recordingDuration) % 60
          durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
      }

}
