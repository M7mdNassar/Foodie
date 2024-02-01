import FirebaseStorage
import UIKit
import Foundation

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    private let storageRef = Storage.storage().reference()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { (url, error) in
                    if let url = url {
                        completion(.success(url))
                    } else if let error = error {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
         let storageRef = Storage.storage().reference(forURL: url)
         
         storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
             if let error = error {
                 completion(.failure(error))
             } else if let data = data, let image = UIImage(data: data) {
                 completion(.success(image))
             } else {
                 let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to download image"])
                 completion(.failure(error))
             }
         }
     }
}
