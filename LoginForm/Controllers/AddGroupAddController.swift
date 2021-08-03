//
//  AddGroupAddController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 05.04.2021.
//

import UIKit

var firstLoad: Bool = false




class AddGroupAddController: UIViewController {
    
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
        buttonCreate.setTitle("Создать группу", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonCreate)

        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/4)-80, width: 160, height: 160)
        let url = URL(string:  "https://shi-ku.ru/img/team_persone.png")
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
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 40)
        labelTextMain.text = "Зачем нужна группа?"
        labelTextMain.textAlignment = .center
        labelTextMain.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(labelTextMain)
        
        labelTextDesc.frame = CGRect(x: (view.frame.width-300)/2 , y: labelTextMain.frame.maxY + 20, width: 300, height: 80)
        labelTextDesc.text = "Группа позволит организовать удобную работу с большим количеством пользователей."
        labelTextDesc.numberOfLines = 3
        labelTextDesc.textAlignment = .center
        labelTextDesc.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(labelTextDesc)

        
    }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didTapNext() {

        let vc = AddGroupAddController1()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overCurrentContext
//        self.dismiss(animated: true)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func refresh () {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}


class AddGroupAddController1: UIViewController, AddGroupAddControllerJSONDelegate {

    

    
    
    var labelName = UILabel()
    var viewMain = UIView()
    var editorNameGroup = UITextField()
    var viewDescGroup = UIView()
    var viewDescGroupPading = UIView()
    var editorDescGroup = UITextView()
    var dismisBool: Bool!
    var viewAll = UIView()
    var scrollView = UIScrollView()
    var textLabelDesc = UILabel()
    let buttonCreate = UIButton()
    var addGroupAddControllerJSON = AddGroupAddControllerJSON()
    var alertCustom = AlertCustom()

    
    var heightKeyboard: CGFloat = 0
    
    var firstLoad: Bool = false
    var flagKeybord: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Создать группу"
        
        addGroupAddControllerJSON.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = UIColor(hexString: "#F1F1F2")

        
        let yNav = (navigationController?.navigationBar.frame.maxY)!
        
        scrollView.frame = CGRect(x: 0, y: yNav  + 13, width: view.frame.width, height: view.frame.height)
//        scrollView.frame = view.frame

                //Название группы
                viewMain.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: yNav * 2.5)
                viewMain.backgroundColor = .white
                editorNameGroup.frame = CGRect(x: 20, y: (viewMain.frame.height/2)-(30/2), width: viewMain.frame.width - 40, height: 30)
                editorNameGroup.backgroundColor = .white
                editorNameGroup.placeholder  = "Название группы"
                editorNameGroup.clearButtonMode = .whileEditing
                viewMain.addSubview(editorNameGroup)
                //
  
   
        
                //Описание группы
                viewDescGroup.frame = CGRect(x: 0, y: viewMain.frame.maxY + yNav - 5 , width: viewMain.frame.width, height: 40)
                viewDescGroup.backgroundColor = .white
                viewDescGroupPading.frame = CGRect(x: 20, y: 0 , width: viewMain.frame.width-40, height: 30)
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
                editorDescGroup.text = "Описание"
                editorDescGroup.textColor = UIColor(hexString: "#C9C9C9")
                editorDescGroup.font = UIFont.preferredFont(forTextStyle: .body)
                editorDescGroup.delegate = self
                textViewDidChange(editorDescGroup)
                //
        
                textLabelDesc.frame = CGRect(x: 23, y: editorDescGroup.frame.maxY  + 5, width: viewMain.frame.width-46, height: 38)
                textLabelDesc.numberOfLines = 2
                textLabelDesc.font = textLabelDesc.font.withSize(13)
                textLabelDesc.text = "Можете указать допольнительное описание для  Вашей группы"
                textLabelDesc.textColor = UIColor(hexString: "#787878")
                viewDescGroup.addSubview(textLabelDesc)
        
        view.addSubview(scrollView)
        scrollView.addSubview(viewMain)
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
 
        view.addSubview(buttonCreate)
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if editorDescGroup.textColor == UIColor(hexString: "#C9C9C9") {
            editorDescGroup.text = nil
            editorDescGroup.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if editorDescGroup.text.isEmpty {
            editorDescGroup.text = "Описание"
            editorDescGroup.textColor = UIColor(hexString: "#C9C9C9")
        }
    }
    

    @objc func keyboardWillShow(_ notification: NSNotification) {
print(flagKeybord)



                let buttonNext = UIButton(type: .system)
                buttonNext.setTitle("Готово", for: .normal)
                buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
                buttonNext.sizeToFit()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
            if flagKeybord  ==  false {
                buttonCreate.isHidden = true
            }



    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        

        if  flagKeybord  {
        self.navigationItem.rightBarButtonItem = nil
            buttonCreate.isHidden = false
           
        }
        else {
            buttonCreate.isHidden = true
        }

    }
    
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
       
    }
    @objc func didTapNext() {
//        self.dismiss(animated: true)
//        let vc = AddGroupAddController2()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
//        navController.modalPresentationStyle = .overCurrentContext
//        present(navController, animated: true, completion: nil)
//        self.dismiss(animated: true)
        var modEditorDescGroup: String!
        if editorDescGroup.text == "Описание" {
            modEditorDescGroup = ""
        } else {
            modEditorDescGroup = editorDescGroup.text
        }

        self.addGroupAddControllerJSON.performAddGroupUser(loginLet: K.userLogin, nameGroup: editorNameGroup.text!, descGroup: modEditorDescGroup!)
       
    }
    
    func didAddGroup(_ Content: AddGroupAddControllerJSON, content: String) {
       print(content)
        DispatchQueue.main.async {
            if (content == "Группа успешно создана!") {
                self.alertCustom.showAlertOkView(main: "Готово!", second: content, control: self, dismissView: false, notificcationStr: "newDataNotifGroup")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifUpdateGroupUser"), object: nil)
              
            } else {
                self.alertCustom.showAlertOkView(main: "Внимание!", second: content, control: self, dismissView: false, notificcationStr: nil)
            }
        }
    }

}


