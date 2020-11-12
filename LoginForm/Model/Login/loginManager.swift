//
//  loginManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 28.10.2020.
//

import Foundation


protocol LoginManagerDelegate {
    func didUpdateLogin(_ Login: LoginManager, login: LoginModel)

}

struct LoginManager {

    var delegate: LoginManagerDelegate?

    func performLogin (loginRegLet: String, passRegLet: String){

    let url = URL(string: "http://95.165.3.188:8082/ords/interval/login_user/login/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER_LOGIN\": \"\(loginRegLet)\", \"USER_PASS\": \"\(passRegLet)\"}".data(using: .utf8)!;

//        print(postString)
    // Set HTTP Request Body
    request.httpBody = postString;
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        if let safeData = data {
            if let login = self.parseJSON(safeData) {
                self.delegate?.didUpdateLogin(self, login: login)
            }
        }

    }
    task.resume()
    }

    func parseJSON(_ responceData: Data) -> LoginModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(LoginData.self, from: responceData)
    //                print(decoderData.statusUser)
            let loginV = decoderData.login
            let firstNameV = decoderData.firstName
            let statusV = decoderData.status
            let groupV = decoderData.group
            let statusReg  = LoginModel(login: loginV, firstName: firstNameV, group: groupV, status: statusV)
//            print(statusReg.statusUser)
            return statusReg

        } catch {
            let statusReg  = LoginModel(login: "null", firstName: "null", group: 0, status: 0)
            return statusReg
        }
    }


}