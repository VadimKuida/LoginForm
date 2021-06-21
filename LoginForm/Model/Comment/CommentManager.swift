//
//  CommentManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 23.03.2021.
//

import Foundation


protocol CommentManagerDelegate {

    func didUpdateComment(_ Content: CommentManager, content: UpdateComment)
    func didShowComment(_ Content: CommentManager, content: ShowComment)
    func didUpdateFeedback(_ Content: CommentManager, content: UpdateComment)

}

struct CommentManager {
    
    
    var delegate: CommentManagerDelegate?
    

    //MARK: UPDATE COMMETN
    func performUpdateComment (activeID: Int, comment: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/comment_update/comment/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"ACTID\": \(activeID), \"COMM\": \"\(comment)\"}".data(using: .utf8)!;

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
                if let login = self.parseJSONUpdateComment(safeData) {
                    self.delegate?.didUpdateComment(self, content: login)
                }
            }

        }
        task.resume()
        }

        func parseJSONUpdateComment(_ responceData: Data) -> UpdateComment?  {
            let decoder = JSONDecoder()
            do{
                let decoderData = try decoder.decode(UpdateComment.self, from: responceData)
                let statusAdd = decoderData.success
    //            print(statusAdd)
                let statusReg  = UpdateComment(success: statusAdd)
    //            print(statusReg.statusUser)
                return statusReg
            } catch {

                return nil
            }
        }

    
    


    //MARK: show comment
    func performShowComment (activeID: Int){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/comment_show/comment/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"ACTID\": \(activeID)}".data(using: .utf8)!;


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
                self.delegate?.didShowComment(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONShowComment(_ responceData: Data) -> ShowComment?  {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ShowComment.self, from: responceData)
            let comment = decoderData.comm
            
            let statusReg  = ShowComment(comm: comment)
                print(statusReg)
            return statusReg
        } catch {

            return nil
        }
    }
    
    
    
    
    
    //MARK: UPDATE FEEDBACK
    func performUpdateFeedback (activeID: Int, val: Int, type: Int ){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/add_feedback_active/activeid/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"ACTID\": \(activeID), \"VAL\": \(val), \"TYPE\": \(type)}".data(using: .utf8)!;

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
                if let login = self.parseJSONUpdateComment(safeData) {
                    self.delegate?.didUpdateFeedback(self, content: login)
                }
            }

        }
        task.resume()
        }

    

}
