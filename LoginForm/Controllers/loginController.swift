//
//  LoginController.swift
//  LoginForm
//
//  Created by 08395593 on 02.09.2021.
//

import Foundation
import UIKit
import CoreData
import LocalAuthentication
import AppTrackingTransparency



class LoginController: UIViewController, UITextFieldDelegate {
    
    
    var labelName = UILabel()
    var imageUser = UIImageView()
    
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    
    var editorLogin = UITextField()
    var editorPassword = UITextField()

    let buttonLogin = UIButton()
    let buttonRegistration = UIButton()
    let buttonNext = UIButton(type: .system)
    var nextFlag: Bool = false
    var nameRegLet: String = ""
    var loginRegLet: String = ""
    let nav1 = UINavigationController()
    
    let tabBarVC = UITabBarController()
    let user: String! = nil
    let group: Int! = nil
    var idSeance: Int! = nil
    var resetCoredata: Bool! = nil
    let viewMain = UIView()
    var contextIdent = LAContext()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemTimeArray = [Login]()
    
    enum AuthenticationState {
        case loggedin, loggedout, loggedHand, loggedYes
    }
    
    var state = AuthenticationState.loggedout {
        didSet {
            print("LoginBIO")
        }
    }
    
    var loginManager = LoginManager()
    var activeUserManager = ActiveUserManager()
    
    let delegateApp = UIApplication.shared.delegate as! AppDelegate
    


