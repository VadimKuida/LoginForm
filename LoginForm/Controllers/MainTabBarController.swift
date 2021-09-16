//
//  MainTabBarController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 07.03.2021.
//

import UIKit



let tableViewAdd = UITableView()
let tableViewAddGroup = UITableView()
let imageQR = UIImageView()
let labelName = UILabel()
let imageUser = UIImageView()
let viewPrifile = UIView()
let loadingView = UIView()
let labelAlarm = UILabel()
let buttonAddGroup = UIButton()
var labelGroupName = UILabel()
var labelInvite = UILabel()
var mainView = UIView()
var user: String!
var idGroup: Int!
var activeUserManager = ActiveUserManager()
var arrayItem: [ListAdmin] =  []
var arrayItemUser: [ListAdminUser] = []

var shareTypeSwitch: UISwitch!

var alertCustom = AlertCustom()
var loadScreen = LoadScreen()

/// Spinner shown during load the TableView
let spinner = UIActivityIndicatorView()
/// Text shown during load the TableView
let loadingLabel = UILabel()

//let mainTabBarController = MainTabBarController()


//MARK: Экран групп
class SeccondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: String!
    var userName: String!
    var urlSeccond: String!



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        activeUserManager.delegate = self
        tableViewAdd.dataSource = self
        tableViewAdd.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshGroup), name: NSNotification.Name(rawValue: "newDataNotifUpdateGroupUser"), object: nil)

        self.registerTableViewCells()
        view.backgroundColor = .white
        
        tableViewAdd.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell" )
        tableViewAdd.frame = CGRect(x: 0, y: 300, width: view.frame.size.width, height: view.frame.size.height-300)
        self.view.addSubview(tableViewAdd)
        tableViewAdd.isHidden =  true
//        loadAlpha ()
        
        
        labelAlarm.frame = CGRect(x: (tableViewAdd.frame.size.width-200)/2, y: 300 + 200, width: 200, height: 20)
        self.view.addSubview(labelAlarm)
        labelAlarm.isHidden = true
        tableViewAdd.scrollsToTop = true
//        tableViewAdd.alpha = 0


    }
    


    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrayItem.count
        
    }
    

    
    
    //MARK: Отрисовка cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = arrayItem[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.labelNme.text = message.NAME
        cell.labelCountAct.isHidden = true
        cell.labelCountAct.isHidden = true
        cell.labelTimeAVDAct.isHidden = true
        cell.labelAvgString.isHidden = true
        cell.labelTimeAVDStep.isHidden = true
        cell.labelAvgStep.isHidden = true
        cell.buttonInfo.isHidden = true
        cell.labelAvg.text = "Участники"
        
        
        cell.labelCount.text = String(message.USER_COUNT)
        return cell
    }
    
    
    //MARK: Действие по нажатию
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        loadAlpha ()
        
        let message = arrayItem[indexPath.row]
        K.numberOfRows = []
        labelGroupName.text = message.NAME
        K.groupName  = message.NAME
        K.numberOfRowsProfilGroup = tableViewAdd.indexPathsForSelectedRows!
        if idGroup != message.ID_GROUP {
            activeUserManager.performShowUser(idGroup: message.ID_GROUP)
            imageQR.image =  nil
            loadScreen.setLoadingScreen(xF: (imageQR.frame.width / 2), yF: (imageQR.frame.height / 2)-50, widthF: 30, heightF: 30, showLabel: false, viewF: imageQR)
            let url = URL(string: "https://api.qrserver.com/v1/create-qr-code/?data=shiku://val1=\(String(message.QR))&size=150x150")!

            
            idGroup = message.ID_GROUP
//            sheareQR(url: message.QR)
            K.urlTabBar = message.QR
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        imageQR.image = UIImage(data: data)
                        loadScreen.removeLoadingScreen()
                        imageQR.alpha = 0
                        UIView.animate(withDuration: 0.3, delay: 0, animations: {
                            imageQR.isHidden =  false
                            imageQR.alpha = 1
                         })
                    }
                }
            }
    }
   }
    
    
//    func sheareQR(url: String) {
////        let navController = self.tabBarController! as! MainTabBarController
//        K.urlTabBar = url
//
//    }
    
    
    
    @objc func refreshGroup() {
  
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            activeUserManager.performShowComment(loginLet: K.userLogin)

        }
   }


    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        tableViewAdd.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    


    



    
}


//MARK: Экран команды
class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
//    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        activeUserManager.delegate = self
        view.backgroundColor = .white
        tableViewAddGroup.frame = CGRect(x: 0, y: 300, width: view.frame.size.width, height: view.frame.size.height-300)
        self.view.addSubview(tableViewAddGroup)
        tableViewAddGroup.dataSource = self
        tableViewAddGroup.delegate = self
        self.registerTableViewCells()

    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayItemUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messages = arrayItemUser[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableDetailCell", for: indexPath) as! CustomTableDetailCell
        cell.labelName.textColor = UIColor.init(red: 68.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1)
        cell.labelName.font = UIFont(name: K.fontRegular, size: 12)
        cell.labelName.text = "\(messages.NN). \(messages.NAME)"


        
        return cell
    }
    
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableDetailCell",
                                  bundle: nil)
        tableViewAddGroup.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableDetailCell")
    }
    
}


