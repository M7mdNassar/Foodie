import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    // MARK: - Variables

    let currentUser = UserManager.getUserFromUserDefaults()
    
    let otherUser = User(gender: "female", name: Name(first: "Krystle", last: "Melis"), email: "krystle.melis@example.com", dob: DateOfBirth(date: "1987-02-03T21:40:35.906Z", age: 36), phone: "(025) 7310305", id: ID(name: "BSN", value: "51718516"), picture: Picture(large: "https://randomuser.me/api/portraits/women/77.jpg"))

    var messages: [Message] = []
    private let defaultTextViewHeight: CGFloat = 33.0
    private let maxTextViewHeight: CGFloat = 50.0

    // MARK: - Outlets
  
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        setUpNavigationItem()
        setUpTable()
        setUpTextView()
        populateMessages()
        addNotifications()


    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           scrollToBottom() // Scroll to the last cell when the view appears
       }

    // MARK: - Actions

    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        // Get the text from the textView
              guard let messageText = textView.text, !messageText.isEmpty else {
                  return // Don't send empty messages
              }

              // Create a new message and add it to the messages array
           let newMessage = Message(text: messageText, image: nil, sender: currentUser!, type: .text)
               messages.append(newMessage)

              // Reload the table view to display the new message
              tableView.reloadData()

              // Clear the textView after sending the message
              textView.text = ""

              // Scroll to the bottom to show the latest message
              scrollToBottom()
        
        // Reset textView height to the original value
           textViewHeightConstraint.constant = defaultTextViewHeight
           view.layoutIfNeeded()
        
    }
    
    @IBAction func sendImage(_ sender: UIButton) {
        showImagePicker()
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
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - Private Methods

private extension ChatViewController {

    func populateMessages() {
        messages = [
            Message(text: "Helo!Helo!Helo!Helo!Helo!Helo!Helo!Helo!Helo!", image: nil, sender: currentUser!, type: .text),
            Message(text: "Hi there!", image: nil, sender: otherUser, type: .text),
            Message(text: "Hi there!", image: nil, sender: currentUser!, type: .text),
            Message(text: "Helo!Helo!Helo!...", image: nil, sender: otherUser, type: .text),
            Message(text: "", image: UIImage(named: "1005"), sender: currentUser!, type: .image),
            Message(text: "", image: UIImage(named: "1002"), sender: otherUser, type: .image),
            Message(text: "", image: UIImage(named: "1003"), sender: otherUser, type: .image),
            Message(text: "", image: UIImage(named: "1004"), sender: currentUser!, type: .image),
            Message(text: "", image: UIImage(named: "1001"), sender: currentUser!, type: .image)
        ]
    }

    func setUpTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell: TextOutgoingMessageCell.self)
        tableView.register(Cell: TextIncomingMessageCell.self)
        tableView.register(Cell: ImageIncomingMessageCell.self)
        tableView.register(Cell: ImageOutgoingMessageCell.self)

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    func setUpNavigationItem() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadUserImage(from: otherUser.picture.large)
        userNameLabel.text = otherUser.name.first
    }
    
    func setUpTextView(){
        textView.layer.cornerRadius = 15.0
        textView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        textView.layer.borderWidth = 1.0
        
        textView.delegate = self
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
            cell.configure(messageImage: data.image ?? UIImage(named: "1001")!, userImageUrl: currentUser!.picture.large)
            return cell
        } else {
            let cell = tableView.dequeue() as ImageIncomingMessageCell
            cell.configure(messageImage: data.image ?? UIImage(named: "1001")!, userImageUrl: otherUser.picture.large)
            return cell
        }
    }

}


extension ChatViewController: UITextViewDelegate{
    
    
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the expected height based on the content size of the textView
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = min(newSize.height, maxTextViewHeight) // Limit the height to maxTextViewHeight

        // Update the textView's height constraint
        textViewHeightConstraint.constant = newHeight

        // Scroll the tableView to the bottom when the textView expands
        scrollToBottom()
    }
    
}

    // MARK: UIImagePickerControllerDelegate

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
        private func showImagePicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dismiss(animated: true, completion: nil)
            
            if let pickedImage = info[.originalImage] as? UIImage {
             
                let newMessage = Message(text: "", image: pickedImage, sender: currentUser!, type: .image)
                messages.append(newMessage)
                
                // Reload the table view to display the new message
                tableView.reloadData()
                
                // Scroll to the bottom to show the latest message
                scrollToBottom()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}



// MARK: - Keyboard Handling

extension ChatViewController {
    
    func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                
                let keyboardHeight = keyboardFrame.height

                bottomConstraint.constant = keyboardHeight
                // Animate the changes with duration
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                
                // Scroll the table view to the last cell
                     let lastRowIndex = self.tableView.numberOfRows(inSection: 0) - 1
                     if lastRowIndex >= 0 {
                         let indexPath = IndexPath(row: lastRowIndex, section: 0)
                         self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                     }
            }
        }

        @objc func keyboardWillHide(_ notification: Notification) {
            // Reset bottom view and table view constraints to original positions
            bottomConstraint.constant = 0
            // Animate the changes with duration
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            scrollToBottom()
        }
}
