import UIKit
import IQKeyboardManagerSwift
import AVFoundation

class ChatViewController: UIViewController {

    // MARK: - Variables

    let currentUser = UserManager.getUserFromUserDefaults()
    let otherUser = User(gender: "female", name: Name(first: "Krystle", last: "Melis"), email: "krystle.melis@example.com", dob: DateOfBirth(date: "1987-02-03T21:40:35.906Z", age: 36), phone: "(025) 7310305", id: ID(name: "BSN", value: "51718516"), picture: Picture(large: "https://randomuser.me/api/portraits/women/77.jpg"))
    var messages: [Message] = []
    var selectedImage: UIImage?
    var longPressGesture: UILongPressGestureRecognizer!
    private let audioManager = AudioManager.shared
    let testAudioURL = URL(fileURLWithPath: "/Users/mac/Library/Developer/mm.mp3")

    // MARK: - Outlets

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        configureGestureRecognizer()
        mic.addGestureRecognizer(longPressGesture)
        setUpNavigationItem()
        setUpTable()
        setUpTextView()
        populateMessages()
        addNotifications()
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
        sendMessage(text: textView.text, image: selectedImage)
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
        selectedImage = nil
        scrollToBottom()
    }
    

    @objc private func recordAndSend() {
        switch longPressGesture.state {
        case .began:
            sendButton.isHidden = true
            print("Recording...")
            audioManager.startRecording()

        case .ended:
            sendButton.isHidden = false
            print("Stopped recording.")
            audioManager.stopRecording()

            // Create message and reload table
            let audioURL = audioManager.currentRecordingURL
            print("The Path is : \(String(describing: audioURL!))")
            
            let newMessage = Message(text: nil, image: nil, audioURL: audioURL, sender: currentUser!, type: .audio)
            messages.append(newMessage)
            tableView.reloadData()
            scrollToBottom()

        default:
            print("Unknown")
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
            cell.configure(messageText: data.text, userImageUrl: currentUser!.picture.large)
            return cell
        } else {
            let cell = tableView.dequeue() as TextIncomingMessageCell
            cell.configure(messageText: data.text, userImageUrl: otherUser.picture.large)
            return cell
        }
    }

    func configureImageCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as ImageOutgoingMessageCell
            cell.configure(messageImage: data.image, userImageUrl: currentUser!.picture.large)
            return cell
        } else {
            let cell = tableView.dequeue() as ImageIncomingMessageCell
            cell.configure(messageImage: data.image, userImageUrl: otherUser.picture.large)
            return cell
        }
    }

    func configureAudioCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as AudioOutgoingMessageCell
            cell.configure(audioURL: data.audioURL!, userImageUrl: currentUser!.picture.large)
            return cell
        } else {
            let cell = tableView.dequeue() as AudioIncomingMessageCell
            cell.configure(audioURL: data.audioURL!, userImageUrl: otherUser.picture.large)
            return cell
        }
    }

    func configureTextAndImageCell(for data: Message, at indexPath: IndexPath) -> UITableViewCell {
        if data.sender == currentUser {
            let cell = tableView.dequeue() as TextAndImageOutgoingMessageCell
            cell.configure(messageText: data.text, messageImage: data.image, userImageUrl: currentUser!.picture.large)
            return cell
        } else {
            let cell = tableView.dequeue() as TextAndImageIncomingMessageCell
            cell.configure(messageText: data.text, messageImage: data.image, userImageUrl: otherUser.picture.large)
            return cell
        }
    }

}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
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

        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
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
        loadUserImage(from: otherUser.picture.large)
        userNameLabel.text = otherUser.name.first
    }

     func setUpTextView() {
        textView.layer.cornerRadius = 15.0
        textView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        textView.layer.borderWidth = 1.0
        textView.delegate = self
    }

     func configureGestureRecognizer() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
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

     func loadUserImage(from urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: urlString),
                let imageData = try? Data(contentsOf: imageURL),
                let image = UIImage(data: imageData) {

                DispatchQueue.main.async {
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                    self.userImageView.image = image
                }
            }
        }
    }

     func scrollToBottom() {
        if tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: tableView.numberOfSections - 1) > 0 {
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1, section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
