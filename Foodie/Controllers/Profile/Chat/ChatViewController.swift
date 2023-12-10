import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    // MARK: - Variables

    let currentUser = UserManager.getUserFromUserDefaults()
    
    let otherUser = User(gender: "female", name: Name(first: "Krystle", last: "Melis"), email: "krystle.melis@example.com", dob: DateOfBirth(date: "1987-02-03T21:40:35.906Z", age: 36), phone: "(025) 7310305", id: ID(name: "BSN", value: "51718516"), picture: Picture(large: "https://randomuser.me/api/portraits/women/77.jpg"))

    var messages: [Message] = []

    // MARK: - Outlets

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        setUpNavigationItem()
        setUpTable()
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
            Message(text: "", image: UIImage(named: "1001"), sender: currentUser!, type: .image),
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

// MARK: - Keyboard Handling

extension ChatViewController {
    
    func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let topViewHeight = topView.frame.height
            let bottomViewHeight = bottomView.frame.height
            let newTableViewHeight = view.frame.height - keyboardSize.height - bottomViewHeight - topViewHeight
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.size.height = newTableViewHeight
                self.view.layoutIfNeeded()
            }

            
            let newBottomViewY = self.view.frame.height - keyboardSize.height - bottomViewHeight
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin.y = newBottomViewY
                self.view.layoutIfNeeded()
            }

            
            // Calculate the offset needed to keep the last cell visible above the keyboard
            let lastCellIndexPath = IndexPath(row: self.messages.count - 1, section: 0)
            let lastCellRect = self.tableView.rectForRow(at: lastCellIndexPath)
            let offset = lastCellRect.origin.y + bottomViewHeight - newTableViewHeight
            
            // Set the content inset to avoid hiding the last cell behind the keyboard
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offset, right: 0)
            
            // Scroll to the last cell
            self.tableView.scrollToRow(at: lastCellIndexPath, at: .bottom, animated: true)
        }
    }

    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the table view height and content inset when the keyboard hides
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.size.height = self.view.frame.height - self.topView.frame.height - self.bottomView.frame.height
            self.view.layoutIfNeeded()
            self.bottomView.frame.origin.y = self.view.frame.height - self.bottomView.frame.height
        }
        
        tableView.contentInset = UIEdgeInsets.zero
    }
}
