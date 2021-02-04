//
//  tableDetailController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 04.02.2021.
//

import Foundation
import UIKit
import CoreData




class tableDetailController: UITableViewController {
    


    var TOPIC_NAME: String!
    var user: String!
    var group: Int!
    let resetCoredata: Bool = false
    let vw = UIView()
    var TOPIC_ID: Int!
    var detailManager = ContentDetailManager()
    var content: [Detail] = []
    var filteredData: [Detail] = []
    @IBOutlet weak var labelAlarm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TOPIC_NAME
        let leftBackButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.registerTableViewCells()
        detailManager.delegate = self
        detailManager.performShowDetail(loginLet: user, topicID: TOPIC_ID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        filteredData = content
       
        
    }
    
    
    func labelAlert(flag: Int) {
        if (flag == 0) {
            labelAlarm.isHidden = false
            labelAlarm.text = "Замеров еще нет"
        } 
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        vw.isHidden = true
        
        return vw
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }


    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableDetailCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableDetailCell")
    }
    
    let array = [1,2,3]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(filteredData.count)
        return filteredData.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = filteredData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableDetailCell", for: indexPath) as! CustomTableDetailCell
        cell.labelName.text = "Дата замера: \(message.DATE)"
        cell.labelStep.text = "Шагов: \(String(message.STEPFACT)) из \(message.STEPPLAN)"
        cell.labelTime.text = "Общее время: \(String(castTime(localTimeDelta: message.TIMEALL)))"

          
        cell.imageValid.image = colorValid(flag: message.FLAG)


        return cell
        
    }
    
    
    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "Хороший") { (_, _, completionHandler) in
            let message = self.filteredData[indexPath.row]
            self.detailManager.performValidAcctive(activeID: message.ID_ART, flag: 1)
            completionHandler(true)
            self.detailManager.performShowDetail(loginLet: self.user, topicID: self.TOPIC_ID)
//            sleep(1)
//            self.tableView.reloadData()
        }
        testAction.backgroundColor = .systemGreen
        testAction.image = UIImage(systemName: "checkmark.circle")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    

    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stopAction = UIContextualAction(style: .destructive, title: "Плохой") { (_, _, completionHandler) in
            let message = self.filteredData[indexPath.row]
            self.detailManager.performValidAcctive(activeID: message.ID_ART, flag: -1)
            completionHandler(true)
            self.detailManager.performShowDetail(loginLet: self.user, topicID: self.TOPIC_ID)
//            sleep(1)
//            self.tableView.reloadData()
            





        }
        stopAction.backgroundColor = .systemRed
        stopAction.image = UIImage(systemName: "xmark.circle")
        
        let editAction = UIContextualAction(style: .destructive, title: "edit") { (_, _, completionHandler) in

            
//            completionHandler(true)

//            let topic_id = self.content[indexPath.row].TOPIC_ID
//            let step_id = self.content[indexPath.row].id
//
//            self.typeAction(nameAction: "edit", topicID: topic_id, stepID: step_id )
            
            


        }
        editAction.backgroundColor = .blue
        editAction.image = UIImage(systemName: "edit")

        return UISwipeActionsConfiguration(actions: [stopAction/*,editAction*/])
    }
    
    func colorValid (flag: Int) -> UIImage {
        let imageIconVal = (UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal))!
        let imageIconFail = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let imageIcon = UIImage(systemName: "questionmark.circle")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
//        return imageIconVal
    
        switch flag {
        case -1:
            return imageIconFail!
        case 0:
            return imageIcon!
        case 1:
            return imageIconVal
        default:
            return imageIcon!
        }
    }
    
    

    
    func castTime (localTimeDelta: Int) -> String {
    let hours = Int(localTimeDelta) / 3600
    let minutes = Int(localTimeDelta) / 60 % 60
    let seconds = Int(localTimeDelta) % 60
    
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours):")
        }
        if minutes > 0 {
          times.append("\(minutes):")
        }
        times.append("\(seconds) с")
    
    return times.joined(separator: "")
    }
    
    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {

            newViewController.user = user
            newViewController.group = group
            newViewController.resetCoredata = resetCoredata
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)

           }

    }
    
}


extension tableDetailController: DetailManagerDelegate {
    func didValidActiv(_ Content: ContentDetailManager, content: ValidAct) {
//        self.tableView.reloadData()
       
    }
    
    func didShowDetail(_ Content: ContentDetailManager, content: [Detail]) {
        self.content = content
        self.filteredData = content
        DispatchQueue.main.async {
                self.tableView.reloadData()
            self.labelAlert(flag: content.count)
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
    
}