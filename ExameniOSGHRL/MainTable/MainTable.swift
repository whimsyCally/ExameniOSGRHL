//
//  SwiftUIView.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 27/05/22.
//

import SwiftUI

struct MainTable: View {
    @StateObject var viewModel = MainTableViewModel()
    @StateObject var fbSettings = RealTimeDatabase()
    @State var name : String = ""
    @State var imageURL : URL = URL(string: "")!
    @State var bgColor : Color = Color.white
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators:false){
                //Mostrando diferentes tipos de celdas en la misma tabla
                ForEach(0..<3){ row in
                    switch CellTypes(rawValue: row) ?? CellTypes.nameCell {
                    case .nameCell:
                        NameCell(viewModel: viewModel,
                                 name: $name)
                            .padding()
                    case .pictureCell:
                        PictureCell(imageURL: $imageURL,
                                    bgColor: $bgColor)
                            .padding()
                    case .chartCell:
                        ChartCell(bgColor: $bgColor)
                            .padding()
                    }
                    Divider()
                }
            }.onAppear{
                //Escuchar cambios de color para el fondo desde Firebase
                fbSettings.getBgColor{ color in
                    bgColor = color
                }
            }
            Button {
                if name != "" {
                    //Cargando Imagen a Storages de Firebase
                    viewModel.uploadFile(fileUrl: imageURL,
                                         fileName: "\(name)")
                }else{
                    print("Por favor indique un nombre")
                }
                
            } label: {
                Text("Enviar Imagen")
                    .foregroundColor(Color.white)
            }.padding()
                .background(Color.black)
                .clipShape(Capsule())
                .padding(.top)
            
        }.padding()
            .background(bgColor)
    }
}

struct ChartsDetailView : View {
    @Binding var bgColor : Color
    var body: some View {
        ZStack{
            bgColor
            Text("Aqui se Mostrarian las graficas")
        }
    }
}