//MARK: TabBar
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var nameUser: String!
    var user: String!
    var urlTabBar: String!
    var shareTypeSwitch: UISwitch!
    var tabBarList: [UIViewController]!
    var tabBarListOne: [UIViewController]!

   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        let firstViewController = SeccondViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 0)
        let secondViewController = FirstViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Команда", image: UIImage(systemName: "person.3.fill"), tag: 0)
        firstViewController.user = user
        firstViewController.userName = nameUser
        activeUserManager.delegate = self
        activeUserManager.performShowComment(loginLet: K.userLogin)
        
        view.addSubview(mainView)
       
        
        tabBarList = [firstViewController, secondViewController]
        
        tabBarListOne = [secondViewController]
        
     
        let yNav = 50 + 40
        
            imageQR.frame = CGRect(x: view.frame.size.width-120, y: 150, width: 100, height: 100)
            self.view.addSubview(imageQR)

            labelGroupName.frame = CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 20)
            labelGroupName.textColor = UIColor.init(red: 30.0/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
            labelGroupName.font = UIFont(name: K.fontRegular, size: 15)
            labelGroupName.textAlignment = .center
            self.view.addSubview(labelGroupName)
        
            labelInvite.frame = CGRect(x: view.frame.size.width-145, y: imageQR.frame.maxY + 5, width: 150, height: 20)
            labelInvite.textColor = UIColor.init(red: 30.0/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
            labelInvite.font = UIFont(name: K.fontThin, size: 10)
            labelInvite.textAlignment = .center
            self.view.addSubview(labelInvite)
        
            buttonAddGroup.frame = CGRect(x: view.frame.size.width-45, y: 300 - 40, width: 30, height: 30)
            buttonAddGroup.setImage((UIImage(systemName: "plus.app")), for: .normal )
            buttonAddGroup.addTarget(self, action: #selector(tappedAddGroup), for: .touchUpInside)
                if K.teamLeader == 1 {
                    self.view.addSubview(buttonAddGroup)
                }

            viewPrifile.frame = CGRect(x: 10, y: yNav, width: (Int(view.frame.size.width)/2) - 10, height: 200)

                imageUser.frame = CGRect(x: (viewPrifile.frame.width-160)/2, y: 30, width: 160, height: 146)
//                let url = URL(string:  "https://shi-ku.ru/img/undraw_profile_pic_ic5t.png")
//                let data = try? Data(contentsOf: url!)
                
        
        
        let url = URL(string:  "https://shi-ku.ru/img/undraw_profile_pic_ic5t.png")

        

        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    imageUser.image = UIImage(data: data)
//                    loadScreen.removeLoadingScreen()
                    imageUser.alpha = 0
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
//                        imageUser.isHidden =  false
                        imageUser.alpha = 1
                     })
                }
            }
        }
        
        
                viewPrifile.addSubview(imageUser)
                self.view.addSubview(viewPrifile)
                labelName.frame = CGRect(x: 20, y: imageUser.frame.maxY + 5, width: viewPrifile.frame.width - 40, height: 20)
                labelName.text = K.userName
                labelName.numberOfLines = 1
                labelName.textColor = UIColor.init(red: 30.0/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
                labelName.font = UIFont(name: K.fontBold, size: 15)
                labelName.textAlignment = .center
                viewPrifile.addSubview(labelName)
           
        
        let leftBackButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        let rightBackButton = UIBarButtonItem(
                    image: UIImage(systemName: "square.and.arrow.up"),
                    style: .plain,
                    target: self,
                    action: #selector(didTapMenuButtonShear))
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationItem.rightBarButtonItem = rightBackButton
        
    }
    
    //Проверка активного view 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if K.teamLeader == 1 && tabBarIndex == 0 {
            buttonAddGroup.isHidden = false
        } else {
            buttonAddGroup.isHidden = true
        }
    }
    
    func loadAlpha () {
//         self.buttonRefresh.alpha = 0
//         self.labelTextDesc.alpha = 0
//         self.imageUser.alpha = 0
         tableViewAdd.alpha = 0
        tableViewAddGroup.alpha = 0
//         self.tableView.isHid11den = false
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
//             self.buttonRefresh.alpha = 1
//             self.labelTextDesc.alpha = 1
//             self.imageUser.alpha = 1
        tableViewAdd.isHidden =  false
        tableViewAdd.alpha = 1

         })
     }
    
    func loadAlphaP () {
//         self.buttonRefresh.alpha = 0
//         self.labelTextDesc.alpha = 0
//         self.imageUser.alpha = 0
//         tableViewAdd.alpha = 0
        tableViewAddGroup.alpha = 0
//         self.tableView.isHid11den = false
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
//             self.buttonRefresh.alpha = 1
//             self.labelTextDesc.alpha = 1
//             self.imageUser.alpha = 1
//        tableViewAdd.isHidden =  false
//        tableViewAdd.alpha = 1
        tableViewAddGroup.isHidden =  false
        tableViewAddGroup.alpha = 1
         })
     }
    

    //MARK: Кнопка добавления Группы
    @objc func tappedAddGroup() {
//        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddGroupAddController") as? AddGroupAddController {
////        newViewController.TOPIC_NAME = "Детализация"
////            newViewController.user = user
////            newViewController.group = group
////            newViewController.TOPIC_ID = buttonTag
//
//
//
//        let navController = UINavigationController(rootViewController: newViewController)
////        navController.modalTransitionStyle = .crossDissolve
////        navController.modalPresentationStyle = .overFullScreen
//        self.present(navController, animated: true, completion: nil)
//        }
        
        let vc = AddGroupAddController()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
        
    }
    
    //MARK: Кнопка назад
    @objc func didTapMenuButton(sender: UIBarButtonItem) {
//        K.numberOfRows = []
        let idGroupBack = (idGroup != nil) ? idGroup : K.idGroupProfile
        
        if arrayItem.count == 0 {
            imageQR.image = nil
        }
        else {
        activeUserManager.performUpdateGroup(loginLet: K.userLogin, group: String(idGroupBack!).sha512)
        idGroup =  nil
        K.idGroupProfile = idGroupBack
        }
        _ = navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

    }
    
    
    
    
    @objc func didTapMenuButtonShear() {
        if K.urlTabBar != nil {
            let firstImages = "https://api.qrserver.com/v1/create-qr-code/?data=shiku://val1=\(String(K.urlTabBar))&size=150x150"
            let firstOpenApp = (String(K.groupName))
            let urlImages = URL(string: firstImages)!
           
            if let data = try? Data(contentsOf: urlImages) {
            let image = UIImage(data: data)!
            let ac = UIActivityViewController(activityItems: [image,firstOpenApp], applicationActivities: nil)
            present(ac, animated: true)
            }
        } else {
            alertCustom.showAlertOk(main: "Внимание!", second: "Выбиреите группу", control: self)
        }
    }
    
    func labelAlert(flag: Int) {
        if (flag == 0) {
            labelAlarm.isHidden = false
            tableViewAdd.isHidden = true
            labelAlarm.font = UIFont(name: K.fontSemiBold, size: 14)
            labelAlarm.text = "Группы не созданы!"
            labelAlarm.textAlignment = .center
        }  else {
            labelAlarm.isHidden = true
            tableViewAdd.isHidden = false

  
        }
    }


}





