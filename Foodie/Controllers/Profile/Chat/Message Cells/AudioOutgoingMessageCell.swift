import UIKit
import AVFoundation

class AudioOutgoingMessageCell: UITableViewCell, AudioManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Properties
    
    var isPlaying: Bool = false
    var totalDuration: TimeInterval = 0
    var audioURL: URL?
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        progressBar.isHidden = false
        
        if let audioURL = audioURL {
            if isPlaying {
                // Pause the audio playback
                AudioManager.shared.pauseAudio()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                
                // Store the current playback position
                if let audioPlayer = AudioManager.shared.audioPlayer {
                    AudioManager.shared.currentPlaybackPosition = audioPlayer.currentTime
                }
                
                isPlaying = false
            } else {
                AudioManager.shared.getAudioDuration(at: audioURL) { [weak self] (totalDuration) in
                    guard totalDuration != nil else {
                        // Handle error
                        return
                    }
                    
                    if self?.isPlaying == false {
                        // Resume playback from the current position
                        AudioManager.shared.playAudio(at: audioURL, resumePlayback: true,
                                                      updateProgress: { [weak self] (progress) in
                                                          // Update progress bar here
                                                          self?.progressBar.value = Float(progress)
                                                      },
                                                      updateTimeLabel: { [weak self] (timeString) in
                                                          // Update time label here
                                                          self?.timeLabel.text = timeString
                                                      })
                        self?.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                        self?.isPlaying = true
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    // Helper method to format time in seconds as mm:ss
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Configuration
    
    func configure(audioURL: URL, userImageUrl: String) {
        backgroundColor = .clear
        backgroundMessage.backgroundColor = .foodieLightGreen
        backgroundMessage.layer.cornerRadius = 15.0
        backgroundMessage.layer.masksToBounds = true
        progressBar.value = 0
        progressBar.isHidden = true
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
    
    // MARK: - AudioManagerDelegate
    
    func playbackFinished() {
        // Update UI for playback finished state
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying = false
        progressBar.isHidden = true
        AudioManager.shared.currentPlaybackPosition = 0
    }
}
