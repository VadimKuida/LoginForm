//
//  AddNewStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 13.05.2021.
//

import Foundation
import UIKit


private var firstLoadNewTopic: Bool = false
private let tableViewAddTopic = UITableView()

private var valNameTopic: String!
private var valNameGroup: String!
private var valDescTopic: String!
private var countMinTopic: String!
private var countDayTopic: String!


class AddNewStepController: UIViewController {
    
    
    var labelName = UILabel()
    var imageUser = UIImageView()
    
    var labelTextMain = UILabel()
    var labelTextDesc = UILabel()



    override func viewDidLoad() {
        super.viewDidLoad()
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
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)

        
        
        let buttonNext = UIButton(type: .system)
        buttonNext.setTitle("Далее", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)

        
        
        let buttonCreate = UIButton()
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)
        buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
        buttonCreate.setTitle("Создать шаг", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonCreate)

        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/3-55), width: 160, height: 106)
        let url = URL(string:  "https://shi-ku.ru/img/new_step.png")
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.imageUser.image = UIImage(data: data)
                    loadScreen.removeLoadingScreen()
                    self.imageUser.alpha = 0
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
//                        imageUser.isHidden =  false
                        self.imageUser.alpha = 1
                     })
                }
            }
        }
        view.addSubview(imageUser)
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 80)
        labelTextMain.text = "Создание шага к замеру"
        labelTextMain.numberOfLines = 2
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 20, width: 300, height: 80)
        labelTextDesc.text = ""
        labelTextDesc.numberOfLines = 3
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(labelTextDesc)

        
    }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didTapNext() {
        
        let vc = AddNewStepController1()
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

}


class AddNewStepController1: UIViewController, UITableViewDelegate,  UITextFieldDelegate {
    
    var labelName = UILabel()
    var viewMain = UIView()
    var viewGroup = UIView()
    var editorNameGroup = UITextField()
    var viewDescGroup = UIView()
    var viewDescGroupPading = UIView()
    var editorDescGroup = UITextView()
    var dismisBool: Bool!
    var viewAll = UIView()
    var scrollView = UIScrollView()
    var textLabelDesc = UILabel()
    let buttonCreate = UIButton()
    var dropSerche = UITextField()
    let buttonAddGroup = UIButton()

    var imageIconValAdd: UIImage! = nil
    
    var heightKeyboard: CGFloat = 0
    
    var firstLoadNewTopic: Bool = false
    var flagKeybord: Bool = true
    
    var txtName = UITextField()
    
    var originalArr = [[String:Any]]();
    var searchArrRes = [[String:Any]]()
    var searching:Bool = false
    var contentStepManager = ContentStepManager()
    var loadFormFlag: Int = 0
    var stepIDVal: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        contentStepManager.delegate = self
        self.title = "Создать новый шаг"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = UIColor(hexString: "#F1F1F2")
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
        let yNav = (navigationController?.navigationBar.frame.maxY)!
        
        
                let buttonNext = UIButton(type: .system)
        if  loadFormFlag == 0 {
            buttonNext.setTitle("Сохранить", for: .normal)
        } else {
            buttonNext.setTitle("Обновить", for: .normal)
        }
                
                buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
                buttonNext.sizeToFit()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
        
                scrollView.frame = CGRect(x: 0, y: yNav  + 13, width: view.frame.width, height: view.frame.height)
//       scrollView.frame = view.frame

                //Название группы
                viewMain.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: yNav * 2.5)
                viewMain.backgroundColor = .white
                editorNameGroup.frame = CGRect(x: 20, y: (viewMain.frame.height/2)-(30/2), width: viewMain.frame.width - 40, height: 30)
                editorNameGroup.backgroundColor = .white
                editorNameGroup.placeholder  = "Название шага"
                editorNameGroup.clearButtonMode = .whileEditing
                viewMain.addSubview(editorNameGroup)
                //

        
        
                //Выбор группы
