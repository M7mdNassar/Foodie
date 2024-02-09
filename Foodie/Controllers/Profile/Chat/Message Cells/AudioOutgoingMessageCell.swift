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
        
        guard let audioURL = audioURL else { return }
        
        if isPlaying {
            pauseAudio()
        } else {
            playAudio(at: audioURL)
        }
    }
    
    // MARK: - Helper Methods
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Configuration
    
    func configure(audioURL: URL, userImageUrl: String) {
        backgroundColor = .clear
        configureBackground()
        configureProgressBar()
        self.audioURL = audioURL
        configureAudioManager()
        self.userImageView.sd_setImage(with: URL(string: userImageUrl))
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
        configureAudioDuration()
    }
    
    // MARK: - AudioManagerDelegate
    
    func playbackFinished() {
        // Update UI for playback finished state
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying = false
        progressBar.isHidden = true
        AudioManager.shared.currentPlaybackPosition = 0
    }
    
    // MARK: - Private Methods
    
    private func pauseAudio() {
        AudioManager.shared.pauseAudio()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        if let audioPlayer = AudioManager.shared.audioPlayer {
            AudioManager.shared.currentPlaybackPosition = audioPlayer.currentTime
        }
        isPlaying = false
    }
    
    private func playAudio(at audioURL: URL) {
        AudioManager.shared.getAudioDuration(at: audioURL) { [weak self] _ in
            guard self?.isPlaying == false else {
                return
            }
            
            AudioManager.shared.playAudio(at: audioURL, resumePlayback: true,
                                          updateProgress: { [weak self] progress in
                                              self?.progressBar.value = Float(progress)
                                          },
                                          updateTimeLabel: { [weak self] timeString in
                                              self?.timeLabel.text = timeString
                                          })
            self?.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self?.isPlaying = true
        }
    }

    
    private func configureBackground() {
        backgroundMessage.backgroundColor = .foodieLightGreen
        backgroundMessage.layer.cornerRadius = 15.0
        backgroundMessage.layer.masksToBounds = true
    }
    
    private func configureProgressBar() {
        progressBar.value = 0
        progressBar.isHidden = true
    }
    
    private func configureAudioManager() {
        AudioManager.shared.delegate = self
    }
    
    private func configureAudioDuration() {
        guard let audioURL = audioURL else { return }
        
        AudioManager.shared.getAudioDuration(at: audioURL) { [weak self] totalDuration in
            guard let totalDuration = totalDuration else { return }
            let totalDurationString = self?.formatTime(seconds: Int(totalDuration))
            self?.timeLabel.text = totalDurationString
        }
    }
}
