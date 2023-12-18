import AVFoundation

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // MARK: - Properties

    static let shared = AudioManager()
    var currentRecordingURL: URL?
    private var updateProgressTimer: Timer?
    private var updateTimeLabelTimer: Timer?

    private var totalDuration: TimeInterval = 0

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?

    // MARK: - Recording

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            audioSession.requestRecordPermission { (granted) in
                if granted {
                    // Permission granted, proceed with recording
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    self.currentRecordingURL = documentDirectory.appendingPathComponent("audioRecording.m4a")

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
                    // Permission denied, handle accordingly
                    print("Microphone permission denied.")
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

    func playAudio(at url: URL, updateProgress: @escaping (Double) -> Void, updateTimeLabel: @escaping (String) -> Void) {
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: url)
               audioPlayer?.delegate = self
               audioPlayer?.prepareToPlay()

               // Store the total duration
               totalDuration = audioPlayer?.duration ?? 0

               audioPlayer?.play()

               // Schedule a timer to update the progress and time label every 0.1 seconds
               updateTimeLabelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
                   guard let strongSelf = self, let player = strongSelf.audioPlayer else { return }
                   let progress = player.currentTime / strongSelf.totalDuration
                   updateProgress(progress)

                   // Calculate the remaining time dynamically
                   let remainingTime = strongSelf.totalDuration - player.currentTime
                   let remainingTimeString = strongSelf.formatTime(seconds: Int(remainingTime))
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
         } else {
             print("Playing failed")
         }
         updateProgressTimer?.invalidate()
     }}
