//
//  AddNewTopicController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 09.04.2021.
//

import Foundation
import UIKit
import iOSDropDown


private var firstLoadNewTopic: Bool = false
private let tableViewAddTopic = UITableView()

private var valNameTopic: String!
private var valNameGroup: String!
private var valDescTopic: String!
private var countMinTopic: String!
private var countDayTopic: String!


class AddNewTopicController: UIViewController {
    
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
        buttonCreate.setTitle("Создать замер", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
//        buttonCreate.layer.borderColor = UIColor.black.cgColor
 
        view.addSubview(buttonCreate)

        imageUser.frame = CGRect(x: (view.frame.width-160)/2, y: (view.frame.height/3-55), width: 160, height: 107)
        view.addSubview(imageUser)
        imageUser.alpha = 0
        let url = URL(string:  "https://shi-ku.ru/img/new_topic.png")
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.imageUser.image = UIImage(data: data)
                    loadScreen.removeLoadingScreen()
                    self.imageUser.alpha = 0
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
//                        imageQR.isHidden =  false
                        self.imageUser.alpha = 1
                     })
                }
            }
        }
       
        
        labelTextMain.frame = CGRect(x: (view.frame.width-300)/2 , y: imageUser.frame.maxY + 40, width: 300, height: 40)
        labelTextMain.text = "Создание замера"
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
        
        let vc = AddNewTopicController1()
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


class AddNewTopicController1: UIViewController, UITableViewDelegate,  UITextFieldDelegate {
    
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
    let dropDown = DropDown()
    var imageIconValAdd: UIImage! = nil
    
    var heightKeyboard: CGFloat = 0
    
    var firstLoadNewTopic: Bool = false
    var flagKeybord: Bool = true
    
    var txtName = UITextField()
    
    var originalArr = [[String:Any]]();
    var searchArrRes = [[String:Any]]()
    var searching:Bool = false
    var addNewTopicController2  = AddNewTopicController2()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создать замер"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = UIColor(hexString: "#F1F1F2")
        let yNav = (navigationController?.navigationBar.frame.maxY)!
        
        
                let buttonNext = UIButton(type: .system)
                buttonNext.setTitle("Далее", for: .normal)
                buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
                buttonNext.sizeToFit()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonNext)
        
                scrollView.frame = CGRect(x: 0, y: yNav  + 13, width: view.frame.width, height: view.frame.height)
//        scrollView.frame = view.frame

                //Название группы
                viewMain.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: yNav * 2.5)
                viewMain.backgroundColor = .white
                editorNameGroup.frame = CGRect(x: 20, y: (viewMain.frame.height/2)-(30/2), width: viewMain.frame.width - 40, height: 30)
                editorNameGroup.backgroundColor = .white
                editorNameGroup.placeholder  = "Название замера"
                editorNameGroup.clearButtonMode = .whileEditing
                viewMain.addSubview(editorNameGroup)
                //

        
        
                //Выбор группы
                viewGroup.frame = CGRect(x: 0, y: viewMain.frame.maxY + yNav, width: view.frame.width, height: 40)
                viewGroup.backgroundColor = .white
                buttonAddGroup.frame = CGRect(x: viewGroup.frame.width - 50, y: (viewGroup.frame.height/2) - (30/2), width: 30, height: 30)
                imageIconValAdd = (UIImage(systemName: "info.circle.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal))!
                buttonAddGroup.setImage(imageIconValAdd, for: .normal)
                buttonAddGroup.isHidden = true
//                buttonAddGroup.setImage((UIImage(systemName: "info.circle.fill")), for: .normal )
             
        
                dropDown.frame = CGRect(x: 23, y: 0, width: viewMain.frame.width-74, height: 40) // set frame
                // The list of array to display. Can be changed dynamically
                performShowGroupTopic(loginLet: K.userLogin)
//                dropDown.optionArray = arrayNameGroup
                // Its Id Values and its optional
                dropDown.placeholder = "Название группы"
                dropDown.selectedRowColor = .white
                dropDown.arrowColor = .brown
//                dropDown.optionIds = [1,23,54,22,]
                dropDown.layer.backgroundColor = CGColor(red: 50, green: 50, blue: 50, alpha: 1)
                dropDown.layer.shadowOffset = .zero
                dropDown.layer.shadowRadius = 10
        
//                dropDown.delegate = self
//                    dropDown.countEmptyArray{(count) in
//                        if count > 0 {
//                            self.buttonAddGroup.isHidden = true
//                        } else {
//                            self.buttonAddGroup.isHidden = false
//                        }
//                    }
      
        

                viewGroup.addSubview(dropDown)
                viewGroup.addSubview(buttonAddGroup)
                //
            
        
                //Описание группы
                viewDescGroup.frame = CGRect(x: 0, y: viewGroup.frame.maxY + yNav  , width: viewGroup.frame.width, height: 40)
                viewDescGroup.backgroundColor = .white
                viewDescGroupPading.frame = CGRect(x: 20, y: 0 , width: viewGroup.frame.width-40, height: 30)
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
        
                textLabelDesc.frame = CGRect(x: 23, y: editorDescGroup.frame.maxY  + 5, width: viewGroup.frame.width-46, height: 38)
                textLabelDesc.numberOfLines = 2
                textLabelDesc.font = textLabelDesc.font.withSize(13)
                textLabelDesc.text = "Можете указать дополнительное описание для  Вашего замера"
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if dropDown.text == nil {
            self.buttonAddGroup.isHidden = false
        } else {
            self.buttonAddGroup.isHidden = true
        }
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
        valNameGroup = dropDown.text
        if editorDescGroup.text == "Описание" {
            valDescTopic = String(" ")
        } else {
            valDescTopic = editorDescGroup.text
        }
        
//        self.dismiss(animated: true)
        let vc = AddNewTopicController2()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overCurrentContext
        present(navController, animated: true, completion: nil)
//        self.dismiss(animated: true)


    }
    
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        tableViewAddTopic.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

}

