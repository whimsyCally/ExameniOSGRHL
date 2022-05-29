//
//  RealTimeDatabase.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 28/05/22.
//

import Foundation
import SwiftUI
import FirebaseDatabase

class RealTimeDatabase : ObservableObject {
    @Published var color : Color = Color(hex: "FFFFFF")
    func getBgColor(completion:@escaping (Color)->()){
        var databaseReference: DatabaseReference!
            databaseReference = Database.database().reference()
        
        databaseReference.observe(.childChanged, with: { (snapshot) -> Void in
            print("\(snapshot)")
            for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let dict = snap.value as! String
                        print("COLOR:\(dict)")
                completion( Color(hex: dict))
                    }
        })
        
    }
}
