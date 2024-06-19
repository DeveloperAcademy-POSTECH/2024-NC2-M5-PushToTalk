//
//  AudioSession.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/19/24.
//

import AVFoundation

func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        DispatchQueue.main.async {
            completion(granted)
        }
    }
}


    
    func startRecording() {
//        audioRecorder?.record()
        //이거랑 stopRecording 해결해야함
    }

    func stopRecording() {
//        audioRecorder?.stop()
    }






func deactivateAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    
    do {
        try audioSession.setActive(false)
    } catch {
        print("Failed to deactivate audio session: \(error)")
    }
}

