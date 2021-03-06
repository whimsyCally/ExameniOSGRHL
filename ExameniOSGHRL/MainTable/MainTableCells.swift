//
//  MainTableCells.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 28/05/22.
//

import SwiftUI

enum CellTypes : Int {
    case nameCell = 0
    case pictureCell
    case chartCell
}

struct NameCell : View {
    @ObservedObject var viewModel : MainTableViewModel
    @Binding var name : String
    var body: some View {
        VStack(alignment:.leading, spacing:5){
            Text("Nombre:")
            TextField("Nombre", text: $name)
                .textFieldStyle(.roundedBorder)
                .background(Color.white)
                .onChange(of: name) { newVal in
                    name =  viewModel.soloCaracteresAlfabeticos(text: newVal)
                }
        }.frame(maxWidth:.infinity)
        
    }
}

struct PictureCell : View {
    @StateObject var cameraManager = CameraManager()
    @State private var showCaptureImageView = false
    @State var image: Image? = nil
    @Binding var imageURL : String
    @Binding var bgColor : Color
    @Binding var showAlert : Bool
    @Binding var alertMessage : String 
    var body: some View {
        HStack{
            if image == nil {
                Circle()
                    .background(Circle().foregroundColor(Color.gray))
                    .frame(width: 50, height: 50)
            }else {
                image?
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle()
                                .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 10)
            }
            Text("Toca para tomar foto")
                .fullScreenCover(isPresented: $showCaptureImageView, content: {
                    CaptureImageView(isShown: $showCaptureImageView,
                                     image: $image,
                                     imageURL: $imageURL)
                })
            Spacer()
        }
        .frame(maxWidth:.infinity)
        .frame(height: 70)
        .background(bgColor)
        .padding(.leading)
        .onTapGesture {
            cameraManager.requestPermission { access in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    if access {
                        print("permiso concedido")
                        showCaptureImageView = true
                    }else{
                        alertMessage = "Parece que no concediste el permiso, ve a la configuracion y aceptalo."
                        showAlert = true
                    }
                }else {
                    print("Parece que no hay camara disponible!")
                    alertMessage = "Parece que no hay camara disponible, intenta en un dispositivo fisico."
                    showAlert = true
                }
            }
        }
        
    }
}

struct ChartCell : View {
    @State var showDetail : Bool = false
    @Binding var bgColor : Color
    var body: some View {
        VStack{
            Text("Descripci??n: Una gr??fica o representaci??n gr??fica es un tipo de representaci??n de datos, generalmente num??ricos, mediante recursos visuales (l??neas, vectores, superficies o s??mbolos), para que se manifieste visualmente la relaci??n matem??tica o correlaci??n estad??stica que guardan entre s??. Tambi??n es el nombre de un conjunto de puntos que se plasman en coordenadas cartesianas y sirven para analizar el comportamiento de un proceso o un conjunto de elementos o signos que permiten la interpretaci??n de un fen??meno. La representaci??n gr??fica permite establecer valores que no se han obtenido experimentalmente sino mediante la interpolaci??n (lectura entre puntos) y la extrapolaci??n (valores fuera del intervalo experimental).")
        }.frame(maxWidth:.infinity)
            .onTapGesture {
                showDetail = true
            }
            .sheet(isPresented: $showDetail) {
                UsersView(bgColor: $bgColor)
            }
    }
}

