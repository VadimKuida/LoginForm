//
//  loginController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import Foundation
import UIKit
import CoreData
import SafariServices


class RegisterController: UIViewController, UITextFieldDelegate{
    
    
    var labelName = UILabel()
    var imageUser = UIImageView()
    
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    
    var editorName = UITextField()
    var editorNameF = UITextField()
    var editorLogin = UITextField()
    let buttonCreate = UIButton()
    let buttonNext = UIButton(type: .system)
    var nextFlag: Bool = false
    var nameRegLet: String = ""
    var loginRegLet: String = ""
    
  


    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let textPlaceholder = NSAttributedString(string: "11", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3C3C43", alpha: 0.3), NSAttributedString.Key.font: UIFont(name: K.fontLight, size: 17)!])
        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        view.addSubview(labelName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
  
        

        
      
//        view.addSubview(buttonBack)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        
        buttonNext.setImage(UIImage(systemName: "chevron.next"), for: .normal)
        buttonNext.setTitle("Далее", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()

        
        
        self.navigationItem.rightBarButtonItem = nil
        
        
        editorName.delegate = self
        editorNameF.delegate = self
        editorLogin.delegate = self
     
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonCreate.isEnabled = false
        buttonCreate.backgroundColor = UIColor(hexString: "#dcdce0")
        buttonCreate.setTitle("Далее", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        view.addSubview(buttonCreate)

        imageUser.frame = CGRect(x: (view.frame.width-201)/2, y: (view.frame.height/6-60), width: 201, height: 40)
        imageUser.image = UIImage(named: "logo_white")
        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 40)
        labelTextMain.text = "Регистрация"
        labelTextMain.numberOfLines = 1
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont(name: K.fontBold, size: 30)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 10, width: 300, height: 50)
        labelTextDesc.text = "Шаг 1 из 2 \nЗаполните все поля"
        labelTextDesc.numberOfLines = 2
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont(name: K.fontRegular, size: 15)
        labelTextDesc.textColor = UIColor(hexString: "#9f9fa6")
        view.addSubview(labelTextDesc)

        
        editorName.frame = CGRect(x: 16 , y: labelTextDesc.frame.maxY + 35, width: view.frame.width - (16*2), height: 60)
        
        editorName.backgroundColor = .white
        editorName.attributedPlaceholder = textPlaceholder
        editorName.placeholder  = "Имя"
        editorName.clearButtonMode = .whileEditing
        editorName.autocorrectionType = .no
        view.addSubview(editorName)

        view.addSubview(lineBorder(y: editorName.frame.maxY))
        
        editorNameF.frame = CGRect(x: 16 , y: editorName.frame.maxY+2, width: view.frame.width - (16*2), height: 60)
        
        editorNameF.backgroundColor = .white
        editorNameF.attributedPlaceholder = textPlaceholder
        editorNameF.placeholder  = "Фамилия"
//        editorNameF.keyboardType = .numberPad
        editorNameF.clearButtonMode = .whileEditing
        editorNameF.autocorrectionType = .no
        view.addSubview(editorNameF)
        view.addSubview(lineBorder(y: editorNameF.frame.maxY))
        
        editorLogin.frame = CGRect(x: 16 , y: editorNameF.frame.maxY+2, width: view.frame.width - (16*2), height: 60)
        
        editorLogin.backgroundColor = .white
        editorLogin.attributedPlaceholder = textPlaceholder
        editorLogin.placeholder  = "Логин (ТН)"
        editorLogin.keyboardType = .emailAddress
        editorLogin.clearButtonMode = .whileEditing
        editorLogin.autocorrectionType = .no
        view.addSubview(editorLogin)
        view.addSubview(lineBorder(y: editorLogin.frame.maxY))
          
        
    }
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        
        if editorName.text == "" || editorNameF.text == "" || editorLogin.text == ""  {
            self.buttonCreate.backgroundColor = UIColor(hexString: "#dcdce0")
            self.buttonCreate.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            nextFlag = false
        } else  {
            self.buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
            self.buttonCreate.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            nextFlag = true
        }
//        self.buttonCreate.backgroundColor = UIColor(hexString: colorB)
        
    }
    
