//
//  tableController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//

import Foundation
import UIKit
import CoreData


class tableController: UITableViewController, UISearchBarDelegate {
    var firstName: String!
    var user: String!
    var group: Int!
    var contentManager = ContentManager()
    var content: [Topic] = []
    var contentCore: [TopicStepCore] = []
    var itemTimeArray = [Logtimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contentActive: Int!
    var filteredData: [Topic]!
    var resetCoredata: Bool!
    var figuresByLetter = [(key: String, value: [Topic])]()
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //self.tableView.backgroundColor = addGradientBackground(UIColor.white, UIColor.black)
        
        self.navigationItem.title = "Активные замеры"

        let rightBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButtonAdd)
        )
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "arrow.backward.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        self.navigationItem.rightBarButtonItem = rightBackButton
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        labelHello.text =  "Привет \(String(firstName))!!!"
//        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.registerTableViewCells()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell" )
//        let itemExersiceArray = contentManager.performLogin
//        print(contentManager.performLogin)
        contentManager.delegate = self
        contentManager.performLogin(user: user)
        contentManager.performStep(loginLet: user)
        searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
       
        loadItems()
        filteredData = content


    }
    
    //MARK: CoreDATA
 
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func saveItems() {
        do {
        try context.save()
        print("Информация сохранена")
        } catch {
        print("Ошибка сохранения нового элемента замера\(error)")
        }
        //  self.tableView.reloadData()
    }
    
    func sumFactCell (topicI: Int) -> Int {
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.topicID == topicI && book.flagActive == 0 && book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    func sumFactCellUser () -> Int {
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    
    

    
    
//    func saveSpotsLocation() {
//      let newUser = NSEntityDescription.insertNewObject(forEntityName: "Model", into: context)
//      do {
//        let message1 = contentCore[1]
////        newUser.setValue(data, forKey: "data")
////        newUser.setValue(message1.USERNAME, forKey: "user")
////        newUser.setValue(Int16(message1.TOPICID), forKey: "topicID")
////        newUser.setValue(Int16(message1.STEPID), forKey: "stepID")
//        try context.save()
//      } catch {
//        print("failure")
//      }
//    }
    
    //MARK: Замеры
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }

//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.tableView.backgroundColor = UIColor.systemGreen
//               }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
       
        let message = figuresByLetter[indexPath.section].value[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.labelNme.text = message.TOPIC_NAME
        let count = String(message.COUNT_STEP)
        cell.labelComment.text = message.TOPIC_NAME
        cell.labelCount.text = "Шаги: \(String(sumFactCell(topicI: message.id))) из \(count)"

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return figuresByLetter.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return figuresByLetter[section].key
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return figuresByLetter[section].value.count
    }

    
    //MARK: Бар для поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        
        if let searchText = searchBar.text {
               filteredData = searchText.isEmpty ? content : content.filter{ term in
                return term.TOPIC_NAME.lowercased().contains(searchText.lowercased())
                }
            figuresByLetter = Dictionary(grouping: filteredData, by: { String($0.NAME_SECTOR) }).sorted(by: { $0.0 < $1.0 })
        }

        tableView.reloadData()
    }
    //MARK: Действие по нажатию
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        let message = figuresByLetter[indexPath.section].value[indexPath.row]
        print(message.id)
        
        print(message.TOPIC_NAME)

        func openCell(flagActive: Bool) {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableStep") as? tableStepController {


            newViewController.TOPIC_NAME = message.TOPIC_NAME
            newViewController.user = self.user
            newViewController.group = self.group
            newViewController.idTopic = message.id
            newViewController.activeFlag = flagActive
           
           

            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
           }
        }
        
        func upadteFlagAction () {
            self.itemTimeArray.forEach({ book in
                print(book.topicID)
                if (book.topicID == message.id && book.flagActive == 0 && book.user == user) {
                    book.flagActive = 1
                    saveItems()
                }
            })
        }
        

        if ((sumFactCell(topicI: message.id)) != 0) {
            let alertController = UIAlertController(title: "Создать новый замер?", message: "", preferredStyle: .alert)

                // Initialize Actions
            let yesAction = UIAlertAction(title: "Да", style: .default) { (action) -> Void in
                    print("The user is okay.")
                    openCell(flagActive: true)
                    upadteFlagAction ()
                

                }

            let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                    print("The user is not okay.")
                    openCell(flagActive: false)
                }

                // Add Actions
            
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
     

                // Present Alert Controller
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            openCell(flagActive: true)
        }

        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            contentManager.performDelTopic(loginLet: self.user, groupLet: self.group, nameTopic: content[indexPath.row].TOPIC_NAME)
