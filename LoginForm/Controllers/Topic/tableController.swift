//
//  tableController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//

import Foundation
import UIKit
import CoreData
import CoreLocation






class tableController: UITableViewController, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    var firstName: String!
    var user: String! = K.userLogin
    var userAction: String!
    var group: Int!
    var contentManager = ContentManager()
    var activeUserManager = ActiveUserManager()
    var content: [Sector] = []
    var contentCore: [TopicStepCore] = []
    var itemTimeArray = [Logtimer]()
    var itemLoginArray = [Login]()
    var userCore: String!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contentActive: Int!
    var filteredData: [Sector]!
    var topicVar: [Topic]!
    var resetCoredata: Bool!
    var numberOfRows: [IndexPath] = []
    var valueSearch: String = ""
    var idSeance: Int!
    let loadingView = UIView()
    let tabBar = UITabBar()
    let mainFunc = MainFunc()
    let navigation = UINavigationBar.appearance()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()

    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    let urlTabBar: String! = nil
    //Location
    
    var imageUser = UIImageView()
    var labelTextDesc =  UILabel()
    let buttonRefresh = UIButton()
    
    //TabBar
    let tabBarVC = UITabBarController()
    


    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadGroup()
    }
    
    
     func loadGroup () {

  
        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/4)-80, width: 160, height: 130)
        let url = URL(string:  "https://shi-ku.ru/img/not_topic.png")
        let data = try? Data(contentsOf: url!)
        imageUser.image = UIImage(data: data!)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 20, width: 300, height: 80)
        labelTextDesc.text = "Сейчас в группе '\(String(K.groupName))' нет активных замеров!"
        labelTextDesc.numberOfLines = 3
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont.preferredFont(forTextStyle: .body)
        
  
        buttonRefresh.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonRefresh.backgroundColor = UIColor(hexString: "#478ECC")
        buttonRefresh.setTitle("Обновить", for: .normal)
        buttonRefresh.layer.cornerRadius = 8
        buttonRefresh.layer.borderWidth = 0
        buttonRefresh.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
       
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        navigationItem.largeTitleDisplayMode = .never

    setLoadingScreen()
    self.view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
    title = "Замеры"
    let editMenu = self.makeEditMenu()
    let exit = UIAction(
        title: "Выход",
        identifier: nil, discoverabilityTitle: nil,
        attributes: .destructive, state: .off
        )  { action in
        self.didTapMenuButton()
    }
    let person = UIAction(title: "Профиль", image: UIImage(systemName: "person")) { action in
                self.didProfile()
            }
    let newMenu = UIMenu(title: "Меню", options: .displayInline, children: [person, editMenu, exit])
    self.navigationItem.title = "Замеры"
    let rightBackButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis.circle"),
        menu: newMenu
    )
        _ = UIBarButtonItem(
        title: "Выход",
        style: .plain,
        target: self,
        action: #selector(didTapMenuButton)
    )

    
    NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshStep), name: NSNotification.Name(rawValue: "newDataNotifStep"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAddTopic), name: NSNotification.Name(rawValue: "newDataNotifAddTopic"), object: nil)
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)


    self.navigationItem.rightBarButtonItem = rightBackButton

    self.navigationController?.navigationBar.prefersLargeTitles = true

    
    

    let navigationFont = UIFont(name: K.fontSemiBold, size: 16)
    let navigationLargeFont = UIFont(name: K.fontSemiBold, size: 34) //34 is Large Title size by default



        
    navigation.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationFont!]
    
    if #available(iOS 11, *){
        navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
    }

//        self.tableView.frame = view.frame
    self.registerTableViewCells()
    self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell" )
    contentManager.delegate = self
    activeUserManager.delegate = self
        contentManager.performLogin(user: K.userLogin)
    contentManager.performStep(loginLet: K.userLogin)
    filteredData = content
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.searchBar.text = valueSearch
    searchBar.delegate = self
