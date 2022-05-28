//
//  SwiftUIView.swift
//  ExameniOSGHRL
//
//  Created by Gustavo Rodriguez on 27/05/22.
//

import SwiftUI
import FirebaseDatabase

enum CellTypes : Int {
    case nameCell = 0
    case pictureCell
    case chartCell
}

// MARK: - Welcome
struct DataSettings: Codable {
    var settings: Settings
}

// MARK: - Settings
struct Settings: Codable {
    var backgroundColor: String
}


class connectFb : ObservableObject {
    @Published var color : Color = Color(hex: "FFFFFF")
    func getFbData(completion:@escaping (Color)->()){
        var databaseReference: DatabaseReference!
            databaseReference = Database.database().reference()
        
        databaseReference.observe(.childChanged, with: { (snapshot) -> Void in
            print("\(snapshot)")
            for child in snapshot.children { //even though there is only 1 child
                        let snap = child as! DataSnapshot
                        let dict = snap.value as! String
                        //let color = dict["backgroundColor"] as? String ?? ""
                        print("COLOR:\(dict)")
                //self.color = Color(hex: dict)
                completion( Color(hex: dict))
                    }
        })
        
    }
}

struct MainTable: View {
    @StateObject var viewModel = MainTableViewModel()
    @StateObject var bgColorManager = connectFb()
    @State var name : String = ""
    @State var imageURL : URL = URL(string: "https://www.apple.com")!
    @State var bgColor : Color = Color.white
    var body: some View {
        VStack{
            ScrollView(showsIndicators:false){
                ForEach(0..<3){ row in
                    switch CellTypes(rawValue: row) ?? CellTypes.nameCell {
                    case CellTypes.nameCell:
                        NameCell(name: $name)
                            .padding()
                    case CellTypes.pictureCell:
                        PictureCell(imageURL: $imageURL, bgColor: $bgColor)
                            .padding()
                    case CellTypes.chartCell:
                        ChartCell(bgColor: $bgColor)
                            .padding()
                    }
                   Divider()
                }
                
            

            }.onAppear{
                connectFb().getFbData { color in
                    print("CAMBIO!")
                    bgColor = color
                }
            }
            Button {
                print("subir imagen")
                if name != "" {
                    viewModel.uploadFile(fileUrl: imageURL, fileName: "\(name)")
                }else{
                    print("Por favor indique un nombre")
                }
                
            } label: {
                Text("Enviar Imagen")
                    .foregroundColor(Color.white)
            }.padding()
                .background(.black)
                .clipShape(Capsule())
                .padding(.top)
            
        }.padding()
            .background(bgColor)
    }
    

}

struct NameCell : View {
    @StateObject var viewModel = MainTableViewModel()
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
    @Binding var imageURL : URL
    @Binding var bgColor : Color
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
                    CaptureImageView(isShown: $showCaptureImageView, image: $image,imageURL: $imageURL)
                })
                Spacer()
            }.frame(maxWidth:.infinity)
            .frame(height: 70)
            .background(bgColor)
            .padding(.leading)
        .onTapGesture {
            cameraManager.requestPermission { access in
                if access {
                    print("permiso concedido")
                    showCaptureImageView = true
                }else{
                    print("necesitamos el permiso")
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
            Text("Descripción: Una gráfica o representación gráfica es un tipo de representación de datos, generalmente numéricos, mediante recursos visuales (líneas, vectores, superficies o símbolos), para que se manifieste visualmente la relación matemática o correlación estadística que guardan entre sí. También es el nombre de un conjunto de puntos que se plasman en coordenadas cartesianas y sirven para analizar el comportamiento de un proceso o un conjunto de elementos o signos que permiten la interpretación de un fenómeno. La representación gráfica permite establecer valores que no se han obtenido experimentalmente sino mediante la interpolación (lectura entre puntos) y la extrapolación (valores fuera del intervalo experimental).")
        }.frame(maxWidth:.infinity)
            .onTapGesture {
                showDetail = true
            }
            .sheet(isPresented: $showDetail) {
                ChartsDetailView(bgColor: $bgColor)
            }
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
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var imageURL : URL
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, image: $image,imageURL: $imageURL)
    }
}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
  @Binding var imageInCoordinator: Image?
  @Binding var imageURL : URL
  
    init(isShown: Binding<Bool>, image: Binding<Image?>,imageURL:Binding<URL>) {
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
      imageURL = imageURL2
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
  }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NameCell(name:.constant(""))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
