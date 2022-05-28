//
//  Permissions.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 27/05/22.
//

import Foundation
import AVKit

class CameraManager : ObservableObject {
   // @Published var permissionGranted = false
    
    func requestPermission(completion:@escaping (Bool) ->()) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                //self.permissionGranted = accessGranted
                completion(accessGranted)
            }
        })
    }
}