//    self.tableView.reloadData()
    self.tableView.keyboardDismissMode = .interactive
    self.tableView.keyboardDismissMode = .onDrag
//    self.tableView.scrollsToTop = true
    tableView.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height)

        
        
        view.addSubview(imageUser)
        view.addSubview(labelTextDesc)
        view.addSubview(buttonRefresh)
        
        imageUser.isHidden = true
        labelTextDesc.isHidden  =  true
        buttonRefresh.isHidden  =  true
        
    loadItems()
    }
    
    
    @objc func didTapNext() {
        contentManager.performLogin(user: K.userLogin)
    }

    
    
    @objc func applicationDidEnterBackground() {
       print("app enters background")
        let userCoreStr = nameUserCore()
        activeUserManager.performActiveUser(loginLet: userCoreStr, action: 0)
   }

   @objc func applicationDidBecomeActive() {
       print("app enters foreground")
    let userCoreStr = nameUserCore()
    activeUserManager.performActiveUser(loginLet: userCoreStr, action: 1)
   }
        
    @objc func refresh() {
        let noGroup = NoGroup()
        noGroup.refresh()
        self.loadAlpha()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            self.contentManager.performLogin(user: self.user)
        }
    }
    
    
    
    @objc func refreshStep() {
        let noGroup = NoGroup()
        noGroup.refresh()
//        self.loadAlpha()
        DispatchQueue.main.async {
            self.contentManager.performLogin(user: self.user)
        }
    }
    
    
    @objc func refreshAddTopic() {

        let toast = ToastViewController(title: "Создание прошло успешно", backgroundColor: .systemGreen)
        present(toast, animated: true)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            toast.dismiss(animated: true)
        }
        
   
    }
    
    
    


     override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
     }
    
    
    func makeEditMenu() -> UIMenu {
    
        let addTopic = UIAction(title: "Создать замер", image: UIImage(systemName: "doc.badge.plus")) { action in
        self.didTapMenuButtonAdd()
    }
        
        let qr = UIAction(title: "QR", image: UIImage(systemName: "qrcode")) { action in
                    self.didQR()
                }
        

        
            
            
    // Creating Delete button
    let sendMail = UIAction(title: "Отправить отчет",
        image: UIImage(systemName: "envelope.open") ) { action in
        self.didTapMenuButtonSendMail()
    }
        
        var menuButton: [UIMenuElement] = []
        if K.teamLeader == 0 {
            menuButton = [/*addTopic,*/ sendMail, qr]
        } else
        {
            menuButton = [addTopic, sendMail, qr]
        }
        
        return UIMenu(title: "Edit",
//                          image: editIcon,
                      options: [.displayInline], // [], .displayInline, .destructive
                      children: menuButton)
    }
    


     // Set the activity indicator into the main view
     private func setLoadingScreen() {

         // Sets the view which contains the loading text and the spinner
         let width: CGFloat = 120
         let height: CGFloat = 30
         let x = (tableView.frame.width / 2) - (width / 2)
         let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
         loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

         // Sets loading text
         loadingLabel.textColor = .gray
         loadingLabel.textAlignment = .center
         loadingLabel.font = UIFont(name: K.fontRegular, size: 16)
         loadingLabel.text = "Загрузка..."
         loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

         // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium  //.gray
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

    //MARK: CoreDATA
 
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func loadItemsUser() {
        let request : NSFetchRequest<Login> = Login.fetchRequest()
        do {
            itemLoginArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func nameUserCore() -> String
    {
        loadItemsUser()
        if let i = itemLoginArray.firstIndex(where: {$0.user != nil }) {
            self.userCore = itemLoginArray[i].user!
            }
        return self.userCore
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
        loadItems()
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.topicID == topicI && book.flagActive == 0 && book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    func sumFactCellUser () -> Int {
        loadItems()
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    //MARK: Замеры
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    func isColorRow (numTag: Float) -> UIColor {

        switch numTag {
        case 0, 0.33:
            return UIColor(hexString: "#fd574e")
        case 0.34..<0.66:
            return UIColor(hexString: "#FDB64E")
        case 0.66..<100:
            return UIColor(hexString: "#4edf71")
        default:
            return UIColor(hexString: "#fd574e")
        }
    }
    

   func loadAlpha () {
        self.buttonRefresh.alpha = 0
        self.labelTextDesc.alpha = 0
        self.imageUser.alpha = 0
        self.tableView.alpha = 0
        self.tableView.isHidden = false
    UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
            self.buttonRefresh.alpha = 1
            self.labelTextDesc.alpha = 1
            self.imageUser.alpha = 1
            self.tableView.alpha = 1
        })
    }
    
    func cleareAlpha () {
//         self.buttonRefresh.alpha = 1
//         self.labelTextDesc.alpha = 0
           
            self.tableView.alpha = 0
        self.tableView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
             self.buttonRefresh.alpha = 0
             self.labelTextDesc.alpha = 0
             self.imageUser.alpha = 0
//             self.tableView.alpha = 0
         })
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
    

    
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    
        let message = filteredData[indexPath.section].topic[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        

        
//MARK: Принудильтельный скролл

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 10.0
        cell.indentationWidth = 30
        cell.layer.borderColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = .white
        cell.labelNme.textColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        cell.labelNme.font = UIFont(name: K.fontSemiBold, size: 15)
        cell.labelNme.text = message.TOPIC_NAME
        let count = String(message.COUNT_STEP)
        cell.labelCountAct.font = UIFont(name: K.fontRegular, size: 14)
        cell.labelCountAct.text = "\(String(message.COUNT_ACTIVE_F)) из \(message.PLAN_COUNT) замеров "
        cell.labelCountAct.textColor = isColorRow(numTag: Float(Float(message.COUNT_ACTIVE_F)/Float(message.PLAN_COUNT)))
        cell.labelTimeAVDAct.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelTimeAVDAct.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelTimeAVDAct.text = (castTime(localTimeDelta: Int(message.AVG_TIME_TOPIC)))
        cell.labelAvgString.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelAvgString.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelTimeAVDStep.textColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
        cell.labelTimeAVDStep.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelTimeAVDStep.text = (castTime(localTimeDelta: Int(message.AVG_TIME_STEP)))
        cell.labelCount.textColor = isColorRow(numTag: Float(Float(message.END_DAY)/Float(message.ALL_DAY)))
        cell.labelCount.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelCount.text = "\(String(message.END_DAY)) из \(String(message.ALL_DAY))"
        cell.labelAvgStep.textColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
        cell.labelAvgStep.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelAvg.textColor = isColorRow(numTag: Float(Float(message.END_DAY)/Float(message.ALL_DAY)))
        cell.labelAvg.font = UIFont(name: K.fontRegular, size: 10)
        cell.buttonInfo.tag = message.id
        cell.buttonInfo.addTarget(self, action: #selector(connected(sender:)), for: .allTouchEvents)
        cell.buttonInfo.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return cell
    }


    @objc func connected(sender: UIButton){
        

        let buttonTag = sender.tag
        
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableDetal") as? tableDetailController {
        newViewController.TOPIC_NAME = "Детализация"
            newViewController.user = user
            newViewController.group = group
            newViewController.TOPIC_ID = buttonTag
       
       

        let navController = UINavigationController(rootViewController: newViewController)
//        navController.modalTransitionStyle = .crossDissolve
//        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true, completion: nil)
        }
        
        print(buttonTag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredData.count
        
   
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredData[section].isExt {
            return 0
        }
        return filteredData[section].topic.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var popup:UIView!
//

        popup = UIView()
        popup.backgroundColor = UIColor.white

        let lb = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width, height: 40))
        lb.text = filteredData[section].name
//        lb.font = lb.font.withSize(20)
        lb.textColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        lb.font = UIFont(name: K.fontThin, size: 17)
        lb.textAlignment = .left
        popup.addSubview(lb)
        let imageOpen = UIImage(systemName: "chevron.backward")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let imageClose = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let isExpanded = filteredData[section].isExt
        button.frame = CGRect(x: 0, y: 10, width: view.frame.size.width * 1.9, height: 20)
        button.setImage(isExpanded ? imageClose : imageOpen, for: .normal)
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        button.tag = section
        popup.addSubview(button)
        self.view.addSubview(popup)
        return popup
    }
    

    
    
    //MARK: Сворачивание
    @objc func handleOpenClose(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in filteredData[section].topic.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        
        let isExpanded = filteredData[section].isExt
        filteredData[section].isExt = !isExpanded
        
        let imageOpen = UIImage(systemName: "chevron.backward")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let imageClose = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        
        button.setImage(isExpanded ? imageOpen : imageClose, for: .normal)


        
        if  isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        print(self.tableView.contentSize)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    

       
    
    
    //MARK: Бар для поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let searchText = searchBar.text {
                if searchText == "" {
                    filteredData = content
            }
             else {
                topicVar = []
                filteredData = []
                for item in content {
                    
//                    filteredData.append(item)
                    for x in item.topic {
                        
                        if x.TOPIC_NAME.lowercased().contains(searchText.lowercased()) {
                            topicVar.append(x)
                        }
                        
                    }

                    filteredData  = [Sector(name: "Поиск", isExt: true, topic: topicVar)]
                }
            }
            }

        
        self.valueSearch = searchText

        tableView.reloadData()
    }
    //MARK: Действие по нажатию
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)

        let message = filteredData[indexPath.section].topic[indexPath.row]
