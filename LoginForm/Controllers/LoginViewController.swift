//
//  LoginViewController.swift
//  LoginForm
//
//  Created by 08395593 on 30.08.2021.
//

import SwiftUI

struct LoginViewController: View {
    

    

    
    var body: some View {
        VStack {
            let rTarget = Double.random(in: 0..<1)
            let gTarget = Double.random(in: 0..<1)
            let bTarget = Double.random(in: 0..<1)
            Text("Target Color Block").foregroundColor(.blue)
            Slider(value: rGuess)
            Text("Guess Color Block")
            Rectangle()
              .foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget, opacity: 1.0))

            
        }

    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewController()
    }
}
