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
    @State var imageURL : String = ""
    @State var bgColor : Color = Color.white
    @State var showAlert : Bool = false
    @State var alertMessage : String = ""
    @State var isLoading : Bool = false
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
                                    bgColor: $bgColor,
                                    showAlert: $showAlert,
                                    alertMessage: $alertMessage)
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
            if !isLoading {
                Button {
                    if name != "" && imageURL != ""{
                        isLoading = true
                        //Cargando Imagen a Storages de Firebase
                        viewModel.uploadFile(fileUrlString: imageURL,
                                             fileName: "\(name)") { resultado in
                            isLoading = false
                            if resultado {
                                alertMessage = "Archivo cargado exitosamente."
                                showAlert = true
                            }else {
                                alertMessage = "Error al cargar el archivo."
                                showAlert = true
                            }
                        }
                    }else{
                        alertMessage = "Por favor complete el nombre y tome una foto."
                        showAlert = true
                    }
                } label: {
                    Text("Enviar Imagen")
                        .foregroundColor(Color.white)
                }.padding()
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.top)
            }else {
                Text("Cargando Imagen...")
                    .fontWeight(.bold)
                ProgressView()
            }
        }.padding()
            .background(bgColor)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("\(alertMessage)")
                )}
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