//        print(message.id)
//
//        print(message.TOPIC_NAME)


        func openCell(flagActive: Bool) {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableStep") as? tableStepController {

            let transition = CATransition()
            newViewController.TOPIC_NAME = message.TOPIC_NAME
            newViewController.user = self.user
            newViewController.group = self.group
            newViewController.idTopic = message.id
            newViewController.activeFlag = flagActive
            newViewController.TYPE_FEEDBACK = message.TYPE_FEEDBACK
            K.numberOfRows = self.tableView.indexPathsForSelectedRows!
            newViewController.valueSearchStep = valueSearch
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.navigationController?.view.layer.backgroundColor = .some(CGColor(red: 255, green: 255, blue: 255, alpha: 1))
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(newViewController, animated: false)


//            let navController = UINavigationController(rootViewController: newViewController)
//            navController.modalTransitionStyle = .crossDissolve
//            navController.modalPresentationStyle = .overFullScreen
//            self.present(navController, animated: true, completion: nil)
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
        let testAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            self.contentManager.performDelTopic(loginLet: K.userLogin, groupLet: K.idGroupProfile, nameTopic: self.filteredData[indexPath.section].topic[indexPath.row].TOPIC_NAME)
            self.filteredData[indexPath.section].topic.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        testAction.backgroundColor = .red
        testAction.image = UIImage(systemName: "trash")
        let testAction2 = UIContextualAction(style: .destructive, title: "Edit") { (_, _, completionHandler) in
            print("test")
            completionHandler(true)
        }
        testAction2.backgroundColor = .clear
        testAction2.image = UIImage(systemName: "pencil")
        if K.teamLeader == 0 {
            return nil
        }  else {
        return UISwipeActionsConfiguration(actions: [testAction])
        }
    }
    

    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        
        let alertController = UIAlertController(title: "Выход", message: "Выйти из учетной записи?", preferredStyle: .alert)

            // Initialize Actions
        let yesAction = UIAlertAction(title: "Выйти", style: .destructive) { (action) -> Void in
                print("The user is okay.")
            self.mainFunc.deleteAllData(entity: "Login")
            self.mainFunc.deleteAllData(entity: "Logtimer")
            K.userName = nil
            K.userLogin = nil
            K.idGroupProfile =  nil
            K.numberOfRowsProfilGroup = []
            imageQR.image = nil
            labelGroupName.text = ""
            K.groupName = nil
            labelInvite.text = nil
            K.teamLeader = nil
            K.numberOfRows = []
            
//            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
//                newViewController.modalTransitionStyle = .flipHorizontal // это значение можно менять для разных видов анимации появления
//                newViewController.modalPresentationStyle = .overFullScreen
//    //            newViewController.modalPresentationStyle = .currentContext
//    //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
//                self.present(newViewController, animated: true, completion: nil)
//
//
//
//
//               }
            
            let vc = LoginController()


           
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
    //        self.dismiss(animated: true)
            self.present(vc, animated: true, completion: nil)
            
            }

        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)


            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Кнопка Профиль
    @objc public func didProfile() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            let transition = CATransition()
            newViewController.user = self.user
            newViewController.nameUser = self.firstName
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.view.layer.backgroundColor = .some(CGColor(red: 255, green: 255, blue: 255, alpha: 1))
            self.navigationController?.pushViewController(newViewController, animated: false)
            self.imageUser.isHidden = true
            self.labelTextDesc.isHidden  =  true
            self.buttonRefresh.isHidden  =  true
