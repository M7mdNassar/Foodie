import UIKit
import AVFoundation

class AudioIncomingMessageCell: UITableViewCell, AudioManagerDelegate {

    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var totalDuration: TimeInterval = 0

    var audioURL: URL?

    @IBAction func playButtonTapped(_ sender: UIButton) {
            if let audioURL = audioURL {
                AudioManager.shared.getAudioDuration(at: audioURL) { [weak self] (totalDuration) in
                    guard let totalDuration = totalDuration else {
                        // Handle error
                        return
                    }

                    self!.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    // Store total duration in the cell
                    self?.totalDuration = totalDuration

                    // Update UI with total duration (you may want to format it)
                    let totalDurationString = self?.formatTime(seconds: Int(totalDuration))
                    self?.timeLabel.text = totalDurationString

                    // Now you can initiate playback
                    AudioManager.shared.playAudio(at: audioURL,
                                                  updateProgress: { [weak self] (progress) in
                                                      // Update progress bar here
                                                      self?.progressBar.value = Float(progress)
                                                  },
                                                  updateTimeLabel: { [weak self] (timeString) in
                                                      // Update time label here
                                                      self?.timeLabel.text = timeString
                                                  })
                }
            }
        }

        // Helper method to format time in seconds as mm:ss
        private func formatTime(seconds: Int) -> String {
            let minutes = seconds / 60
            let seconds = seconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    // MARK: - Configuration
    func configure(audioURL: URL, userImageUrl: String) {
           self.backgroundColor = .clear
           self.backgroundMessage.backgroundColor = .foodieLightBlue
           self.backgroundMessage.layer.cornerRadius = 15.0
           self.backgroundMessage.layer.masksToBounds = true
           self.progressBar.value = 0
           self.audioURL = audioURL
           AudioManager.shared.delegate = self
        
           loadUserImage(urlString: userImageUrl)

           // Get audio duration and update the time label
           AudioManager.shared.getAudioDuration(at: audioURL) { [weak self] (totalDuration) in
               guard let totalDuration = totalDuration else {
                   // Handle error
                   return
               }

               // Update UI with total duration (you may want to format it)
               let totalDurationString = self?.formatTime(seconds: Int(totalDuration))
               self?.timeLabel.text = totalDurationString
           }
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
    
    func playbackFinished() {
           playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
       }
}


