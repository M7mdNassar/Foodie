
import UIKit
import AVFoundation

class AudioIncomingMessageCell: UITableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    // Store the audio player as a property
    var audioPlayer: AVAudioPlayer?

    // Store the audio URL
    var audioURL: URL?

    @IBAction func playButton(_ sender: UIButton) {
        // Start playing the audio
        if let audioURL = audioURL {
            print(audioURL)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                print("done")
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Configuration
    func configure(audioURL: URL , userImageUrl: String) {
        self.backgroundMessage.backgroundColor = .foodieLightBlue
        self.backgroundMessage.layer.cornerRadius = 15.0
        self.backgroundMessage.layer.masksToBounds = true

        self.audioURL = audioURL
        loadUserImage(urlString : userImageUrl)
    
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
    
    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle audio playback completion if needed
    }

    
}