struct listGroup: Decodable {
   var group: [NameGroup]
}
struct NameGroup: Decodable {
   var name: String!
}

extension AddNewTopicController1 {
    func performShowGroupTopic(loginLet: String)   {
        var arrayNameGroup: [String] = []
    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/show_list_group_topic/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER_ID\": \"\(loginLet)\"}".data(using: .utf8)!;
        print(" { \"USER_ID\": \"\(loginLet)\"}")

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
            if let login = self.parseJSONShowNameGroup(safeData) {
            login.forEach({ book in arrayNameGroup.append(book.name)})
            }
            self.dropDown.optionArray = arrayNameGroup
            print(arrayNameGroup)
        }
        
    }
        
        task.resume()
//        return arrayNameGroup
//        return login

        
    }


    func parseJSONShowNameGroup(_ responceData: Data) -> [NameGroup]? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(listGroup.self, from: responceData)
            let list = decoderData.group
            print( list)
            
            return list
        } catch {
            print(error)
            return nil
        }
    }
    
    
}

extension AddNewTopicController1: UITextViewDelegate {
    
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
                        self.textLabelDesc.frame = CGRect(x: 23, y: self.editorDescGroup.frame.maxY  + 5, width: self.viewMain.frame.width-46, height: 38)
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



class AddNewTopicController2: UIViewController {
    
    var addNewTopicController = AddNewTopicController()
    var labelName = UILabel()
    var scrollView = UIScrollView()
    
    var viewCountTopic = UIView()
    var editorCountTopic = UITextField()
    var descCountTopic = UILabel()
    
    var viewDate = UIView()
    var editorDate = UITextField()
    var descDate = UILabel()
    var buttonDate = UIButton()
    
    var viewFeedBack = UIView()
    var labelFeedBack = UILabel()
    var switchFeedBack = UISwitch()
    
    var alertCustom = AlertCustom()
    
    var contentManager = ContentManager()

    var editorDataEnd = UITextField()
    
    var typeFeedBackInt: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создать замер"
        contentManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = UIColor(hexString: "#F1F1F2")

        
        let yNav = (navigationController?.navigationBar.frame.maxY)!
        
                scrollView.frame = CGRect(x: 0, y: yNav  + 13, width: view.frame.width, height: view.frame.height)
//        scrollView.frame = view.frame

                //Число замеров
        viewCountTopic.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        viewCountTopic.backgroundColor = .white
       
        editorCountTopic.frame = CGRect(x: 20, y: (viewCountTopic.frame.height/2) - (30/2), width: viewCountTopic.frame.width - 40, height: 30)
        editorCountTopic.backgroundColor = .white
        editorCountTopic.placeholder  = "Количество замеров"
        editorCountTopic.keyboardType = .numberPad
        editorCountTopic.clearButtonMode = .whileEditing

        descCountTopic.frame = CGRect(x: 23, y: editorCountTopic.frame.maxY  + 5, width: viewCountTopic.frame.width-46, height: 38)
        descCountTopic.numberOfLines = 2
        descCountTopic.font = descCountTopic.font.withSize(13)
        descCountTopic.text = "Нужно указать количество замеров которые должен сделать пользователь"
        descCountTopic.textColor = UIColor(hexString: "#787878")
        
                
        //   Даты замера
        viewDate.frame = CGRect(x: 0, y: descCountTopic.frame.maxY + yNav, width: view.frame.width, height: 40)
        viewDate.backgroundColor = .white
       