extension MainTabBarController: ActiveUserManagerDelegate {

    
    
    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            if content.success == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            }
        }
    }
    
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin]) {
            arrayItem = content
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.labelAlert(flag: content.count)
                if K.teamLeader == 0  {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.viewControllers = self.tabBarListOne
                    labelInvite.text = "Подключи друга ))"
                    labelInvite.font = UIFont(name: K.fontRegular, size: 14)
                    loadScreen.setLoadingScreen(xF: (imageQR.frame.width / 2), yF: (imageQR.frame.height / 2)-50, widthF: 30, heightF: 30, showLabel: false, viewF: imageQR)
                    activeUserManager.performShowUser(idGroup: K.idGroupProfile)
                    let url = URL(string: "https://api.qrserver.com/v1/create-qr-code/?data=val1=\(String(K.idGroupProfile).sha512)&size=150x150")!
//                    K.urlTabBar = "https://api.qrserver.com/v1/create-qr-code/?data=val1=\(String(K.idGroupProfile).sha512)&size=150x150"
                    DispatchQueue.global().async {
                        // Fetch Image Data
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                imageQR.alpha = 0
                                // Create Image and Update Image View
                                imageQR.image = UIImage(data: data)
                                loadScreen.removeLoadingScreen()
                                labelGroupName.text = K.groupName
                               
                                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                                    imageQR.isHidden =  false
                                    imageQR.alpha = 1
                                 })
                            }
                        }
                    }
                    
                } else {
                    self.viewControllers = self.tabBarList
                }
//                self.removeLoadingScreen()
                tableViewAdd.reloadData()
                self.loadAlpha ()
                K.numberOfRowsProfilGroup.forEach { numberOfRowsProfilGroup in
                    tableViewAdd.selectRow(at: numberOfRowsProfilGroup, animated: false, scrollPosition: .middle)
                }
            }
    }
    
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser]) {

        arrayItemUser = content
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {

            tableViewAddGroup.reloadData()
            self.loadAlphaP ()
            }
    }
}
