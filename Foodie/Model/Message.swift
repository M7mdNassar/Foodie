import Foundation
import UIKit

// MARK: MessageType Enum

enum MessageType: String {
    case text
    case image
    case audio
    case textAndImage
}

// MARK: Message Struct

struct Message {
    let text: String
    let image: UIImage?
    let audioURL: URL?
    let sender: User
    let type: MessageType
}

