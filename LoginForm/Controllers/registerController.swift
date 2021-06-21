


//
//  registerController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import Foundation
import UIKit
import CoreData



class registerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {


    var registerManager = RegisterManager()
    var nameRegVar = ""
    var countryList = [List]()
    var selectedCountryID: Int!
    let viewMain = UIView()
    var itemTimeArray = [Login]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.frame = view.frame
        viewMain.backgroundColor = .white
        self.view.addGradientBackground(firstColor: UIColor(hexString: "#dfebfe"), secondColor: UIColor(hexString: "#ffffff"))
        loginManager.delegate = self
        // Do any additional setup after loading the view.
        registerManager.delegate = self
        registerManager.performRequestGroup()
        
        createPickerView()
        dismissPickerView()
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
  
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonAct: UIButton!
    
    
    @IBOutlet weak var nameReg: UITextField!
    @IBOutlet weak var loginReg: UITextField!
    @IBOutlet weak var mailReg: UITextField!
    @IBOutlet weak var phoneReg: UITextField!
    @IBOutlet weak var passReg: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var textBox: UITextField!
    var list = ["1", "2", "3"]
    
    @IBAction func backSwitch(_ sender: Any) {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
            newViewController.modalTransitionStyle = .crossDissolve // это значение можно менять для разных видов анимации появления
            newViewController.modalPresentationStyle = .overFullScreen
//            newViewController.modalPresentationStyle = .currentContext
//            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
            self.present(newViewController, animated: true, completion: nil)

           }
    }
    
    
    @IBAction func pressButt(_ sender: Any) {
//        print("1")
//        var a = ""
//        labelHeader.text = String(a)

    let nameRegLet = nameReg.text!
    let loginRegLet = loginReg.text!
    let mailRegLet = mailReg.text!
    let phoneRegLet = phoneReg.text!
    let passRegLet = passReg.text!.sha512
    let groupLet = (selectedCountryID != nil) ? String(selectedCountryID) : ""

        registerManager.performRequest(nameRegLet: nameRegLet, loginRegLet: loginRegLet, mailRegLet: mailRegLet, phoneRegLet: phoneRegLet, passRegLet: passRegLet, groupLet: groupLet)

    }
    
    
    //MARK: Piker
    
    var selectedCountry: String?
//    var countryList = ["1", "2", "3", "4", "5", "10"]
    
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
            textBox.inputView = pickerView
            
    }
    
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
    }
    
    func typeAction(user: String, pass: String) {
        let newItem = Login(context: self.context)
        newItem.user = user
        newItem.pass = pass
        self.itemTimeArray.append(newItem)
        self.saveItems()
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
//        textBox.inputView = nil

        textBox.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return countryList.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row].name // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountryID = countryList[row].group_id
        selectedCountry = String(countryList[row].name) // selected item
        textBox.text = selectedCountry
    }

}

//MARK: RegisterFunc
extension registerController: RegisterManagerDelegate {
    func didListGroup(_ weatherRegister: RegisterManager, register: [List]) {
        
        countryList = register
        
    }
    
    func didUpdateRegister(_ weatherRegister: RegisterManager, register: ResponceModel) {
        DispatchQueue.main.async {
            print(register.statusUser)
           
            if (register.statusUser) == 0 {
                
//                let alert = UIAlertController(title: "Информация", message: String(register.statusUserStr), preferredStyle: UIAlertController.Style.alert)
//
//                // add an action (button)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//                // show the alert
//                self.present(alert, animated: true, completion: nil)
                self.loginManager.performLogin(loginRegLet: self.loginReg!.text!, passRegLet: self.passReg.text!.sha512)
            } else {
                // create the alert
                let alert = UIAlertController(title: "Информация", message: String(register.statusUserStr), preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)

            }

        }
    }
}
extension registerController: LoginManagerDelegate {
    

    func didAddDev(_ Login: LoginManager, login: FlagAdd) {
        
    }
    
    func didUpdateLogin(_ Login: LoginManager, login: LoginModel) {
        
        
        
        func openMainController() {
            K.userName = login.firstName
            K.userLogin = login.login
            K.idGroupProfile =  login.group
            K.numberOfRowsProfilGroup = []
            K.groupName = login.groupName
            K.urlTabBar = nil
            K.teamLeader = login.TL

                let vc = NoGroup()
        //        let navController = UINavigationController(rootViewController: vc)
        //        navController.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)

        }
        
        func showViewMain() {
            view.addSubview(viewMain)
        }
        

        
        DispatchQueue.main.async { [self] in

            if (login.status) == 2 {
                    
                K.userName = login.firstName
                K.userLogin = login.login
                K.idGroupProfile =  login.group
                K.numberOfRowsProfilGroup = []
                K.groupName = login.groupName
                K.urlTabBar = nil
                K.teamLeader = login.TL
                K.userPass = self.passReg.text!.sha512
                self.typeAction(user: login.login, pass: self.passReg.text!.sha512)
                    let vc = NoCheck()

                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)
            }
        }
    }
    

}


