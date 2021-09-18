//
//  SignUpView.swift
//  iOSSkillsTest
//
//  Created by Milos Otasevic on 18.9.21..
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel = SignupViewModel()

    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(footer:
                                Text(viewModel.usernameAvailable ? "" : "Not available")){
                            TextField("Username", text: $viewModel.username)
                        }
                        
                        Section{
                            SecureField("Password", text: $viewModel.password)
                            SecureField("Repeat password", text: $viewModel.repeatPassword)
                        }
                    }
                
                Button(action: {  }, label: {
                    Text("Sign Up")
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding()
                .opacity(viewModel.formIsValid  ? 1 : 0.6)
                .disabled(!viewModel.formIsValid)
            }
            .navigationTitle("Sign Up")
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
