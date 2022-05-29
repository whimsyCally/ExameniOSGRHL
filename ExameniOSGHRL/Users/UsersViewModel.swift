//
//  UsersViewModel.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 29/05/22.
//

import Foundation

final class UsersViewModel : ObservableObject {
    @Published var usersData : UsersModel = []
    
    func getUsersData() {
        let strUrl = "https://jsonplaceholder.typicode.com/users"
        
        guard let url = URL(string: strUrl) else {
            print("problema con la url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error al obtener la informacion: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Error en la respuesta: \(response!)")
                      return
                  }
            
            if let data = data,
               let filmSummary = try? JSONDecoder().decode(UsersModel.self, from: data) {
                DispatchQueue.main.async {
                    self.usersData = filmSummary
                }
            }
        })
        task.resume()
    }
    
}