class  NoCheck: UIViewController {

    var labelName = UILabel()
    var imageUser = UIImageView()
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    let mainFunc = MainFunc()
    let customAlert = AlertCustom()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loginManager = LoginManager()
    let viewMain = UIView()
    var timer = Timer()
    var itemTimeArray = [Login]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.didTapNext), userInfo: nil, repeats: true)
        loginManager.delegate = self
        viewMain.frame = view.frame
        viewMain.backgroundColor = .white
        if K.rederectUrl != nil {
        customAlert.showAlertOkView(main: "Внимание", second: K.rederectUrl!, control: self, dismissView: false, notificcationStr: nil)
        }
        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
//        labelName.text = "Привет МИР!"
        view.addSubview(labelName)
        // Do any additional setup after loading the view.
    

        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif12"), object: nil)
  
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

        
        
//        let buttonCreate = UIButton()
//        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
//        buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
//        buttonCreate.setTitle("Отсканировавть QR", for: .normal)
//        buttonCreate.layer.cornerRadius = 8
//        buttonCreate.layer.borderWidth = 0
//        buttonCreate.addTarget(self, action: #selector(didTapNext), for: UIControl.Event.touchUpInside)
////        buttonCreate.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
////        buttonCreate.layer.borderColor = UIColor.black.cgColor
// 
//        view.addSubview(buttonCreate)
        
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

        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/4)-80, width: 160, height: 132)
        let url = URL(string:  "https://shi-ku.ru/img/mail_check.png")
        let data = try? Data(contentsOf: url!)
        imageUser.image = UIImage(data: data!)
        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 80)
        labelTextMain.text = "Проверка почты"
        labelTextMain.numberOfLines = 2
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(labelTextMain)
        

        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 20, width: 300, height: 120)
        labelTextDesc.text = "На указанный почтотвый ящик направлено письмо для подстверждения адреса. После подтверждения фунционал приложение станет доступен."
        labelTextDesc.numberOfLines = 5
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
        
        
        self.timer.invalidate()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "main") as! ViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)

           
        }
    
    @objc public func didTapNext() {

        self.loginManager.performLogin(loginRegLet:  K.userLogin, passRegLet: K.userPass)
//        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func refresh() {

        DispatchQueue.main.async {
       self.dismiss(animated: true, completion: nil)
        }
    }
    
    func typeAction(user: String, pass: String) {
        let newItem = Login(context: self.context)
        newItem.user = user
        newItem.pass = pass
        self.itemTimeArray.append(newItem)
        self.saveItems()
    }
    
    
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
    }


}




    extension NoCheck: LoginManagerDelegate {
        

        func didAddDev(_ Login: LoginManager, login: FlagAdd) {
            
        }
        
        func didUpdateLogin(_ Login: LoginManager, login: LoginModel) {
            
            
            
            func openMainController() {
                K.userName = login.firstName
                K.userLogin = login.login
                K.idGroupProfile =  login.group
                K.numberOfRowsProfilGroup = []
                K.groupName = login.groupName
                K.urlTabBar = nil
                K.teamLeader = login.TL

                    let vc = NoGroup()
            //        let navController = UINavigationController(rootViewController: vc)
            //        navController.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)

            }
            
            func showViewMain() {
                view.addSubview(viewMain)
            }
            

            
            DispatchQueue.main.async { [self] in

                if (login.status) == 1 {


                    
                    self.timer.invalidate()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyboard.instantiateViewController(withIdentifier: "Table") as! tableController
                    
                    newViewController.firstName = K.userName
                    newViewController.user = K.userLogin
                    newViewController.group = K.idGroupProfile
                    newViewController.resetCoredata = true
                    newViewController.userAction = K.userLogin
                    K.numberOfRows = []

                    let navController = UINavigationController(rootViewController: newViewController)
                    navController.modalTransitionStyle = .flipHorizontal
                    navController.modalPresentationStyle = .overFullScreen
                    
                    activeUserManager.performActiveUserSeance(loginLet: K.userLogin, action: 2)
                    newViewController.idSeance = nil
        //            newViewController.modalPresentationStyle = .currentContext
        //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
                    self.present(navController, animated: true, completion: nil)
                    
//                    self.dismiss(animated: true, completion: nil)
//                    _ = navigationController?.popViewController(animated: true)
                        showViewMain()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                    
                                }

                }
            }
        }
        

    
