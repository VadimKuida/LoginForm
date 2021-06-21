//
//  AdminManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 30.03.2021.
//

import Foundation


protocol AdminManagerDelegate {


    func didShowGroup(_ Content: AdminManager, content: [ListAdmin])
    

}

struct AdminManager {
    
    var delegate: AdminManagerDelegate?
    
    
    func performShowComment (loginLet: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/group_list_admin/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\"}".data(using: .utf8)!;


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
            if let login = self.parseJSONShowComment(safeData) {
                self.delegate?.didShowGroup(self, content: login)
            }
        }

    }
    task.resume()
    }


    
    
    
    func parseJSONShowComment(_ responceData: Data) -> [ListAdmin]? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ShowGroupAdmin.self, from: responceData)
    //                print(decoderData.statusUser)
            let list = decoderData.group
//            let statusReg  = ResponceModel(statusUser: flag)
            print(list)
            return list

        } catch {
            print(error)
            return nil
        }
    }
    
    
    
    
}
