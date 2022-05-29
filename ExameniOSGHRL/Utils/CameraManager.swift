//
//  CameraManager.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 28/05/22.
//

import Foundation
import SwiftUI
import AVKit

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

struct CaptureImageView{
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var imageURL : String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image,imageURL: $imageURL)
    }
}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var imageURL : String
    
    init(isShown: Binding<Bool>, image: Binding<Image?>,imageURL:Binding<String>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _imageURL = imageURL
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorShown = false
        
        guard let imagen = info[.originalImage] as? UIImage else {
            print("Imagen no encontrada!")
            return
        }
        guard let imageURL2 = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Mifoto.png") else {
            return
        }
        let pngData = imagen.pngData();
        do {
            try pngData?.write(to: imageURL2);
        } catch { }
        imageURL = imageURL2.absoluteString
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