    func lineBorder (y: CGFloat) -> UIView {
        
        let lineView = UIView(frame: CGRect(x: 16, y: y + 1, width: view.frame.width - (16*2), height: 0.6))
        lineView.layer.borderWidth = 0.6
        lineView.layer.borderColor = UIColor(hexString: "#3C3C43", alpha: 0.3).cgColor
        
        return lineView
    }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didTapNext() {
        self.nameRegLet = editorName.text! + " " + editorNameF.text!
        self.loginRegLet = editorLogin.text!
        let vc = RegisterController1()
        vc.nameRegLet = editorName.text! + " " + editorNameF.text!
        vc.loginRegLet = editorLogin.text!
        let navController = UINavigationController(rootViewController: vc)
       
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overCurrentContext
//        self.dismiss(animated: true)
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func refresh () {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifAddTopic"), object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
        self.navigationItem.rightBarButtonItem?.isEnabled = nextFlag
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.navigationItem.rightBarButtonItem = nil

    }
}



class RegisterController1: UIViewController, UITextFieldDelegate {
    
    
    var labelName = UILabel()
    var imageUser = UIImageView()
    
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    
    var editorMail = UITextField()
    var editorPassword = UITextField()
    let buttonCreate = UIButton()
    var nextFlag: Bool = false
    let buttonNext = UIButton(type: .system)
    
    var registerManager = RegisterManager()
    var nameRegVar = ""
    var countryList = [List]()
    var selectedCountryID: Int!
    let viewMain = UIView()
    var itemTimeArray = [Login]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loginManager = LoginManager()
    
    var nameRegLet: String!
    var loginRegLet: String!

    var mailRegLet: String!
    var passRegLet: String!
    
    var checkBox = CheckBox()
    var labelAgree = UILabel()
    var checkBoxState: Bool = false
    
    
    @IBOutlet private weak var singleCheckBoxOutlet: UIButton!{
        didSet{
            singleCheckBoxOutlet.setImage(UIImage(systemName:"checkmark.seal"), for: .normal)
            singleCheckBoxOutlet.setImage(UIImage(systemName:"checkmark.seal.fill"), for: .selected)
            //Set corner radius
            singleCheckBoxOutlet.layer.cornerRadius = singleCheckBoxOutlet.frame.height / 2
        }
    }
    
    let delegateApp = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginManager.delegate = self
        // Do any additional setup after loading the view.
        registerManager.delegate = self
        registerManager.performRequestGroup()
        
        editorMail.text = ""
        editorPassword.text = ""
        print(nameRegLet)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let textPlaceholder = NSAttributedString(string: "11", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3C3C43", alpha: 0.3), NSAttributedString.Key.font: UIFont(name: K.fontLight, size: 17)!])
        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
//        labelName.text = "Привет МИР!"
        view.addSubview(labelName)
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
  
        let buttonBack = UIButton(type: .system)
        buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        buttonBack.setTitle("Назад", for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        buttonBack.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)
//        view.addSubview(buttonBack)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        
        
        buttonNext.setImage(UIImage(systemName: "chevron.next"), for: .normal)
        buttonNext.setTitle("Далее", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)

        
        
  
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonCreate.backgroundColor = UIColor(hexString: "#dcdce0")
        buttonCreate.setTitle("Зарегистрироваться", for: .normal)
        buttonCreate.isEnabled = false
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonCreate)

        imageUser.frame = CGRect(x: (view.frame.width-201)/2, y: (view.frame.height/6-60), width: 201, height: 40)
        imageUser.image = UIImage(named: "logo_white")

        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 40)
        labelTextMain.text = "Регистрация"
        labelTextMain.numberOfLines = 1
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont(name: K.fontBold, size: 30)
//        labelTextMain.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 10, width: 300, height: 50)
        labelTextDesc.text = "Шаг 2 из 2 \nЗаполните все поля"
        labelTextDesc.numberOfLines = 2
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont(name: K.fontRegular, size: 15)
        labelTextDesc.textColor = UIColor(hexString: "#9f9fa6")
//        labelTextDesc.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(labelTextDesc)

        
        editorMail.frame = CGRect(x: 16 , y: labelTextDesc.frame.maxY + 35, width: view.frame.width - (16*2), height: 60)
        
        editorMail.backgroundColor = .white
        editorMail.attributedPlaceholder = textPlaceholder
        editorMail.placeholder  = "E-mail"
        editorMail.keyboardType = .emailAddress
        editorMail.clearButtonMode = .whileEditing
        editorMail.autocorrectionType = .no
        view.addSubview(editorMail)