//
            self.cleareAlpha()
        }
    }
    
    
    //MARK: Кнопка QR
    @objc public func didQR() {
    
            let newViewController =  ScannerViewController()
            newViewController.user = self.user
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: Кнопка Добавления
    @objc public func didTapMenuButtonAdd() {
//                DispatchQueue.main.async {
//        var textField = UITextField()
//
//               let alert = UIAlertController (title: "Добавить действие", message: "", preferredStyle: .alert)
//               let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
//                let nameTopic = textField.text
//                self.contentManager.performAddTopic(loginLet: self.user, groupLet: self.group, nameTopic: nameTopic!)
//                sleep(1)
//                self.contentManager.performLogin(user: self.user)
//                self.tableView.reloadData()
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Добавить новое действие"
//            textField = alertTextField
//        }
//        alert.addAction(action)
//                    self.tableView.reloadData()
//                    self.present(alert, animated: true, completion: nil)
//        }
        
        
        let vc = AddNewTopicController()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
        
        
    }
    
    //MARK: Кнопка Отправки отчета
    @objc public func didTapMenuButtonSendMail() {


        
        
        let alertController = UIAlertController(title: "Информация", message: "Вы хотите отправить отчет на e-Mail?", preferredStyle: .alert)

        
        // Initialize Actions
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

        let yesAction = UIAlertAction(title: "Да", style: .cancel) { (action) -> Void in
                print("The user is okay.")
            
            let today = Date()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yMMd_Hmmss"
                self.contentManager.performSendMail(loginLet: self.user, keyName: self.user + "_" + formatter1.string(from: today))
            }

            // Add Actions
            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension tableController: ActiveUserManagerDelegate {
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser]) {
        
    }
    
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin]) {
        
    }
    
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate) {
        

        
    }
    
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
}

