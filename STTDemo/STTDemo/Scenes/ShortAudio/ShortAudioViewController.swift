//
//  ShortAudioViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import AVFoundation

final class ShortAudioViewController: UIViewController {
    @IBOutlet private weak var shortAudioTableView: UITableView!
    @IBOutlet private weak var recordButton: UIButton!
    
    private var viewModel: ShortAudioViewModel!
    private var audioURL: URL!
    
    private var isAllowedToRecord: Bool!
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupAudioRecorder()
    }
    
    private func config() {
        navigationItem.title = "Short Audio"
        viewModel = ShortAudioViewModel()
        shortAudioTableView.delegate = viewModel
        shortAudioTableView.dataSource = viewModel
        
        shortAudioTableView.rowHeight = UITableView.automaticDimension
        shortAudioTableView.estimatedRowHeight = 64
        shortAudioTableView.tableFooterView = UIView(frame: .zero)
        shortAudioTableView.register(UINib(nibName: "ShortAudioCell", bundle: nil), forCellReuseIdentifier: "ShortAudioCell")
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            self.shortAudioTableView.reloadData()
        }
    }
    
    private func setupAudioRecorder() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAllowedToRecord = true
                    } else {
                        // failed to record!
                        self.isAllowedToRecord = false
                    }
                }
            }
        } catch {
            // failed to record!
            self.isAllowedToRecord = false
        }
    }
    
    @IBAction func handleStartRecordingButton(_ sender: Any) {
        guard isAllowedToRecord else {
            print("This app doesn't have authority to record")
            return
        }
        
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let settings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 16000.0] as [String: Any]
        
        do {
            audioURL = getFileURL()
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy HH-mm-ss"
        
        let date = dateFormatterGet.string(from: Date.currentTimeInMiliseconds().dateFromMilliseconds())
        let filename = "Recording - " + date + ".wav"
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        return path as URL
    }
    
    
}

extension ShortAudioViewController: AVAudioRecorderDelegate {
    func finishRecording(success: Bool) {
        guard audioRecorder != nil else { return }
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            viewModel.transcribeData(audioURL)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            print("Recording failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension ShortAudioViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
