import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    
    override init() {
        super.init()
        setupAudioSession()
        requestMicrophonePermission()
    }
    
    func startRecording() {
        guard let url = createAudioFileURL() else {
            return
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("Error starting audio recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func getAudioFileURL() -> URL? {
        return audioFileURL
    }

    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

    private func createAudioFileURL() -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let audioFileName = "audio_message.wav"
        let audioFileURL = documentsDirectory?.appendingPathComponent(audioFileName)
        self.audioFileURL = audioFileURL
        return audioFileURL
    }
    
    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if !granted {
                // Handle the case where microphone permission is not granted
                print("Microphone permission not granted.")
            }
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Audio recording finished successfully
        } else {
            // Handle the failure
        }
    }
}
