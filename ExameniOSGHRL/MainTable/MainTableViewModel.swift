//
//  MainTableViewModel.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 27/05/22.
//

import Foundation
import FirebaseStorage

final class MainTableViewModel : ObservableObject {
    let acceptableChars: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    
    func soloCaracteresAlfabeticos(text:String) -> String{
        if let lastChar = text.last {
            if !CharacterSet(
                charactersIn: acceptableChars)
                .isSuperset(of:CharacterSet(charactersIn: String(lastChar))) {
                return text.replacingOccurrences(of: String(lastChar) , with: "")
            }
        }
        return text
    }
    
    func uploadFile(fileUrlString: String,fileName name:String, completion: @escaping (Bool) -> ()) {
        guard let fileUrl = URL(string: fileUrlString) else {
            print("PROBLEMA AL FORMAR EL URL CON: \(fileUrlString)")
            return
        }
        
        let fileExtension = fileUrl.pathExtension
        let fileName = "\(name).\(fileExtension)"
        
        let storageReference = Storage.storage().reference().child(fileName)
        storageReference.putFile(from: fileUrl, metadata: nil) { (storageMetaData, error) in
            if let error = error {
                print("Error al carga la imagen.: \(error.localizedDescription)")
                return
            }
            
            print("Image file: \(fileName)")
            print("Archivo cargado correctamente...")
            
            storageReference.downloadURL { (url, error) in
                if let error = error  {
                    print("Error al obtener el URL para descargar: \(error.localizedDescription)")
                    return
                }
                print("url de descarga del archivo: \(fileName) es: \(url!.absoluteString)")
                completion(true)
            }
            
        }
    }
}
