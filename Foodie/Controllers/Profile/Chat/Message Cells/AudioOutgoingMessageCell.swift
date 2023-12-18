import UIKit
import AVFoundation

class AudioOutgoingMessageCell: UITableViewCell {
    
  
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressBar: UISlider!
    
    var audioURL: URL?

    @IBAction func playButtonTapped(_ sender: UIButton) {
          if let audioURL = audioURL {
              AudioManager.shared.playAudio(at: audioURL, updateProgress: { [weak self] (progress) in
                  // Update progress bar here
                  self?.progressBar.value = Float(progress)
              })
          }
      }
    
    // MARK: - Configuration
    func configure(audioURL: URL, userImageUrl: String) {
        self.backgroundColor = .clear
        self.backgroundMessage.backgroundColor = .foodieLightGreen
        self.backgroundMessage.layer.cornerRadius = 15.0
        self.backgroundMessage.layer.masksToBounds = true

        self.progressBar.value = 0.0
        self.audioURL = audioURL

        loadUserImage(urlString: userImageUrl)
    }
    
    func loadUserImage(urlString: String) {
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
    
}