        view.addSubview(lineBorder(y: editorMail.frame.maxY))
        
        editorPassword.frame = CGRect(x: 16 , y: editorMail.frame.maxY+2, width: view.frame.width - (16*2), height: 60)
        
        editorPassword.backgroundColor = .white
        editorPassword.attributedPlaceholder = textPlaceholder
        editorPassword.placeholder  = "Пароль"
//        editorNameF.keyboardType = .numberPad
        editorPassword.clearButtonMode = .whileEditing
        editorPassword.autocorrectionType = .no
        editorPassword.isSecureTextEntry = true
        view.addSubview(editorPassword)
        view.addSubview(lineBorder(y: editorPassword.frame.maxY))
        
        
        let viewCheckView = UIView(frame: CGRect(x: 26, y: editorPassword.frame.maxY+2, width: view.frame.width, height: 80))
        
        view.addSubview(viewCheckView)
        
        
        
        checkBox.frame = CGRect(x: 0, y: 20, width: 22, height: 22)
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#478ECC")]

        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#989898")]

        let attributedString1 = NSMutableAttributedString(string:"Пользовательского соглашения", attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:"Я ознакомлен и согласен с условиями \n", attributes:attrs2)

        attributedString2.append(attributedString1)
        
        
        
        labelAgree.frame = CGRect(x: 36, y: 10, width: view.frame.width - (40*2), height: 40)
        
//        labelAgree.text = "Я ознакомлен и согласен с условиями \nПользовательского соглашения"
        labelAgree.attributedText = attributedString2
        labelAgree.font = UIFont(name: K.fontRegular, size: 13)
        labelAgree.numberOfLines = 2
//        labelAgree.textColor = UIColor(hexString: "#478ECC")
        labelAgree.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOffer))
        labelAgree.addGestureRecognizer(guestureRecognizer)
        viewCheckView.addSubview(labelAgree)
        viewCheckView.addSubview(checkBox)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkBox.addGestureRecognizer(gesture)
    
        
        editorMail.delegate = self
        editorPassword.delegate = self
        
        
 
        
    }
    
    @objc func didTapCheckBox () {
        checkBoxState = checkBox.setChecked()
        enableButtonNext ()
        
      
    }
    
    @objc func openOffer () {
        let url = URL(string: "https://shi-ku.ru/legal/rules/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
    
    func enableButtonNext () {
        if nextFlag && checkBoxState {
            self.buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
            self.buttonCreate.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.buttonCreate.backgroundColor = UIColor(hexString: "#dcdce0")
            self.buttonCreate.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        
        if (editorMail.text == "" || editorPassword.text == "")   {

            nextFlag = false
        } else  {

            nextFlag = true
        }
//        self.buttonCreate.backgroundColor = UIColor(hexString: colorB)
        enableButtonNext ()
    }
    
    func lineBorder (y: CGFloat) -> UIView {
        
        let lineView = UIView(frame: CGRect(x: 16, y: y + 1, width: view.frame.width - (16*2), height: 0.6))
        lineView.layer.borderWidth = 0.6
        lineView.layer.borderColor = UIColor(hexString: "#3C3C43", alpha: 0.3).cgColor
        
        return lineView
    }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didTapNext() {
        

        mailRegLet = editorMail.text
        let phoneRegLet = "0"
        passRegLet = editorPassword.text!.sha512
        let groupLet = (selectedCountryID != nil) ? String(selectedCountryID) : ""

            registerManager.performRequest(nameRegLet: nameRegLet, loginRegLet: loginRegLet, mailRegLet: mailRegLet, phoneRegLet: phoneRegLet, passRegLet: passRegLet, groupLet: groupLet)
        
        if (delegateApp.divToken != nil) {
        loginManager.performAddDev(loginLet: loginRegLet, id: delegateApp.divToken)
        }
        
    }
    
    @objc func refresh () {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifAddTopic"), object: nil)
    }

    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
        self.navigationItem.rightBarButtonItem?.isEnabled = nextFlag
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.navigationItem.rightBarButtonItem = nil

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
    
}



extension RegisterController1: RegisterManagerDelegate {
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
                self.loginManager.performLogin(loginRegLet: self.loginRegLet!, passRegLet: self.editorPassword.text!.sha512)
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

extension RegisterController1: LoginManagerDelegate {
    

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
                K.userPass = self.editorPassword.text!.sha512
                self.typeAction(user: login.login, pass: self.editorPassword.text!.sha512)
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
    var imageMail: URL!
    let buttonExit = UIButton()
    
override func viewDidLoad() {
    super.viewDidLoad()
    
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
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshMail), name: NSNotification.Name(rawValue: "newDataNotifMaill"), object: nil)
    

//    let buttonBack = UIButton(type: .system)
//    buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//    buttonBack.setTitle("Назад", for: .normal)
//    buttonBack.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
//    buttonBack.sizeToFit()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)

    
    
    let buttonBack = UIButton()
    buttonBack.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
    buttonBack.backgroundColor = UIColor(hexString: "#E77373")
    buttonBack.setTitle("Новая регистрация", for: .normal)
    buttonBack.layer.cornerRadius = 8
    buttonBack.layer.borderWidth = 0
    buttonBack.addTarget(self, action: #selector(didTapBack), for: UIControl.Event.touchUpInside)
    
    
    
    
    let buttonNext = UIButton(type: .system)
    buttonNext.setTitle("Далее", for: .normal)
    buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    buttonNext.sizeToFit()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)

    
    
    let buttonCreate = UIButton()
    buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
    buttonCreate.backgroundColor = UIColor(hexString: "#00be0a")
    buttonCreate.setTitle("Продолжить", for: .normal)
    buttonCreate.layer.cornerRadius = 8
    buttonCreate.layer.borderWidth = 0
    buttonCreate.addTarget(self, action: #selector(didTapNext), for: UIControl.Event.touchUpInside)
//        buttonCreate.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
    if K.mailCheck {
        
        view.addSubview(buttonCreate)
        imageMail = URL(string:  "https://shi-ku.ru/img/mail_check_green.png")!
        labelTextMain.text = "Почта подтверждена!"
        labelTextDesc.isHidden = true
        buttonExit.isHidden = true
    }
    else {
        imageMail = URL(string:  "https://shi-ku.ru/img/mail_check_blue.png")!
        labelTextMain.text = "Проверка почты"
        labelTextDesc.text = "На указанный почтотвый ящик направлено письмо для подтверждения адреса. После подтверждения фунционал приложение станет доступен."
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.didTapNext), userInfo: nil, repeats: true)
        view.addSubview(buttonBack)
    }

//    buttonExit.frame = CGRect(x: 10, y: 63, width: 70, height: 14)
////        buttonExit.backgroundColor = UIColor(hexString: "#478ECC")
//    buttonExit.setTitle("Новая регистрация", for: .normal)
////        buttonExit.tintColor = .systemBlue
//    buttonExit.setTitleColor(.systemBlue,
//                            for: .normal)
//
////        buttonExit.layer.cornerRadius = 8
////        buttonExit.layer.borderWidth = 0
//    buttonExit.addTarget(self, action: #selector(didTapBack), for: UIControl.Event.touchUpInside)
////        buttonCreate.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
////        buttonCreate.layer.borderColor = UIColor.black.cgColor

//    view.addSubview(buttonExit)

    imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/4)-80, width: 160, height: 132)
    let url = imageMail
    
    
    DispatchQueue.global().async {
        // Fetch Image Data
        if let data = try? Data(contentsOf: url!) {
            DispatchQueue.main.async {
                // Create Image and Update Image View
                self.imageUser.image = UIImage(data: data)
                self.imageUser.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
//                    imageMail.isHidden =  false
                    self.imageUser.alpha = 1
                 })
            }
        }
    }
    

    view.addSubview(imageUser)
    
    labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 80)
//    labelTextMain.text = "Проверка почты"
    labelTextMain.numberOfLines = 2
    labelTextMain.textAlignment = .center
    labelTextMain.font = UIFont.preferredFont(forTextStyle: .title1)
    view.addSubview(labelTextMain)
    

    
    labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 20, width: 300, height: 120)

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
        let vc = LoginController()       
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
//        self.dismiss(animated: true)
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
    @objc func refreshMail() {

        self.viewDidLoad()
        self.timer.invalidate()
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
//            view.addSubview(viewMain)
        }
        

        
        DispatchQueue.main.async { [self] in
            if (login.status) == 1 {
              self.timer.invalidate()
//                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
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


extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
