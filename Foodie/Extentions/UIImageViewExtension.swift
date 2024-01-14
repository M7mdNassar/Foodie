import UIKit

// MARK: Extension UIImageView

extension UIImageView {

    func load(from urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: urlString),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {

                DispatchQueue.main.async {
                    self.layer.cornerRadius = self.frame.width / 2
                    self.image = image
                }
            }
        }
    }
    
}

// MARK: Extension UIImage

extension UIImage {
    
    func calculateImageDimensions(maxWidth: CGFloat, minWidth: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let imageWidth = self.size.width
        let imageHeight = self.size.height
         let aspectRatio = imageWidth / imageHeight

         // Calculate width based on maximum width and aspect ratio
         let width = min(maxWidth, max(minWidth, imageWidth))
         let height = width / aspectRatio

         return (width, height)
     }
    
}