//            content.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
////            print(content[indexPath.row].TOPIC_NAME)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
//
//    //Название кнопки удалить
//

    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "del") { (_, _, completionHandler) in
            self.contentManager.performDelTopic(loginLet: self.user, groupLet: self.group, nameTopic: self.filteredData[indexPath.row].TOPIC_NAME)
            self.content.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            completionHandler(true)
        }
        testAction.backgroundColor = .red
        testAction.image = UIImage(systemName: "trash")
        let testAction2 = UIContextualAction(style: .destructive, title: "Edit") { (_, _, completionHandler) in
            print("test")
            completionHandler(true)
        }
        testAction2.backgroundColor = .clear
        testAction2.image = UIImage(systemName: "pencil")
        return UISwipeActionsConfiguration(actions: [testAction2,testAction])
    }
    

    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        
        let alertController = UIAlertController(title: "Выход", message: "Вы хотите выйти?", preferredStyle: .actionSheet)

            // Initialize Actions
        let yesAction = UIAlertAction(title: "Выйти", style: .destructive) { (action) -> Void in
                print("The user is okay.")
            
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
                newViewController.modalTransitionStyle = .flipHorizontal // это значение можно менять для разных видов анимации появления
                newViewController.modalPresentationStyle = .overFullScreen
    //            newViewController.modalPresentationStyle = .currentContext
    //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
                self.present(newViewController, animated: true, completion: nil)

               }
            }

        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
        
            alertController.addAction(noAction)
            alertController.addAction(yesAction)

            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
        

    }
    
    //MARK: Кнопка Добавления
    @objc public func didTapMenuButtonAdd() {
                DispatchQueue.main.async {
        var textField = UITextField()
               
               let alert = UIAlertController (title: "Добавить действие", message: "", preferredStyle: .alert)
               let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
//                   print(textField.text)
                let nameTopic = textField.text
             
                self.contentManager.performAddTopic(loginLet: self.user, groupLet: self.group, nameTopic: nameTopic!)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
         
                   
//                   let newItem = Exercise(context: self.context)
//                   newItem.name = textField.text!
//                   newItem.perentGroupExercise = self.selectidGroup
//                    print("Добалвен элемент\(self.selectidGroup!)")
//                   self.itemExersiceArray.append(newItem)
//                   //save data
//                   self.saveItems()
//                  // self.saveItems()
                sleep(1)
                self.contentManager.performLogin(user: self.user)
                self.tableView.reloadData()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Добавить новое действие"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
                    self.tableView.reloadData()
                    self.present(alert, animated: true, completion: nil)
  


//
//            let indexPath = IndexPath(row: self.content.count - 1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//
        }

    }
    
}

extension tableController: ContentManagerDelegate {

    
    
    func didContentStepDataCore(_ Content: ContentManager, content: [TopicStepCore]) {
        self.contentCore = content
        func saveContentCore() {
            
            self.contentCore.forEach({ item in
                do {
                let newItem = Logtimer(context: self.context)
                newItem.user = item.USERNAME
                newItem.stepID = Int16(item.STEPID)!
                newItem.topicID = Int16(item.TOPICID)!
                newItem.flagActive = Int16(item.FLAGACTIVE)!
                    newItem.dateTimeStart = castDate(dateOld: item.DATETIMESTART)
                    newItem.dateTimeEnd = castDate(dateOld: item.DATETIMEEND)
                    newItem.typeAction = "Finish"
                    newItem.activeID = Int16(item.ACTIVEID)
//                    print(castDate(dateOld: item.DATETIMEEND))
                try context.save()
                } catch {
                    print("failure")
                  }
            })
        }
        
        func castDate(dateOld: String) -> Date {
            let isoDate = dateOld
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from:isoDate)!
            return date
        }
        
        func deleteAllData(entity: String)
        {
            let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
            do { try context.execute(DelAllReqVar) }
            catch { print(error) }
        }
        
//        self.content.remove(at: indexPath.row)
        
        if (resetCoredata == false ) {
//            saveContentCore()
//            loadItems()
        }else
        {
            deleteAllData(entity: "Logtimer")
            saveContentCore()
            loadItems()
        }
        
        DispatchQueue.main.async {
            self.contentManager.performLogin(user: self.user)
                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
    
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didContentData(_ Content: ContentManager, content: [Topic]) {
        self.content = content
        self.filteredData = content
        figuresByLetter = Dictionary(grouping: filteredData, by: { String($0.NAME_SECTOR) }).sorted(by: { $0.0 < $1.0 })
//        print(figuresByLetter)
        
        DispatchQueue.main.async {
                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
}


extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}



//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
             scanner.scanLocation = 1
            //scanner.currentIndex =  scanner.string.index(ofAccessibilityElement: 1)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