//                viewGroup.frame = CGRect(x: 0, y: viewMain.frame.maxY + yNav, width: view.frame.width, height: 40)
//                viewGroup.backgroundColor = .white
//                buttonAddGroup.frame = CGRect(x: viewGroup.frame.width - 50, y: (viewGroup.frame.height/2) - (30/2), width: 30, height: 30)
//                imageIconValAdd = (UIImage(systemName: "info.circle.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal))!
//                buttonAddGroup.setImage(imageIconValAdd, for: .normal)
//                buttonAddGroup.isHidden = true
////                buttonAddGroup.setImage((UIImage(systemName: "info.circle.fill")), for: .normal )
//
//
//                viewGroup.addSubview(buttonAddGroup)
                //
            
        
                //Описание группы
                viewDescGroup.frame = CGRect(x: 0, y: viewMain.frame.maxY + yNav  , width: viewMain.frame.width, height: 40)
                viewDescGroup.backgroundColor = .white
                viewDescGroupPading.frame = CGRect(x: 20, y: 0 , width: viewDescGroup.frame.width-40, height: 30)
                viewDescGroupPading.backgroundColor = .white
                viewDescGroup.addSubview(viewDescGroupPading)
                
                editorDescGroup.frame = CGRect(x: 0, y: 0 , width: viewDescGroupPading.frame.width, height: viewDescGroupPading.frame.height)
                editorDescGroup.backgroundColor = .white
                editorDescGroup.isScrollEnabled = true
                viewDescGroup.addSubview(editorDescGroup)
        
                editorDescGroup.translatesAutoresizingMaskIntoConstraints = false
                [
    //            print(editorDescGroup.safeAreaLayoutGuide.topAnchor)
                editorDescGroup.topAnchor.constraint(equalTo: viewDescGroupPading.safeAreaLayoutGuide.topAnchor),
                editorDescGroup.leadingAnchor.constraint(equalTo: viewDescGroupPading.leadingAnchor),
                editorDescGroup.trailingAnchor.constraint(equalTo: viewDescGroupPading.trailingAnchor),
                editorDescGroup.heightAnchor.constraint(equalToConstant: 5)
                ].forEach{ $0.isActive = true }
                if editorDescGroup.text == ""  {
                    editorDescGroup.text = "Описание начала и конца шага"
                    editorDescGroup.textColor = UIColor(hexString: "#C9C9C9")
                }
                
                
                editorDescGroup.font = UIFont.preferredFont(forTextStyle: .body)
                editorDescGroup.delegate = self
                textViewDidChange(editorDescGroup)
                //
        
                textLabelDesc.frame = CGRect(x: 23, y: editorDescGroup.frame.maxY  + 5, width: viewMain.frame.width-46, height: 57)
                textLabelDesc.numberOfLines = 3
                textLabelDesc.font = textLabelDesc.font.withSize(13)
                textLabelDesc.text = "Можете указать действия начала и конца Вашего шага, информация поможет увеличить точность замера, сформируйте текст локанично"
                textLabelDesc.textColor = UIColor(hexString: "#787878")
                viewDescGroup.addSubview(textLabelDesc)
        
        view.addSubview(scrollView)
        scrollView.addSubview(viewMain)
        scrollView.addSubview(viewGroup)
        scrollView.addSubview(viewDescGroup)
        
    
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: viewDescGroup.frame.maxY)
    

  
        let buttonBack = UIButton(type: .system)
        buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        buttonBack.setTitle("Назад", for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        buttonBack.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)

        

        
        


        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2), y: view.frame.height-(view.frame.height/4), width: 338, height: 56)

        buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
        
        buttonCreate.setTitle("Сохранить", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
//        view.addSubview(buttonCreate)
        
    }
    
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print(dropDown.text)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(dropDown.text)
//    }
    

    @objc func refresh () {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifAddStep"), object: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if editorDescGroup.textColor == UIColor(hexString: "#C9C9C9") {
            editorDescGroup.text = nil
            editorDescGroup.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if editorDescGroup.text.isEmpty {
            editorDescGroup.text = "Описание начала и конца шага"
            editorDescGroup.textColor = UIColor(hexString: "#C9C9C9")
        }
    }
    

    @objc func keyboardWillShow(_ notification: NSNotification) {


//
//                let buttonNext = UIButton(type: .system)
//                buttonNext.setTitle("Готово", for: .normal)
//                buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//                buttonNext.sizeToFit()
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
//            if flagKeybord  ==  false {
//                buttonCreate.isHidden = true
//            }



    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        

//        if  flagKeybord  {
//        self.navigationItem.rightBarButtonItem = nil
//            buttonCreate.isHidden = false
//
//        }
//        else {
//            buttonCreate.isHidden = true
//        }

    }
    
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
       
    }
    @objc func didTapNext() {
        
        valNameTopic = editorNameGroup.text

        if editorDescGroup.text == "Описание начала и конца шага" {
            valDescTopic = String("")
        } else {
            valDescTopic = editorDescGroup.text
        }
        
//        self.dismiss(animated: true)
//        countMinTopic = editorCountTopic.text
//        countDayTopic = editorDate.text
        
        contentStepManager.performAddTopicStep(groupLet: K.activeIDTopic, nameStep: editorNameGroup.text!, descStep: valDescTopic, flagLoad: loadFormFlag, stepID: stepIDVal )
//        self.dismiss(animated: true)


    }
    
    
    private func presentToast(title: String, backgroundColor: UIColor) {
        let toast = ToastViewController(title: title, backgroundColor: backgroundColor)
        present(toast, animated: true)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            toast.dismiss(animated: true)
        }
    }

}

extension AddNewStepController1: UITextViewDelegate {
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {

        let size = CGSize(width: editorDescGroup.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {

                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    constraint.constant = estimatedSize.height
                    self.editorDescGroup.frame.size.height = estimatedSize.height
                    self.viewDescGroup.frame.size.height = estimatedSize.height
                    if self.firstLoadNewTopic {
                        self.textLabelDesc.frame = CGRect(x: 23, y: self.editorDescGroup.frame.maxY  + 5, width: self.viewMain.frame.width-46, height: 57)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.editorDescGroup.frame.height + self.viewDescGroup.frame.minY +  self.textLabelDesc.frame.height )
                        let maxText = 100+self.editorDescGroup.frame.height + self.viewDescGroup.frame.minY +  self.textLabelDesc.frame.height
                        let minButtomGreate = self.buttonCreate.frame.minY
                        print(maxText, minButtomGreate)
                        self.flagKeybord = maxText < minButtomGreate
                    }
               })
               self.firstLoadNewTopic = true
            }
        }
    }
}


extension AddNewStepController1: ContentStepManagerDelegate {
    func didContentStepData(_ Content: ContentStepManager, content: [TopicStep]) {
        
    }
    
    func didAddTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        DispatchQueue.main.async {
        if  content.statusAddTopic < 3 {
            self.presentToast(title: content.statusAddTopicDisc, backgroundColor: .systemRed)
        } else {
            K.activeIDTopic = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            
        }
        }
    }
    
    func didDelTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        
    }
    
    func didActimeTime(_ Content: ContentStepManager, content: AddActiveModel) {
        
    }
    
    func didAddLocation(_ Content: ContentStepManager, content: AddLoccation) {
        
    }
    
    func didCheckFeedBack(_ Content: ContentStepManager, content: AddLoccation) {
        
    }
    
    
}
