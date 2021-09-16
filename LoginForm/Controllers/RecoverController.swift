//
//  RecoverController.swift
//  RecoverController
//
//  Created by 08395593 on 14.09.2021.
//

import Foundation
import UIKit

class RecoverController: UIViewController, UITextFieldDelegate{
    
    
    var labelName = UILabel()
    var imageUser = UIImageView()
    
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()
    
    var editorMail = UITextField()
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
        
        
        editorMail.delegate = self
     
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonCreate.isEnabled = false
        buttonCreate.backgroundColor = UIColor(hexString: "#dcdce0")
        buttonCreate.setTitle("Продолжить", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        view.addSubview(buttonCreate)

//        imageUser.frame = CGRect(x: (view.frame.width-201)/2, y: (view.frame.height/6-60), width: 201, height: 40)
//        imageUser.image = UIImage(named: "logo_white")
//        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: (view.frame.height/6-60), width: 300, height: 40)
        labelTextMain.text = "Забыли пароль?"
        labelTextMain.numberOfLines = 1
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont(name: K.fontBold, size: 30)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 10, width: 300, height: 50)
        labelTextDesc.text = "Пришлем ссылку для восстановления на электронную почту"
        labelTextDesc.numberOfLines = 2
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont(name: K.fontRegular, size: 15)
        labelTextDesc.textColor = UIColor(hexString: "#9f9fa6")
        view.addSubview(labelTextDesc)

        
        editorMail.frame = CGRect(x: 16 , y: labelTextDesc.frame.maxY + 45, width: view.frame.width - (16*2), height: 60)
        
        editorMail.backgroundColor = .white
        editorMail.attributedPlaceholder = textPlaceholder
        editorMail.placeholder  = "E-mail"
        editorMail.clearButtonMode = .whileEditing
        editorMail.autocorrectionType = .no
        view.addSubview(editorMail)

        view.addSubview(lineBorder(y: editorMail.frame.maxY))
        

        
    }
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        
        if editorMail.text == ""   {
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
//        self.nameRegLet = editorName.text! + " " + editorNameF.text!
//        self.loginRegLet = editorLogin.text!
//        let vc = RegisterController1()
//        vc.nameRegLet = editorName.text! + " " + editorNameF.text!
//        vc.loginRegLet = editorLogin.text!
//        let navController = UINavigationController(rootViewController: vc)
//       
//        navController.modalTransitionStyle = .crossDissolve
//        navController.modalPresentationStyle = .overCurrentContext
////        self.dismiss(animated: true)
//        present(navController, animated: true, completion: nil)
        
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