        editorDate.frame = CGRect(x: 20, y: (viewDate.frame.height/2) - (30/2), width: viewDate.frame.width - 40, height: 30)
        editorDate.backgroundColor = .white
        editorDate.placeholder  = "Срок жизни замера"
        editorDate.clearButtonMode = .whileEditing
        editorDate.keyboardType = .numberPad

        descDate.frame = CGRect(x: 23, y: editorDate.frame.maxY  + 5, width: viewDate.frame.width-46, height: 50)
        descDate.numberOfLines = 3
        descDate.font = descDate.font.withSize(13)
        descDate.text = "В поле нужно указать количество дней, сколько замер будет активен (значение по умолчанию 31 день)"
        descDate.textColor = UIColor(hexString: "#787878")
        
        buttonDate.frame = CGRect(x: viewDate.frame.width - 50, y: (viewDate.frame.height/2) - (39/2), width: 39, height: 39)
        let imageIconVal = (UIImage(systemName: "calendar")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))!
        buttonDate.setImage(imageIconVal, for: .normal)
        buttonDate.addTarget(self, action: #selector(didShowCalendare), for: .touchUpInside)
        buttonDate.isHidden = false
        
        
        viewFeedBack.frame = CGRect(x: 0, y: viewDate.frame.maxY + yNav + descDate.frame.height , width: view.frame.width, height: 40)
        viewFeedBack.backgroundColor = .white
        
        labelFeedBack.frame = CGRect(x: 20, y: (viewFeedBack.frame.height/2) - (30/2), width: viewFeedBack.frame.width - 40, height: 30)
        labelFeedBack.backgroundColor = .white
        labelFeedBack.text  = "Форма фиксации оформления"
        
        switchFeedBack.frame = CGRect(origin: CGPoint(x: viewFeedBack.frame.width - 15 - switchFeedBack.frame.width, y: 5), size: .zero)
        switchFeedBack.addTarget(self, action: #selector(switchState(_:)), for: .valueChanged)
        switchFeedBack.setOn(true, animated: false)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(viewCountTopic)
        viewCountTopic.addSubview(editorCountTopic)
        viewCountTopic.addSubview(descCountTopic)
  
        
        scrollView.addSubview(viewDate)
        viewDate.addSubview(editorDate)
        viewDate.addSubview(descDate)
//        viewDate.addSubview(buttonDate)
        
        scrollView.addSubview(viewFeedBack)
        
        viewFeedBack.addSubview(labelFeedBack)
        viewFeedBack.addSubview(switchFeedBack)
        
        

  
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
    
    @objc func didShowCalendare () {
        
      
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyboard.instantiateViewController(withIdentifier: "CalendarCustom") as! CalendarCustom
//        let transition = PanelTransition()
        let vc = CalendarCustom()

//        vc.transitioningDelegate = transition
//        vc.modalPresentationStyle = .custom

        present(vc, animated: true)
        
    }
    
    @objc func switchState(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            typeFeedBackInt = 1
        }
        else{
            typeFeedBackInt = 0
        }
    }
    
    
    private func presentToast(title: String, backgroundColor: UIColor) {
        let toast = ToastViewController(title: title, backgroundColor: backgroundColor)
        present(toast, animated: true)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            toast.dismiss(animated: true)
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
     }
    

    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapNext() {
        
        countMinTopic = editorCountTopic.text
        countDayTopic = editorDate.text
        
        contentManager.performAddTopic(loginLet: K.userLogin, groupLet: K.idGroupProfile, nameTopic: valNameTopic, groupTopic: valNameGroup, descTopic: valDescTopic, countMinTopic: countMinTopic, countDayTopic: countDayTopic, typeFeedBack: typeFeedBackInt)
        
        

    }
}


extension AddNewTopicController2: ContentManagerDelegate {
    func didContentData(_ Content: ContentManager, content: [Sector]) {
    }
    
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel) {
        DispatchQueue.main.async {
        if  content.statusAddTopic < 3 {
            self.presentToast(title: content.statusAddTopicDisc, backgroundColor: .systemRed)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifGroup"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        }
        }
    }
    
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didContentStepDataCore(_ Content: ContentManager, content: [TopicStepCore]) {
        
    }
    
    func didSendMail(_ Content: ContentManager, content: SendMail) {
        
    }
    
    
}
