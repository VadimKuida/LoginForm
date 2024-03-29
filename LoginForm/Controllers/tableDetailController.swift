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
    var indexRow = 0
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    //@IBOutlet weak var labelAlarm: UILabel!
    @IBOutlet var labelAlarm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TOPIC_NAME
//        let leftBackButton = UIBarButtonItem(
//            image: UIImage(systemName: "arrow.backward.circle.fill"),
//            style: .plain,
//            target: self,
//            action: #selector(didTapMenuButton))
//        self.navigationItem.leftBarButtonItem = leftBackButton
        self.registerTableViewCells()
        detailManager.delegate = self
        setLoadingScreen()
        detailManager.performShowDetail(loginLet: user, topicID: TOPIC_ID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        filteredData = content
       
        
    }
    
    

    
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        labelAlarm.isHidden = true
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont(name: K.fontRegular, size: 16)
        loadingLabel.text = "Загрузка..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        tableView.addSubview(loadingView)

    }
    
    


    


    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
    func labelAlert(flag: Int) {
        if (flag == 0) {
            labelAlarm.isHidden = false
            labelAlarm.font = UIFont(name: K.fontSemiBold, size: 18)
            labelAlarm.text = "Замеров еще нет!"
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (filteredData.count > 0) {
            self.removeLoadingScreen()
        }
        
        return filteredData.count
        
    }
//функция прописана в кажом файле. нужно перенести в отдельный файл и убрать тут
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        let color1 = UIColor(hexString: "#dfebfe")
        let color2 = UIColor(hexString: "#ffffff")
        layer.colors = [
                        //UIColor.white.cgColor,
            color1.cgColor,  //?? UIColor.white.cgColor,
            color2.cgColor  //?? UIColor.white.cgColor
                        ]
        
        return layer
    }
    
    func isColorRow (numTag: Int) -> UIColor {

        switch numTag {
        case -1:
            return UIColor(hexString: "#FDB64E")
        case 0:
            return UIColor(hexString: "#FDB64E")
        case 1:
            return UIColor(hexString: "#ADD57F")
        default:
            return UIColor(hexString: "#FDB64E")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = filteredData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableDetailCell", for: indexPath) as! CustomTableDetailCell
        
        cell.layer.masksToBounds = false
        cell.backgroundColor = .white
        
        
        cell.layer.borderColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.labelName.textColor = UIColor.init(red: 68.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1)
        cell.labelName.font = UIFont(name: K.fontRegular, size: 15)
//        cell.labelName.text = contentFix[indexPath.row].STEP_NAME
        cell.labelName.text = "Дата замера: \(message.DATE)"
        
        cell.labelStep.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelStep.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelStep.text = "Шагов в замере: \(String(message.STEPFACT)) из \(message.STEPPLAN)"
        
        cell.labelTime.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelTime.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelTime.text = "Общее время: \(String(castTime(localTimeDelta: message.TIMEALL)))"

          
        cell.imageValid.image = colorValid(flag: message.FLAG)
        
        //Радиус cell
//        cell.layer.masksToBounds = true
//        cell.layer.cornerRadius = 16
//        cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)

        return cell
        
    }
    
//    let imageIconVal = (UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal))!

    
    
    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "Хороший") { (_, _, completionHandler) in
            let message = self.filteredData[indexPath.row]
            
            completionHandler(true)
            self.indexRow = indexPath.row
            let imageIconVal = (UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal))!
            self.updateFlags(flag: imageIconVal)
            self.detailManager.performValidAcctive(activeID: message.ID_ART, flag: 1)
//            self.setLoadingScreen()
            
            
//            self.detailManager.performShowDetail(loginLet: self.user, topicID: self.TOPIC_ID)
//            sleep(1)
//            self.tableView.reloadData()
        }
        testAction.backgroundColor = .systemGreen
        testAction.image = UIImage(systemName: "checkmark.circle")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    
    //MARK: Действие на нажатие
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
         
         let message = content[indexPath.row]
        
        print(message.ID_ART)
        print(message.DATE)

//         let dataCount = countStepSum(value: message.id)
         
         
 //        cell.labelCountAct.font = UIFont(name: K.fontRegular, size: 10)

//         if dataCount == 0 {
//             self.showToast(message: "Комментарий недоступен", font: UIFont(name: K.fontRegular, size: 14)!)
//         }
//         else {
             let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentStepId") as! commentStep
             newViewController.typeView = "detail"
             newViewController.stepId = message.ID_ART
             newViewController.stepName = message.DATE
             newViewController.stepNum = "Время замера"
                     self.present(newViewController, animated: true, completion: nil)
             
//         }
         
         
         
         
     }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stopAction = UIContextualAction(style: .destructive, title: "Плохой") { (_, _, completionHandler) in
            let message = self.filteredData[indexPath.row]

            
                completionHandler(true)
                self.indexRow = indexPath.row
                let imageIconFail = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
                self.updateFlags(flag: imageIconFail!)
                self.detailManager.performValidAcctive(activeID: message.ID_ART, flag: -1)
                
//                self.detailManager.performShowDetail(loginLet: self.user, topicID: self.TOPIC_ID)
  
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
          times.append("\(hours)")
        }
        if hours < 1 {
          times.append("0")
        }
        if minutes > 9 {
          times.append("\(minutes)")
        }
        if minutes >= 1 && minutes < 10 {
          times.append("0\(minutes)")
        }
        if minutes <  1 {
          times.append("00")
        }
        if seconds > 9 {
            times.append("\(seconds)")
        }
        if  seconds >= 1  && seconds < 10 {
            times.append("0\(seconds)")
        }
        if seconds < 1 {
          times.append("00")
        }
    
    return times.joined(separator: ":")
    }
    
    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {

            newViewController.user = user
            newViewController.group = group
//            newViewController.resetCoredata = resetCoredata
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
           }
    }
    
}


extension tableDetailController: DetailManagerDelegate {
    func didValidActiv(_ Content: ContentDetailManager, content: ValidAct) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
            let imageIcon = UIImage(systemName: "questionmark.circle")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            self.updateFlags(flag: imageIcon!)
        }
    }
    
    func didShowDetail(_ Content: ContentDetailManager, content: [Detail]) {
        self.content = content
        self.filteredData = content
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
                self.labelAlert(flag: content.count)
                self.tableView.separatorStyle = .singleLine
                self.removeLoadingScreen()
                self.tableView.reloadData()
        }
    }
}


// MARK: - Timer
extension tableDetailController {
    @objc func updateFlags(flag: UIImage) {
          if let cell = tableView.cellForRow(at: IndexPath(row: indexRow, section: 0)) as? CustomTableDetailCell {
            cell.updateFlag(flag: flag)
          }
    }
}
