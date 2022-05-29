//
//  SwiftUIView.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 29/05/22.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    @Binding var bgColor : Color
    var body: some View {
        VStack{
            Text("Listado de usuarios desde Api.")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top)
            List(viewModel.usersData){ user in
                UsersCell(id: user.id,
                          name: user.name,
                          email: user.email)
            }
        }.background(bgColor)
        .onAppear{
            // Obteniendo informacion del API
            viewModel.getUsersData()
        }
    }
}

struct UsersCell : View {
    var id : Int
    var name : String
    var email : String
    
    var body: some View {
        VStack(alignment:.leading){
            Text("ID: \(id)")
            Text("Nombre: \(name)")
            Text("Email: \(email)")
        }.font(.caption2)
        
    }
}
