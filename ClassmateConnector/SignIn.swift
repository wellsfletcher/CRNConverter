//
//  SignIn.swift
//  ClassmateConnector
//
//  Created by Fletcher Wells on 2/22/22.
//

import SwiftUI

struct SignIn: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            
            Text("Password")
            SecureField("Password", text: $password)
            
            SecureField("Confirm Password", text: $confirmPassword)
            
            Button(action: {
                signIn()
            }, label: {
                Text("Sign In")
            })
        }
    }
    
    func signIn() {
        
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