extension AddGroupAddController1: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        let size = CGSize(width: editorDescGroup.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {

                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    constraint.constant = estimatedSize.height
                    self.editorDescGroup.frame.size.height = estimatedSize.height
                    self.viewDescGroup.frame.size.height = estimatedSize.height
                    if self.firstLoad {
                        self.textLabelDesc.frame = CGRect(x: 23, y: self.editorDescGroup.frame.maxY  + 5, width: self.viewMain.frame.width-46, height: 38)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.editorDescGroup.frame.height + self.viewDescGroup.frame.minY +  self.textLabelDesc.frame.height )
                        let maxText = 100+self.editorDescGroup.frame.height + self.viewDescGroup.frame.minY +  self.textLabelDesc.frame.height
                        let minButtomGreate = self.buttonCreate.frame.minY
                        print(maxText, minButtomGreate)
                        self.flagKeybord = maxText < minButtomGreate
                    }
               })
                self.firstLoad = true
            }
        }
    }
    
}



class AddGroupAddController2: UIViewController {
    
    var labelName = UILabel()
    var  addGroupAddController = AddGroupAddController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        labelName.text = "Привет МИР!"
        view.addSubview(labelName)
        // Do any additional setup after loading the view.
        

  
        let buttonBack = UIButton(type: .system)
        buttonBack.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        buttonBack.setTitle("Назад", for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        buttonBack.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)

        
        
        let buttonNext = UIButton(type: .system)
        buttonNext.setTitle("Готово", for: .normal)
        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonNext.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
        
    }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didTapNext() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
    }
    

}


//MARK: Взаимодействие с сервером
struct AddGroupUser: Codable {
    var statusAddGroup: String
}


protocol AddGroupAddControllerJSONDelegate {
    func didAddGroup(_ Content: AddGroupAddControllerJSON, content: String)
}

struct AddGroupAddControllerJSON {

    var delegate: AddGroupAddControllerJSONDelegate?


func performAddGroupUser (loginLet: String, nameGroup: String, descGroup: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/add_group_user/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\", \"GROUP\": \"\(nameGroup)\", \"DESC\": \"\(descGroup)\"}".data(using: .utf8)!;
//print(" { \"USER\": \"\(loginLet)\", \"GROUP\": \"\(nameGroup)\", \"DESC\": \"\(descGroup)\"}")
    // Set HTTP Request Body
    request.httpBody = postString;
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        if let safeData = data {
            if let login = self.parseJSONAddGroupUser(safeData) {
                self.delegate?.didAddGroup(self, content: login)
            }
        }
    }
    task.resume()
    }

    func parseJSONAddGroupUser(_ responceData: Data) -> String? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(AddGroupUser.self, from: responceData)
            let statusAdd = decoderData.statusAddGroup
            return statusAdd
        } catch {
            return nil
        }
    }
}