    override func viewDidLoad() {
        super.viewDidLoad()
        activeUserManager.delegate = self
        loginManager.delegate = self
        loadItems()
        
        viewMain.frame = view.frame
        viewMain.backgroundColor = .white
        view.addSubview(viewMain)
        
        if itemTimeArray.count == 0  {
            self.view.layoutIfNeeded()
            state = .loggedout
            buttonLogin.isEnabled = false
            buttonLogin.backgroundColor = UIColor(hexString: "#dcdce0")
            self.buttonLogin.setTitle("Вход", for: .normal)
        } else {
            self.buttonLogin.backgroundColor = UIColor(hexString: "#478ECC")
            self.editorPassword.isEnabled = false
            self.editorLogin.isEnabled = false
            self.buttonLogin.isEnabled = true
//            self.buttonReg.isHidden  = true
//            self.fieldLogin.isEditing = false
//            self.fieldPass.isEditing = false
            
            if itemTimeArray[0].pass!.count < 30 {
                state = .loggedYes
                let icon = UIImage(systemName: biometricType())!

    //            buttonLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                buttonLogin.setTitle("", for: .normal)
                buttonLogin.setImage(icon, for: .normal)
                buttonLogin.tintColor = .white
                let user = itemTimeArray[0].user
                let pass = itemTimeArray[0].pass!.sha512
                
                self.deleteAllData(entity: "Login")
                self.typeAction(user: user!, pass: pass)
                K.userPass = itemTimeArray[0].pass!
                loginManager.performLogin(loginRegLet: user!, passRegLet: pass)
            } else {
            
            state = .loggedYes
            let icon = UIImage(systemName: biometricType())!
//                self.resetCoredata = false
//            buttonLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                
//            buttonLogin.setTitle("", for: .normal)
            buttonLogin.setImage(icon, for: .normal)
            buttonLogin.tintColor = .white
//            buttonLogin.image(for: )
                K.userPass = itemTimeArray[0].pass!
            loginManager.performLogin(loginRegLet: itemTimeArray[0].user!, passRegLet: itemTimeArray[0].pass!)
            }
        }
        
    
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let textPlaceholder = NSAttributedString(string: "11", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3C3C43", alpha: 0.3), NSAttributedString.Key.font: UIFont(name: K.fontLight, size: 17)!])
        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        view.addSubview(labelName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
  
//        let navBar = UINavigationController(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
      

        
        
      
//        view.addSubview(buttonBack)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        
        buttonNext.setImage(UIImage(systemName: "chevron.next"), for: .normal)
        buttonNext.setTitle("Далее", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()

        
        
        self.navigationItem.rightBarButtonItem = nil
        
        
       
        

        editorPassword.delegate = self
        editorLogin.delegate = self
     
        buttonLogin.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        
//        buttonLogin.backgroundColor = UIColor(hexString: "#dcdce0")
        buttonLogin.setTitle("Войти", for: .normal)
        buttonLogin.layer.cornerRadius = 8
        buttonLogin.layer.borderWidth = 0
        buttonLogin.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        view.addSubview(buttonLogin)

        imageUser.frame = CGRect(x: (view.frame.width-201)/2, y: (view.frame.height/6), width: 201, height: 40)
        imageUser.image = UIImage(named: "logo_white")
        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 40)
        labelTextMain.text = "Авторизация"
        labelTextMain.numberOfLines = 1
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont(name: K.fontBold, size: 30)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 10, width: 300, height: 50)
        labelTextDesc.text = "С возвращением, \nвойдите в свой аккаунт"
        labelTextDesc.numberOfLines = 2
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont(name: K.fontRegular, size: 15)
        labelTextDesc.textColor = UIColor(hexString: "#9f9fa6")
        view.addSubview(labelTextDesc)

        
        editorLogin.frame = CGRect(x: 16 , y: labelTextDesc.frame.maxY + 35, width: view.frame.width - (16*2), height: 60)
        
        editorLogin.backgroundColor = .white
        editorLogin.attributedPlaceholder = textPlaceholder
        editorLogin.placeholder  = "Логин (ТН)"
        editorLogin.clearButtonMode = .whileEditing
        view.addSubview(editorLogin)

        view.addSubview(lineBorder(y: editorLogin.frame.maxY))
        
        editorPassword.frame = CGRect(x: 16 , y: editorLogin.frame.maxY+2, width: view.frame.width - (16*2), height: 60)
        
        editorPassword.backgroundColor = .white
        editorPassword.attributedPlaceholder = textPlaceholder
        editorPassword.placeholder  = "Пароль"
        editorPassword.isSecureTextEntry = true
//        editorNameF.keyboardType = .numberPad
        editorPassword.clearButtonMode = .whileEditing
        view.addSubview(editorPassword)
        view.addSubview(lineBorder(y: editorPassword.frame.maxY))
        
        
        buttonRegistration.frame = CGRect(x: (view.frame.width/2) - (338/2), y: buttonLogin.frame.maxY + 20, width: 338, height: 30)
//        buttonRegistration.isEnabled = false
        buttonRegistration.setTitleColor(UIColor(hexString: "#478ECC"), for: .normal)
        buttonRegistration.titleLabel?.font =  UIFont(name: K.fontBold, size: 15)
        buttonRegistration.setTitle("Регистрация", for: .normal)
        buttonRegistration.backgroundColor = UIColor(hexString: "#FFFFFF")

        buttonRegistration.addTarget(self, action: #selector(registrationNext), for: .touchUpInside)
        view.addSubview(buttonRegistration)
        

          
        
    }
    
    
    func requestTrackingAuthorization() {
        guard #available(iOS 14, *) else { return }
        ATTrackingManager.requestTrackingAuthorization { _ in
            DispatchQueue.main.async { [weak self] in
                // self?.router.close() or nothing to do
            }
        }
    }
    
    func biometricType() -> String {
      let _ = contextIdent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch contextIdent.biometryType {
      case .none:
        return "textformat.123"
      case .touchID:
        return "touchid"
      case .faceID:
        return "faceid"
      @unknown default:
        return "textformat.123"
      }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        
        if (editorLogin.text == "" || editorPassword.text == "") && itemTimeArray.count == 0  {
            self.buttonLogin.backgroundColor = UIColor(hexString: "#dcdce0")
            self.buttonLogin.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            nextFlag = false
        } else  {
            self.buttonLogin.backgroundColor = UIColor(hexString: "#478ECC")
            self.buttonLogin.isEnabled = true
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
        
        setLoadingScreen()
        
        let loginRegLet = editorLogin.text!
        let passRegLet = editorPassword.text!.sha512
//        print(fieldPass.text!.sha512)
        view.endEditing(true)
//        print(delegateApp.divToken)
        if (delegateApp.divToken != nil) {
        loginManager.performAddDev(loginLet: loginRegLet, id: delegateApp.divToken)
        }
        
        if itemTimeArray.count == 0  {
//            self.resetCoredata = true
            state = .loggedout
            K.userPass = passRegLet
            loginManager.performLogin(loginRegLet: loginRegLet, passRegLet: passRegLet)
        } else {
//            self.resetCoredata = false
            state = .loggedYes
            K.userPass = itemTimeArray[0].pass!
            loginManager.performLogin(loginRegLet: itemTimeArray[0].user!, passRegLet: itemTimeArray[0].pass!)
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
    
    @objc func registrationNext () {
        let vc = RegisterController()
        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .automatic
        present(navController, animated: true, completion: nil)
    }
    
    
    @IBAction func singleCheckboxAction(_ sender: UIButton){
        sender.checkboxAnimation {
            print("I'm done")
            print(sender.isSelected)
            
        }
    }
    
    
    
    func loadItems() {
        let request : NSFetchRequest<Login> = Login.fetchRequest()
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
    }
    
    func typeAction(user: String, pass: String) {
        let newItem = Login(context: self.context)
        newItem.user = user
        newItem.pass = pass
        self.itemTimeArray.append(newItem)
        self.saveItems()
    }
    
    

    
    
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner

        let x = (buttonLogin.frame.width / 2)
        let y = (buttonLogin.frame.height / 2)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: x, y: y, width: 0, height: 0)
        spinner.color = .white
        spinner.startAnimating()
        buttonLogin.setTitle("", for: .normal)
        // Adds text and spinner to the view
        buttonLogin.addSubview(spinner)
//        loadingView.addSubview(loadingLabel)

//        buttonLogin.addSubview(loadingView)

    }
    
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        buttonLogin.setTitle("Войти", for: .normal)

    }
    
}


extension LoginController: LoginManagerDelegate {
    

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
//            K.userPass = self.fieldPass.text!.sha512
            if K.idGroupProfile == 0
            {
                let vc = NoGroup()
        //        let navController = UINavigationController(rootViewController: vc)
        //        navController.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
            
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let newViewController = storyboard.instantiateViewController(withIdentifier: "Table") as? tableController {
                newViewController.firstName = K.userName
                newViewController.user = K.userLogin
                newViewController.group = K.idGroupProfile
                newViewController.resetCoredata = true
                newViewController.userAction = K.userLogin
                newViewController.idSeance = nil
                activeUserManager.performActiveUserSeance(loginLet: login.login, action: 2)
                let navController = UINavigationController(rootViewController: newViewController)
                navController.modalTransitionStyle = .flipHorizontal
                navController.modalPresentationStyle = .overFullScreen
                self.present(navController, animated: true, completion: showViewMain)
                
                
                 }
               }
        }
        
        func showViewMain() {
            view.addSubview(viewMain)
        }
        
        func mainIdetn() {


//            self.contextIdent.localizedCancelTitle = "Ввести логин и пароль"

            // First check if we have the needed hardware support.
            var error: NSError?
            if self.contextIdent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Войти в учетную запись"
                self.contextIdent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                    if success {

                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async {
//                            self.state = .loggedHand
                            openMainController()

                        }

                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        self.state = .loggedHand
//                        self.deleteAllData(entity: "Login")
                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                self.state = .loggedHand
                self.deleteAllData(entity: "Login")
                // Fall back to a asking for username and password.
                // ...
            }
        }
        
        DispatchQueue.main.async { [self] in
            self.removeLoadingScreen()
//            print(login.status)
//            self.name = login.firstName
//            mainIdetn()
            
            if (login.status) == 1 {

               
                if self.state == .loggedout {
                    self.typeAction(user: self.editorLogin.text!, pass: self.editorPassword.text!.sha512)
                    openMainController()
//                    mainIdetn()
                }
                else if self.state == .loggedYes {
                    mainIdetn()
                }
                else if self.state ==  .loggedHand {
                    self.deleteAllData(entity: "Login")
//                    self.typeAction(user: self.fieldLogin.text!, pass: self.fieldPass.text!.sha512)
                    openMainController()
                }
            }
            else if (login.status) == 2 {
                
                K.userName = login.firstName
                K.userLogin = login.login
                K.idGroupProfile =  login.group
                K.numberOfRowsProfilGroup = []
                K.groupName = login.groupName
                K.urlTabBar = nil
                K.teamLeader = login.TL
                self.typeAction(user: K.userLogin, pass: K.userPass)
//                K.userPass = self.fieldPass.text!.sha512
                
                let vc = NoCheck()
        //        let navController = UINavigationController(rootViewController: vc)
        //        navController.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                
                
            }
            
            else {
                let alert = UIAlertController(title: "Информация", message: "Проверьте логин/пароль", preferredStyle: UIAlertController.Style.alert)
                buttonLogin.setTitle("Вход", for: .normal)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

}
extension LoginController: ActiveUserManagerDelegate {
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser]) {
        
    }
    
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin]) {
        
    }
    
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate) {
    
    }
    
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser) {

        MyVariables.yourVariable = content.seanceID
    }
    
    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
}

