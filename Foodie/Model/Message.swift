import Foundation
import UIKit

// MARK: MessageType Enum

enum MessageType : CaseIterable {
    case text
    case image
}

// MARK: Message Struct

struct Message {
    let text: String
    let image: UIImage?
    let sender: User
    let type: MessageType
}
