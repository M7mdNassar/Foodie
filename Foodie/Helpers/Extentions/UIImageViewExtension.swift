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

    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    
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
