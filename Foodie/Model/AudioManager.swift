import AVFoundation

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    
    static let shared = AudioManager()
    weak var delegate: AudioManagerDelegate?
    
    var currentRecordingURL: URL?
    var currentPlaybackPosition: TimeInterval = 0
    private var totalDuration: TimeInterval = 0
    
    private var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    private var updateProgressTimer: Timer?
    private var updateTimeLabelTimer: Timer?
    
    // MARK: - Recording
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            if audioSession.recordPermission == .granted {
                // Permission granted, proceed with recording
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

                // Generate a unique file name using a timestamp
                let timestamp = Date().description
                let fileName = "\(String(describing: timestamp)).m4a"
                self.currentRecordingURL = documentDirectory.appendingPathComponent(fileName)

                let settings: [String: Any] = [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                    AVEncoderBitRateKey: 320000,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0
                ]

                self.audioRecorder = try? AVAudioRecorder(url: self.currentRecordingURL!, settings: settings)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.record()

            } else {
                // Permission not granted, request permission again
                audioSession.requestRecordPermission { [weak self] (granted) in
                    guard let self = self else { return }

                    if granted {
                        // Permission granted after re-requesting, proceed with recording
                        self.startRecording()
                    } else {
                        // Permission still denied, handle accordingly
                        print("Microphone permission denied.")
                        // You may want to inform the user and handle the situation appropriately
                    }
                }
            }
        } catch {
            print("Error starting audio recording: \(error.localizedDescription)")
        }
    }

    
    // MARK: - Playback
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func playAudio(at url: URL, resumePlayback: Bool = false, updateProgress: @escaping (Double) -> Void, updateTimeLabel: @escaping (String) -> Void) {
        stopAudio()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            // Store the total duration
            totalDuration = audioPlayer?.duration ?? 0
            
            if resumePlayback {
                audioPlayer?.currentTime = currentPlaybackPosition
            }
            
            audioPlayer?.play()
            
            // Schedule a timer to update the progress and time label every 0.1 seconds
            updateTimeLabelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
                guard let self = self, let player = self.audioPlayer else { return }
                let progress = player.currentTime / self.totalDuration
                updateProgress(progress)
                
                // Calculate the remaining time dynamically
                let remainingTime = self.totalDuration - player.currentTime
                let remainingTimeString = self.formatTime(seconds: Int(remainingTime))
                updateTimeLabel(remainingTimeString)
            })
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func getAudioDuration(at url: URL, completion: @escaping (TimeInterval?) -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            // Obtain the total duration
            let totalDuration = audioPlayer?.duration
            completion(totalDuration)
        } catch {
            print("Error getting audio duration: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        updateTimeLabelTimer?.invalidate()
        audioPlayer = nil
    }
    
    func cancelRecording() {
        stopRecording()
        // Clean up the recording file if it exists
        if let url = currentRecordingURL, FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error removing recording file: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    // Helper method to format time in seconds as mm:ss
      private func formatTime(seconds: Int) -> String {
          let minutes = seconds / 60
          let seconds = seconds % 60
          return String(format: "%02d:%02d", minutes, seconds)
      }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording successful")
            
        } else {
            print("Recording failed")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Playing successful")
            delegate?.playbackFinished()
        } else {
            print("Playing failed")
        }
        updateProgressTimer?.invalidate()
    }
}

protocol AudioManagerDelegate: AnyObject {
    func playbackFinished()
}


// Helper function to check microphone permissions
 func hasMicrophonePermission() -> Bool {
    let audioSession = AVAudioSession.sharedInstance()
    return audioSession.recordPermission == .granted
}