extension tableController: ContentManagerDelegate {

    

    
    func didSendMail(_ Content: ContentManager, content: SendMail) {
        DispatchQueue.main.async {
        print(content.mail)
        
        
        
        let alert = UIAlertController(title: "Информация", message: "Сообщение отправлено на \(content.mail)", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    

    
    
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
                    newItem.comment = item.COMMENT
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
        

        

        
        if (resetCoredata == false ) {
//            saveContentCore()
//            loadItems()
        }else
        {
            self.mainFunc.deleteAllData(entity: "Logtimer")
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
    //MARK: Запрос к сервису Замеров
    func didContentData(_ Content: ContentManager, content: [Sector]) {
        self.content = content
        self.filteredData = content

        DispatchQueue.main.async {
          
            if content.count == 0 {
                self.tableView.isScrollEnabled = false
                self.tableView.backgroundColor = .white
                self.searchBar.isHidden = true
                self.labelTextDesc.text = "Сейчас в группе '\(String(K.groupName))' нет активных замеров!"
                self.imageUser.isHidden = false
                self.labelTextDesc.isHidden  =  false
                self.buttonRefresh.isHidden  =  false
               
//                self.removeLoadingScreen()
           } else {
                self.tableView.isScrollEnabled = true
                self.view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
                self.searchBar.isHidden = false
                self.imageUser.isHidden = true
                self.labelTextDesc.isHidden  =  true
                self.buttonRefresh.isHidden  =  true
             }
             self.searchBar(self.searchBar, textDidChange: self.valueSearch)
            self.tableView.separatorStyle = .singleLine
            self.removeLoadingScreen()
            self.tableView.reloadData()
             K.numberOfRows.forEach { numberOfRows in
                self.tableView.selectRow(at: numberOfRows, animated: false, scrollPosition: .none)
            }
//            self.loadAlpha()
 
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



extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
//             scanner.currentIndex = 1
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
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




class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}



class NoGroup: UIViewController {

    var labelName = UILabel()
    var imageUser = UIImageView()
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    let mainFunc = MainFunc()
    let customAlert = AlertCustom()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if K.rederectUrl != nil {
        customAlert.showAlertOkView(main: "Внимание", second: K.rederectUrl!, control: self, dismissView: false, notificcationStr: nil)
        }
        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
//        labelName.text = "Привет МИР!"
        view.addSubview(labelName)
        // Do any additional setup after loading the view.
    

        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif1"), object: nil)
  
        let buttonBack = UIButton(type: .system)
        buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        buttonBack.setTitle("Назад", for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        buttonBack.sizeToFit()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)

        
        
        let buttonNext = UIButton(type: .system)
        buttonNext.setTitle("Далее", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)

        
        
        let buttonCreate = UIButton()
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
        buttonCreate.setTitle("Отсканировавть QR", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: UIControl.Event.touchUpInside)
//        buttonCreate.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonCreate)
        
        let buttonExit = UIButton()
        buttonExit.frame = CGRect(x: 10, y: 63, width: 70, height: 14)
//        buttonExit.backgroundColor = UIColor(hexString: "#478ECC")
        buttonExit.setTitle("Выход", for: .normal)
//        buttonExit.tintColor = .systemBlue
        buttonExit.setTitleColor(.systemBlue,
                             for: .normal)
        
//        buttonExit.layer.cornerRadius = 8
//        buttonExit.layer.borderWidth = 0
        buttonExit.addTarget(self, action: #selector(didTapBack), for: UIControl.Event.touchUpInside)
//        buttonCreate.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonExit)

        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/4)-80, width: 160, height: 110)
        let url = URL(string:  "https://shi-ku.ru/img/not_group.png")
        let data = try? Data(contentsOf: url!)
        imageUser.image = UIImage(data: data!)
        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 80)
        labelTextMain.text = "Что нужно для начала работы?"
        labelTextMain.numberOfLines = 2
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 20, width: 300, height: 80)
        labelTextDesc.text = "Вам необходимо добавиться в группу! Для этого отсканируйте QR"
        labelTextDesc.numberOfLines = 3
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(labelTextDesc)
    }
    

    @objc func didTapBack() {
        self.mainFunc.deleteAllData(entity: "Login")
        self.mainFunc.deleteAllData(entity: "Logtimer")
        K.userName = nil
        K.userLogin = nil
        K.idGroupProfile =  nil
        K.numberOfRowsProfilGroup = []
        imageQR.image = nil
        labelGroupName.text = ""
        K.groupName = nil
        labelInvite.text = nil
        
        
        
        let vc = LoginController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
//        self.dismiss(animated: true)
        self.present(vc, animated: true, completion: nil)

           
        }
    
    @objc public func didTapNext() {

        let newViewController =  ScannerViewController()
        newViewController.user = K.userLogin
        let navController = UINavigationController(rootViewController: newViewController)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true, completion: nil)
//        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func refresh() {

        DispatchQueue.main.async {
       self.dismiss(animated: true, completion: nil)
        }
    }


}


struct MainFunc {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
}



