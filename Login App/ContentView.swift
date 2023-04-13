//
//  ContentView.swift
//  Login App
//
//  Created by Kavsoft on 13/06/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: storyboardview()) {
                Home()
            }
        }
    }
    
}

func register(username :String,email:String, password:String,genre : String, classe : String,filiere:String,dateN:String){
    
    
    guard let url = URL(string: "http://172.17.1.152:9090/register") else{
        return
    }
    
    var request = URLRequest(url: url)
    //method , body , headers
    request.httpMethod="POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body : [String: AnyHashable] = [
        "Username":username,
        "Password":password,
        "Email":email,
        "Genre":genre,
        "Date_Naissance":dateN,
        "Classe":classe,
        "Filiere":filiere
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
    
    //Make the request
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            print(response.email)
        }
        catch{
            print(error)
        }
        
        
    }
    
    task.resume()
    
}



    
func login(email: String,pass: String) -> String{
    @State var verif = "0"
    print("fonction login start")
    print(email)
    print(pass)
    guard let url = URL(string: "http://172.17.1.152:9090/login") else{
        return verif
    }
    
    var request = URLRequest(url: url)
    //method , body , headers
    request.httpMethod="POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body : [String: AnyHashable] = [
        "Username":email,
        "Password":pass
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
    
    //Make the request
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            print(response.email)
            //shared preferences + navigation
            if(!response._id.isEmpty){
                print("211")
                let userDefaults = UserDefaults.standard
                userDefaults.set(response._id, forKey: "id")
                
                //navigation to home screen
                verif = "1"
                   
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    task.resume()
    
    return verif
}



    struct storyboardview: UIViewControllerRepresentable{
        func makeUIViewController(context: UIViewControllerRepresentableContext<storyboardview>) ->
        UIViewController {
            let storyboard = UIStoryboard( name:"Storyboard",bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Home")
            return controller
            
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<storyboardview>) {
            
        }
    }
    
   

    
    struct Response: Codable{
        let ActivationCode: String
        let Banne: Bool
        let Classe: String
        let Date_Naissance: String
        let Filiere: String
        let Genre: String
        let IsActive: Bool
        let __v: Int
        let _id: String
        let email: String
        let image: String
        let password: String
        let role: String
        let status: String
        let username: String
    }
    
    
    // func viewDidLoad(){
    //    viewDidLoad()
    // }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct Home : View {
        
        @State var index = 0
        
        
        var body: some View{
            
            
            GeometryReader{_ in
                
                VStack{
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    ZStack{
                        
                        SignUP(index: self.$index)
                        // changing view order...
                            .zIndex(Double(self.index))
                        
                        Login(index: self.$index)
                        
                    }
                    
                    HStack(spacing: 5){
                        
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                        
                        Text("OR")
                        
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    // because login button is moved 25 in y axis and 25 padding = 50
                    
                    HStack(spacing: 25){
                        
                        Button(action: {
                            
                        }) {
                            
                            Image("apple")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            
                        }) {
                            
                            Image("fb")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            
                        }) {
                            
                            Image("google")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 30)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(5).edgesIgnoringSafeArea(.all))
        }
    }

    // Curve...
    
    struct CShape : Shape {
        
        func path(in rect: CGRect) -> Path {
            
            return Path{path in
                
                // right side curve...
                
                path.move(to: CGPoint(x: rect.width, y: 100))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            }
        }
    }
    
    
    struct CShape1 : Shape {
        
        func path(in rect: CGRect) -> Path {
            
            return Path{path in
                
                // left side curve...
                
                path.move(to: CGPoint(x: 0, y: 100))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: 0))
                
            }
        }
    }
    
    
    struct Login : View {
        
        
        
        
        @State var email = ""
        @State var pass = ""
        @Binding var index : Int
        
        var body: some View{
            
            
            
            ZStack(alignment: .bottom) {
                
                VStack{
                    
                    HStack{
                        
                        VStack(spacing: 10){
                            
                            Text("Login")
                                .foregroundColor(self.index == 0 ? .white : .gray)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Capsule()
                                .fill(self.index == 0 ? Color.blue : Color.clear)
                                .frame(width: 100, height: 5)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 30)// for top curve...
                    
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color("Color1"))
                            
                            TextField("Email Address", text: self.$email)
                        }
                        
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            Image(systemName: "eye.slash.fill")
                                .foregroundColor(Color("Color1"))
                            
                            SecureField("Password", text: self.$pass)
                        }
                        
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            
                        }) {
                            
                            Text("Forget Password?")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                }
                .padding()
                // bottom padding...
                .padding(.bottom, 65)
                .background(Color("Color2"))
                .clipShape(CShape())
                .contentShape(CShape())
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    
                    self.index = 0
                    
                }
                .cornerRadius(35)
                .padding(.horizontal,20)
                
                // Button...
                
                Button(action: {
                    print("go to login action")
                    if(email.isEmpty || pass.isEmpty){
                        print("Entrer vos donner email et password")
                    }else{
                        if(login(email: email,pass: pass) == "1"){
                            print("login return true")
                        }else{
                            print("login return false")
                        }
                    }
                    
                }) {
                    
                    Text("LOGIN")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                    // shadow...
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                // moving view down..
                .offset(y: 25)
                .opacity(self.index == 0 ? 1 : 0)
                
            }
        }
    }

    
    // SignUP Page..
    
    struct SignUP : View {
        
        @State var email = ""
        @State var username = ""
        @State var password = ""
        @State var repass = ""
        @State var filiere = ""
        @State var genre = ""
        @State var classe = ""
        @State var DateNai = Date()
        @Binding var index : Int
        @State private var selection = 0
        let options = ["SIM","TWIN","DS"]
        
        @State private var selectionClasse = 0
        let optionsClasse = ["1ere","2eme","3eme","4eme","5eme"]
        
        
        //image
        @State var shouldShowImagePicker = false
        @State var image:UIImage?
        
        var body: some View{
            
            ZStack(alignment: .bottom) {
                
                VStack{
                    
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 10){
                            
                            Text("SignUp")
                                .foregroundColor(self.index == 1 ? .white : .gray)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Capsule()
                                .fill(self.index == 1 ? Color.blue : Color.clear)
                                .frame(width: 100, height: 5)
                        }
                    }
                    .padding(.top, 30)
                    
                    
                    
                  //start Form
                    ScrollView{
                        
                        
                        //Image
                        HStack{
                         if let image = self.image {
                          Image(uiImage: image)
                              .resizable()
                              .scaledToFill()
                              .frame(width: 143,height: 143)
                              .cornerRadius(80)
                          }else{
                             Image(systemName: "person.fill")
                               .font(.system(size: 80))
                               .padding()
                              .foregroundColor(Color("Color1"))
                          }
                                            
                         }
                         .overlay(RoundedRectangle(cornerRadius: 80)
                             .stroke(Color("Color1"), lineWidth : 3)
                         )
                         .onTapGesture {
                             shouldShowImagePicker.toggle()
                         }
                         .sheet(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                             ImagePicker(image: $image)
                                // .ignoresSafeArea()
                         }
                        .frame(width: 145,height: 145,alignment: .center)
                        
                        
                        
                        //username
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                TextField("Enter your username", text: self.$username)
                                    
                                    
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
                        
                        //email
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                TextField("Email Address", text: self.$email)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
                        
                        //password
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                SecureField("Mot de passe", text: self.$password)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                SecureField("Confirmer votre mot de passe", text: self.$repass)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                SecureField("Genre", text: self.$genre)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        //filiere
                        VStack{
                            
                            HStack(spacing: 15) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                Picker("Select an option", selection: $selection) {
                                    ForEach(0..<options.count) { index in
                                        Text(options[index]).tag(index)
                                        
                                    }
                                }
                                Text("Selected option : \(options[selection])")
                                //filiere=options[selection]
                            }
                            
                            
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        
                   
                        
                        //calasse


                        VStack{
                            
                            HStack(spacing: 15) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                Picker("Select an Classe", selection: $selectionClasse) {
                                    ForEach(0..<optionsClasse.count) { index in
                                        Text(optionsClasse[index]).tag(index)
                                        
                                    }
                                }
                                Text("Selected option : \(optionsClasse[selectionClasse])")
                                //filiere=options[selection]
                            }
                            
                            
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        
                        //date de naissance
                        
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color("Color1"))
                                
                                DatePicker("Naissance" , selection: $DateNai, displayedComponents: .date)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        
                    }
                    
                    //end form
                    
                    
                }
                .padding()
                // bottom padding...
                .padding(.bottom, 65)
                .background(Color("Color2"))
                .clipShape(CShape1())
                // clipping the content shape also for tap gesture...
                .contentShape(CShape1())
                // shadow...
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    
                    self.index = 1
                    
                }
                .cornerRadius(35)
                .padding(.horizontal,20)
                
                // Button...
                VStack{
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat="dd-MM-yyyy"
                        register(username: username,email: email, password: password,genre: genre, classe: optionsClasse[selectionClasse],filiere: options[selection],dateN: dateFormatter.string(from: DateNai))
                        
                    }) {
                        
                        Text("SIGNUP")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(Color("Color1"))
                            .clipShape(Capsule())
                        // shadow...
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    
                }
                // moving view down..
                .offset(y: 25)
                // hiding view when its in background...
                // only button...
                .opacity(self.index == 1 ? 1 : 0)
            }
        }
        
    }


struct ImagePicker : UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    @Binding var image: UIImage?
    
    let ctr = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent : self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        
        let parent : ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ctr.delegate = context.coordinator
        return ctr
    }
}
    

