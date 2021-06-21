//
//  ActiveUserManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 18.03.2021.
//

import Foundation


protocol ActiveUserManagerDelegate {

    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser)
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser)
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate)
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin])
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser])

}

struct ActiveUserManager {
    
    var delegate: ActiveUserManagerDelegate?


        //MARK: ADD TOPIC
        func performActiveUser (loginLet: String, action: Int){

        let url = URL(string: "https://shi-ku.ru:8443/ords/interval/active_user/user/")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString : Data = " { \"USER\": \"\(loginLet)\", \"ACTION\": \(action)}".data(using: .utf8)!;
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
                if let login = self.parseJSONActiveUser(safeData) {
                    self.delegate?.didActiveUser(self, content: login)
                }
            }

        }
        task.resume()
        }

        func parseJSONActiveUser(_ responceData: Data) -> ActiveUser? {
            let decoder = JSONDecoder()
            do{
                let decoderData = try decoder.decode(ActiveUser.self, from: responceData)
        //                print(decoderData.statusUser)
                let statusAdd = decoderData.seanceID
        //            print(statusAdd)
                let statusReg  = ActiveUser(seanceID: statusAdd)
        //            print(statusReg.statusUser)
                return statusReg

            } catch {
        //            let statusReg  = AddTopicModel(statusAddTopic: nil)
                return nil
            }
}
    
    //MARK: ADD TOPIC
    func performActiveUserSeance (loginLet: String, action: Int){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/active_user_seance/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\", \"ACTION\": \(action)}".data(using: .utf8)!;
        print(" { \"USER\": \"\(loginLet)\", \"ACTION\": \(action)}")
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
            if let login = self.parseJSONActiveUserSeance(safeData) {
                self.delegate?.didActiveUserSeance(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONActiveUserSeance(_ responceData: Data) -> ActiveUser? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ActiveUser.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.seanceID
    //            print(statusAdd)
            let statusReg  = ActiveUser(seanceID: statusAdd)
    //            print(statusReg.statusUser)
            return statusReg

        } catch {
    //            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
}
    
    
    
    //MARK: Update Group
    func performUpdateGroup (loginLet: String, group: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/group_update/update/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\", \"GROUP\": \"\(group)\"}".data(using: .utf8)!;
        print(" { \"USER\": \"\(loginLet)\", \"GROUP\": \"\(group)\"}")
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
            if let login = self.parseJSONUpdateGroup(safeData) {
                self.delegate?.didUpdateGroup(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONUpdateGroup(_ responceData: Data) -> GroupUpdate? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(GroupUpdate.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.success
            let nameAdd = decoderData.name
            let id = decoderData.id
    //            print(statusAdd)
            let statusReg  = GroupUpdate(success: statusAdd, name: nameAdd, id: id)
                print(statusReg)
            return statusReg

        } catch {
    //            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
}
    
    
    
        
    //MARK: Show List Group
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
                let list = decoderData.group
                return list
            } catch {
                print(error)
                return nil
            }
        }
        
 
    //MARK: Show List User
        func performShowUser (idGroup: Int){

        let url = URL(string: "https://shi-ku.ru:8443/ords/interval/list_user/user/")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString : Data = " { \"GROUP\": \(idGroup)}".data(using: .utf8)!;
//            print(" { \"GROUP\": \"\(idGroup)\"}")


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
                if let login = self.parseJSONShowUser(safeData) {
                    self.delegate?.didShowGroupUser(self, content: login)
                }
            }

        }
        task.resume()
        }

  
        func parseJSONShowUser(_ responceData: Data) -> [ListAdminUser]? {
            let decoder = JSONDecoder()
            do{
                let decoderData = try decoder.decode(ShowGroupAdminUser.self, from: responceData)
        //                print(decoderData.statusUser)
                let list = decoderData.user
    //            let statusReg  = ResponceModel(statusUser: flag)
//                print(list)
                return list

            } catch {
                print(error)
                return nil
            }
        }
    
    
}
