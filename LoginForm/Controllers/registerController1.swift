


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
        
//        createPickerView()
//        dismissPickerView()
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
    
    
//    func createPickerView() {
//           let pickerView = UIPickerView()
//           pickerView.delegate = self
//            textBox.inputView = pickerView
//
//    }
    
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



        

    
