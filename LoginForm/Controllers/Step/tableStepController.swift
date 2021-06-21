//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import UserNotifications


//let child = tableStepController()


struct Record : Encodable {

}


class tableStepController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var TOPIC_NAME: String!
    var TYPE_FEEDBACK: Int!
    var idTopic: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
    var contentFix: [TopicStep] = []
    var taskList: [Task] = []
    var textCell: String!
    let vw = UIView()
    var idStepIn: Int!
    var r: Int!
    var timer = Timer()
    var countSecond = 0
    var indexRow = 0
    var localTime = Date()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemTimeArray = [Logtimer]()
    var records = [Record]()
    var stepManager = StepManager()
    var activeID: Int!
    var activeFlag: Bool = false
    let resetCoredata: Bool = false
    var valueSearchStep: String!
    var timeDeltaSumVar: Int = 0
    var countStepSumVar: Int!
    var idStepPlay: Int!
    var delRow: Int = 0
    var countSubRow: Int!
    var numberOfRows: [IndexPath] = []
    var colorSort: UIColor!
    var backMainForm: Bool!
    var selectedCellIndexPath: NSIndexPath?
    var expandedIndexSet : IndexSet = []
    
    var numberOfRowsMain: [IndexPath] = []
    
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    let locationManager = CLLocationManager()
    
    var activeFlagRunStep: Bool = false
    var activeFlagRunStep2: Bool = false
    
    var buttonPanel = UIView()
    var paddingForm = UIView()
    var buttonCreate = UIButton()
    var labelAllTime = UILabel()
    var labelAllTimeDesc = UILabel()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tableView.frame)
//        self.tableView.tableFooterView = UIView()
//        tableView.contentSize = CGSize(width: view.frame.width, height: 400)
//        tableView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 400)

        
//        buttonPanel.frame.origin = CGPoint(x: 40, y: 400) //= CGRect(x: 0, y: view.frame.height-50, width: view.frame.width, height: 50)
//        buttonPanel.frame.size = CGSize(width: 200, height: 40)
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false

        buttonPanel.backgroundColor = UIColor(hexString: "#f5f5f5")
        tableView.addSubview(buttonPanel)
        
//        buttonPanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
        buttonPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        buttonPanel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        buttonPanel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true


        buttonCreate.frame = CGRect(x: view.frame.width - 22 - 160, y: (150 / 2) - (50/2) - 20 , width: 160, height: 50)
        buttonCreate.backgroundColor = UIColor(hexString: "#868a8d")
        buttonCreate.isEnabled  = false
        buttonCreate.setTitle("Стоп", for: .normal)
//        buttonCreate.setTitleColor(UIColor(hexString: "#868a8d"), for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapStop), for: .touchUpInside)
        
        
        labelAllTime.text =  (castTime(localTimeDelta: 0))
        labelAllTime.font = UIFont(name: K.fontSemiBold, size: 18)
        labelAllTime.tintColor = UIColor(hexString: "#404040")
        labelAllTime.frame = CGRect(x:  25, y: (150 / 2) - (56/2) - 25 , width: 130, height: 56)
        
        labelAllTimeDesc.text = "Общее время"
        labelAllTimeDesc.font = UIFont(name: K.fontThin, size: 12)
        labelAllTimeDesc.tintColor = UIColor(hexString: "#8C8A8A")
        labelAllTimeDesc.frame = CGRect(x:  26, y: (150 / 2) - (56/2) - 6 , width: 130, height: 56)
        
        paddingForm.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        paddingForm.backgroundColor = UIColor(hexString: "#E1E0E0")
        
        buttonPanel.addSubview(paddingForm)
        buttonPanel.addSubview(buttonCreate)
        buttonPanel.addSubview(labelAllTime)
        buttonPanel.addSubview(labelAllTimeDesc)
        
        K.activeIDStep = nil
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAddStep), name: NSNotification.Name(rawValue: "newDataNotifAddStep"), object: nil)
        
        self.view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        //self.view.addGradientBackground(firstColor: UIColor(hexString: "#dfebfe"), secondColor: UIColor(hexString: "#ffffff"))
        

        self.navigationItem.title = TOPIC_NAME
        let rightBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButtonNewStart)
        )
        let rightBackButton1 = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "doc.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        rightBackButton1.tintColor = colorSort
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        if K.teamLeader == 0 {
        self.navigationItem.rightBarButtonItems = [rightBackButton/*,  rightBackButton1*/]
        } else {
            self.navigationItem.rightBarButtonItems = [rightBackButton,  rightBackButton1]
        }
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.registerTableViewCells()
        contentStepManager.delegate = self
        contentStepManager.performLogin(user: self.idTopic)
        stepManager.delegate = self
//        content.append(contentsOf: [TopicStep(id: 216, TOPIC_ID: 296, STEP_NAME: "Презентация по продукту ")])
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setLoadingScreen()
        loadItems()

        if activeFlag == false {
            activeID = sercheActive(searchValue: idTopic)
        }
//        else {
//            contentStepManager.performActive(loginLet: user)
//            self.activeFlagRunStep = true
//        }
        
        
        timeDeltaSumAll(value: idTopic)
        
       
    }
    
    @objc func didTapStop() {
        self.buttonCreate.backgroundColor = UIColor(hexString: "#868a8d")
        self.buttonCreate.isEnabled  = false
        self.handleCloseAll()
//        completionHandler(true)
        self.timer.invalidate()
        self.stopUpdateLocal()
        self.saveItems()
    }
    
    @objc func refreshAddStep() {
        

        self.buttonPanel.alpha = 0


        
        let toast = ToastViewController(title: "Обновление прошло успешно", backgroundColor: .systemBlue)
        present(toast, animated: true)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            toast.dismiss(animated: true)
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.buttonPanel.alpha = 1
                 })
        }
    }
    
    
    @objc func refresh() {
        

        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            self.contentStepManager.performLogin(user: self.idTopic)
            


        }
    }
    
    
    func showButtonPanel() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.buttonPanel.alpha = 1
         })
    }
    
    func hiddenButtonPanel() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {

            self.buttonPanel.alpha = 0
         })
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
        spinner.style = UIActivityIndicatorView.Style.medium
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
    
    func typeAction(nameAction: String, topicID: Int, stepID: Int, activeID: Int) {
        
        let newItem = Logtimer(context: self.context)
        newItem.dateTimeStart = Date()
        localTime = Date()
        newItem.typeAction = nameAction
        newItem.topicID = Int16(topicID)
        newItem.stepID = Int16(stepID)
        newItem.user = user
        newItem.activeID = Int16(activeID)
        idStepIn = stepID
        
        

        // newItem.perentGroupExercise = self.selectidGroup

        self.itemTimeArray.append(newItem)
        //save data
        self.saveItems()
        
    }
    // Сохранение
    func saveItems() {
              
              do {
                  try context.save()
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
    }
    
    //Загрузка в массив
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
//            records = try context.fetch(request) as [Record]
//            let jsonData = try JSONEncoder().encode(records)

        } catch {
            print("Error")
        }
    }

    
    //MARK: CoreData --> array
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = "\(value)"
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }

    //MARK: --> array --> json
    func convertIntoJSONString(arrayObject: Any) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }

            } catch let error as NSError {
                print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }
    

    // Обновление данных
    func stopUpdateLocal()
    {
        if (self.idStepIn != nil) {
            if let i = itemTimeArray.firstIndex(where: { $0.stepID == self.idStepIn && $0.dateTimeEnd == nil && $0.user == user }) {
                idStepIn = i
                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                itemTimeArray[i].setValue("Finish", forKey: "typeAction")
                itemTimeArray[i].setValue(0, forKey: "flagActive")
                self.saveItems()
            }
        }
    }
    
    func sercheActive(searchValue: Int) -> Int
    {

        if let i = itemTimeArray.firstIndex(where: {  $0.flagActive == 0 && $0.user == user && $0.topicID ==  Int16(searchValue)}) {
            activeID = Int(itemTimeArray[i].activeID)
            }
        return activeID
    }
    
    
    func startUpdate(value searchValue: Int)
    {
            if let i = itemTimeArray.firstIndex(where: { $0.stepID == Int16(searchValue) && $0.dateTimeEnd == nil && $0.user == user }) {
                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                itemTimeArray[i].setValue("Finish", forKey: "typeAction")
//                itemTimeArray[i].setValue(1, forKey: "flagActive")
                self.saveItems()
        }
    }
    
    func upadteActId (activeIdUp: Int!) {
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.activeID == 0) {
                book.activeID = Int16(activeIdUp)
                saveItems()
            }
        })
    }
    
    func timeDelta(value searchValue: Int) -> Int {
        r = 0
        if let i = itemTimeArray.lastIndex(where: {$0.flagActive == 0 && $0.stepID == Int16(searchValue) && $0.user == user }) {
            let dateStartInt = itemTimeArray[i].dateTimeStart?.timeIntervalSince1970
            let dateEndInt = itemTimeArray[i].dateTimeEnd?.timeIntervalSince1970
//            let timeInterval = someDate.dateStartInt
            r = Int(dateEndInt ?? 0) - Int(dateStartInt ?? 0)
        }
        if r != nil && r > 0 {
            return r!
        } else{
            return 0
        }
    }
    
    func sumFactCell (topicI: Int) -> Int {
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.topicID == topicI && book.flagActive == 0 && book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    
    
    func timeDeltaSum(value searchValue: Int) -> Int {
//
        self.timeDeltaSumVar = 0
        
        self.itemTimeArray.forEach({ book in
            if (book.stepID == searchValue && book.flagActive == 0 && book.typeAction == "Finish") {
                let dateStartInt = book.dateTimeStart?.timeIntervalSince1970
                let dateEndInt = book.dateTimeEnd?.timeIntervalSince1970
                self.timeDeltaSumVar = self.timeDeltaSumVar + (Int(dateEndInt ?? 0) - Int(dateStartInt ?? 0))
            }
        })
        return self.timeDeltaSumVar
        
    }
    
    func timeDeltaSumAll(value searchValue: Int) -> Int {
//
        self.timeDeltaSumVar = 0
        self.itemTimeArray.forEach({ book in
            if (book.topicID == searchValue && book.flagActive == 0 && book.typeAction == "Finish") {
                let dateStartInt = book.dateTimeStart?.timeIntervalSince1970
                let dateEndInt = book.dateTimeEnd?.timeIntervalSince1970
                self.timeDeltaSumVar = self.timeDeltaSumVar + (Int(dateEndInt ?? 0) - Int(dateStartInt ?? 0))
            }
        })
        labelAllTime.text =  (castTime(localTimeDelta: timeDeltaSumVar))
        return self.timeDeltaSumVar

    }
    
    
    func countStepSum(value searchValue: Int) -> Int {
//
        
        self.countStepSumVar = 0
        
        self.itemTimeArray.forEach({ book in
            if (book.stepID == searchValue && book.flagActive == 0) {

                self.countStepSumVar = self.countStepSumVar + 1
//                self.content.append(contentsOf: [TopicStep(id: 217, TOPIC_ID: 296, STEP_NAME: "Заполнение анкеты")])
            }
        })

//        self.tableView.reloadData()

        return self.countStepSumVar
        
    }
    
    
    func upadteFlagAction (stepID: Int) {
        self.itemTimeArray.forEach({ book in
            if (book.stepID == stepID && book.flagActive == 0 && book.user == user) {
                saveItems()
            }
        })
    }
    
    
    //MARK: Преобразование во Время
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
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        vw.isHidden = true
        
        return vw
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    
    func isColorRow (time: Int) -> UIColor {

        switch time {
        case 0:
            return UIColor(hexString: "#443E3E")
        default:
            return UIColor(hexString: "#478ECC")
        }
    }
    


    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }


    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCellStep",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCellStep")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (contentFix.count > 0) {
            self.removeLoadingScreen()
        }
        
//        if !contentFix[section].isExp {
//            return contentFix.count - self.delRow
//        } else {
//            return contentFix.count + self.delRow
//        }

        return contentFix.count + self.delRow
        
    }

    
    // Set the spacing between sections


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCellStep", for: indexPath) as! CustomTableViewCellStep
 //Радиус cell
        cell.layer.masksToBounds = false
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        cell.layer.borderColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor
        cell.layer.borderWidth = 1
    
        
            //Наименование шага

        let idStepViz = contentFix[indexPath.row].id
//        print(contentFix[indexPath.row].id)
        let data = timeDelta(value: idStepViz)
        let dataSum = timeDeltaSum(value: idStepViz)
        let dataCount = String(countStepSum(value: idStepViz))
        
        //Наименование шага

        
        let imageClose = UIImage(systemName: "questionmark.diamond")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let imageOpen = UIImage(systemName: "questionmark.diamond")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) as UIImage?
//        let imageClose = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
//        let isExpanded = filteredData[section].isExt
        
        

        
        
        button.frame = CGRect(x: cell.frame.maxX-80, y: 30, width: 100, height: 100)
        button.setImage( (contentFix[indexPath.row].comment != nil) ? imageOpen : imageClose , for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        if (contentFix[indexPath.row].comment != nil) {
            button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(handleOpenCloseDis), for: .touchUpInside)
        }
        
        button.tag = indexPath.row

//        cell.addSubview(labelComment)
        cell.addSubview(button)
        

   
        cell.labelComment.font = UIFont(name: K.fontRegular, size: 11)


        
        cell.labelNme.textColor = isColorRow(time: dataSum)
//        cell.labelNme.font = UIFont(name: K.fontSemiBold, size: 15)
        cell.labelNme.text = contentFix[indexPath.row].STEP_NAME
        cell.labelCount.text = String(countSecond)
        
            //Общее время
        cell.labelTimeAVDAct.text =  (castTime(localTimeDelta: dataSum))
        cell.labelTimeAVDAct.textColor = isColorRow(time: dataSum)
        cell.labelTimeAVDAct.font = UIFont(name: K.fontSemiBold, size: 14)
        
        
        //  cell.labelTimeAVDAct.text =  "Посл. шаг: \(castTime(localTimeDelta: data))"
//        cell.labelTimeAVDAct.text =  (castTime(localTimeDelta: dataSum))
        cell.labelCountAct.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        cell.labelCountAct.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelCountAct.text = "Последний шаг"
        
        cell.labelTimeAVDStep.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        cell.labelTimeAVDStep.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelTimeAVDStep.text = (castTime(localTimeDelta: data))
        
        cell.labelCountStep.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        cell.labelCountStep.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelCountStep.text = "Количество"
        
        cell.labelCount.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        cell.labelCount.font = UIFont(name: K.fontRegular, size: 10)
        cell.labelCount.text = (dataCount)
//        cell.labelComment.isHidden = true

        
  
        if expandedIndexSet.contains(indexPath.row) {

            cell.labelNme.isHidden = true
            cell.labelCount.isHidden = true
//            cell.labelTimeAVDAct.isHidden = true
            cell.labelCountAct.isHidden = true
            cell.labelTimeAVDStep.isHidden = true
            cell.labelCountStep.isHidden = true
            cell.labelComment.isHidden = false
        
//            if contentFix[indexPath.row].comment == nil {
//                cell.labelComment.font = UIFont(name: K.fontRegular, size: 14)
//                cell.labelComment.numberOfLines = 1
//                cell.labelComment.text = "Нет комментария"
//                cell.labelComment.sizeToFit()
//
//            } else {
                cell.labelComment.numberOfLines = 6
                cell.labelComment.text = contentFix[indexPath.row].comment
                cell.labelComment.frame = CGRect(x: 15.0, y: 11, width: 90, height: 300)
                cell.labelComment.sizeToFit()

//            }
            
        } else {
            cell.labelNme.isHidden = false
            cell.labelCount.isHidden = false
//            cell.labelTimeAVDAct.isHidden = false
            cell.labelCountAct.isHidden = false
            cell.labelTimeAVDStep.isHidden = false
            cell.labelCountStep.isHidden = false
            cell.labelComment.isHidden = true
            

        }
        
        return cell
    }
    
    @objc func handleOpenCloseDis(button: UIButton) {
//        self.showToast(message: "Нет детализации к шагу", font: UIFont(name: K.fontRegular, size: 14)!, backgroundColor: UIColor.black.withAlphaComponent(0.6),  time: Int(1.5))
        
        self.hiddenButtonPanel()
       
        let toast = ToastViewController(title: "Нет детализации к шагу", backgroundColor: .systemGray)
        present(toast, animated: true)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            toast.dismiss(animated: true)
            self.showButtonPanel()
        }
        
    }

    
    @objc func handleOpenClose(button: UIButton) {
//        self.tableView.reloadData()
        for i in 0...content.count-1 {
            if i == button.tag  {
                let indexPath = IndexPath(item: button.tag, section: 0)
                if(expandedIndexSet.contains(button.tag)){
                    expandedIndexSet.remove(button.tag)
                } else {
                    expandedIndexSet.insert(button.tag)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                continue
            }
            let indexPath1 = IndexPath(item: i, section: 0)
                if(expandedIndexSet.contains(i)){
                    expandedIndexSet.remove(i)
                    tableView.reloadRows(at: [indexPath1], with: .automatic)
                }
        }

    }
    
    
   func handleCloseAll() {
        for i in 0...content.count-1 {
            let indexPath1 = IndexPath(item: i, section: 0)
                if(expandedIndexSet.contains(i)){
                    expandedIndexSet.remove(i)
                tableView.reloadRows(at: [indexPath1], with: .automatic)
                }
        }
    }

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        contentFix.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    
    @objc func didTapSort() {
        let vc = AddNewStepController()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .automatic
        K.activeIDTopic = idTopic
        present(vc, animated: true, completion: nil)
    }
    
    
    func addCategory() {

//       var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("NewCategory") as UIViewController
        let vc = FeedBackTopic()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        vc.preferredContentSize = CGSize(width: 100, height: 100)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)

        self.present(nav, animated: true, completion: nil)

   }
    
    func openFeedBackOforn() {
        let transition = PanelTransition()
        let vc = FeedBackTopic()

        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom

        present(vc, animated: true)
    }
    
   //MARK: Действие на нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let message = content[indexPath.row]

        let dataCount = countStepSum(value: message.id)
        
        self.handleCloseAll()
        
//        cell.labelCountAct.font = UIFont(name: K.fontRegular, size: 10)

        if dataCount == 0 {
//            self.showToast(message: "Комментарий недоступен", font: UIFont(name: K.fontRegular, size: 14)!, backgroundColor: UIColor.black.withAlphaComponent(0.6), time: Int(1.5))
            
            self.hiddenButtonPanel()
            let toast = ToastViewController(title: "Комментарий недоступен", backgroundColor: .systemGray)
            present(toast, animated: true)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                toast.dismiss(animated: true)
                self.showButtonPanel()
            }
        }
        else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentStepId") as! commentStep
            newViewController.typeView = "step"
            newViewController.stepId = message.id
            newViewController.stepName = message.STEP_NAME
            newViewController.stepNum =  "Шаг \(String(indexPath.row + 1))"
                    self.present(newViewController, animated: true, completion: nil)

        }
    }
    

    @objc public func textFieldDidChange() {
        self.numberOfRows = tableView.indexPathsForSelectedRows!
        self.numberOfRows.forEach { numberOfRows in
            self.tableView.selectRow(at: numberOfRows, animated: true, scrollPosition: .top)
        }
    }

    
    @objc public func someButtonAction() {
        print("Button is tapped")
    }
    
    
    //MARK: Кнопка Стоп
    @objc public func didRunTime() {
        stopUpdateLocal()
//        stopUpdateLocal()
        let jsonTo = convertToJSONArray(moArray: itemTimeArray)
        let jsonString = convertIntoJSONString(arrayObject: jsonTo)!
        stepManager.performRequest(loginRegLet: user, json: jsonString)
        self.timer.invalidate()
        
        let alertController = UIAlertController(title: "Данные на сервере!", message: "", preferredStyle: .alert)

            // Initialize Actions

        let noAction = UIAlertAction(title: "ok", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
        
            alertController.addAction(noAction)


            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    


    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "") { [self] (_, _, completionHandler) in
            
             self.handleCloseAll()
            self.upadteFlagAction(stepID: self.contentFix[indexPath.row].id)
            self.indexRow = -1
            completionHandler(true)
            
            let topic_id = self.contentFix[indexPath.row].TOPIC_ID
            let step_id = self.contentFix[indexPath.row].id
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.upadteFlagAction(stepID: step_id)
            if activeFlag == true {
                contentStepManager.performActive(loginLet: user)
                self.activeFlagRunStep = true
                self.typeAction(nameAction: "Start", topicID: topic_id, stepID: step_id, activeID: 0 )
                activeFlag = false
            } else {
            self.typeAction(nameAction: "Start", topicID: topic_id, stepID: step_id, activeID: self.activeID )
            }
            self.timer.invalidate()
            self.locationManager.requestLocation()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//            timeDeltaSum(value: indexPath.row)
            self.idStepPlay = self.contentFix[indexPath.row].id
            self.indexRow = indexPath.row
//            self.tableView.reloadData()
//            content.append(contentsOf: [TopicStep(id: 216, TOPIC_ID: 296, STEP_NAME: "Презентация по продукту ")])

//            K.activeIDStep = self.activeID
//            self.tableView.reloadData()
            self.activeFlagRunStep2 = true
            
            timeDeltaSumAll(value: idTopic)
            buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
            buttonCreate.isEnabled  = true
            
        }
//        testAction.backgroundColor = UIColor(red: 109.0 / 255.0, green: 220.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        testAction.backgroundColor = .systemGreen
        testAction.image = UIImage(systemName: "forward.fill")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    

    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stopAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            self.buttonCreate.backgroundColor = UIColor(hexString: "#868a8d")
            self.buttonCreate.isEnabled  = false
            self.handleCloseAll()
            completionHandler(true)
            self.timer.invalidate()
            self.stopUpdateLocal()
            self.saveItems()
        }
//        stopAction.backgroundColor = UIColor(red: 231.0 / 255.0, green: 230.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
        stopAction.backgroundColor = .systemYellow
        stopAction.image = UIImage(systemName: "pause")
        
        let delAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            self.contentStepManager.performDelTopicStep(groupLet: self.contentFix[indexPath.row].TOPIC_ID, nameStep: self.contentFix[indexPath.row].STEP_NAME)
            self.contentFix.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        delAction.backgroundColor = .systemRed
        delAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            completionHandler(true)
            let vc = AddNewStepController1()
            vc.editorDescGroup.text = self.contentFix[indexPath.row].comment
            vc.editorNameGroup.text = self.contentFix[indexPath.row].STEP_NAME
            vc.stepIDVal = self.contentFix[indexPath.row].id
            vc.loadFormFlag = 1
            K.activeIDTopic = self.contentFix[indexPath.row].TOPIC_ID
            
            let navController = UINavigationController(rootViewController: vc)
    //        navController.modalTransitionStyle = .crossDissolve
         
            navController.modalPresentationStyle = .automatic
 
            self.present(navController, animated: true, completion: nil)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        
        if K.teamLeader == 0 {
        return UISwipeActionsConfiguration(actions: [stopAction/*,editAction*/])
        } else {
            return UISwipeActionsConfiguration(actions: [stopAction, editAction, delAction])
        }
    }


    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {

    
        let alertController = UIAlertController(title: "Выход", message: "Выйти из замера?", preferredStyle: .alert)

            // Initialize Actions
        let yesAction = UIAlertAction(title: "Да", style: .destructive) { [self] (action) -> Void in
                print("The user is okay.")
            
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            
            self.saveItems()
            let jsonTo = self.convertToJSONArray(moArray: self.itemTimeArray)
            let jsonString = self.convertIntoJSONString(arrayObject: jsonTo)!
            self.backMainForm = true
            self.timer.invalidate()
            self.stepManager.performRequest(loginRegLet: self.user, json: jsonString)
   
            }

        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
            alertController.addAction(yesAction)
            alertController.addAction(noAction)

            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Кнопка Добавления
    @objc public func didTapMenuButtonAdd() {
//                DispatchQueue.main.async {
//        var textField = UITextField()
//               
//               let alert = UIAlertController (title: "Добавить действие", message: "", preferredStyle: .alert)
//               let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
//                let nameTopic = textField.text
//                self.contentStepManager.performAddTopicStep(groupLet: self.idTopic, nameStep: nameTopic!, descStep: "", flagLoad: 0)
//                sleep(1)
//                self.contentStepManager.performLogin(user: self.idTopic)
//                self.tableView.reloadData()
//        
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Добавить новое действие"
//            textField = alertTextField
//        }
//        
//        alert.addAction(action)
//            self.tableView.reloadData()
//            self.present(alert, animated: true, completion: nil)
//        }

    }
    
//    if activeFlag == false {
//        activeID = sercheActive(searchValue: idTopic)
//    } else {
//        contentStepManager.performActive(loginLet: user)
//    }
    
    //MARK: Создание нового замера внутри топика
    @objc public func didTapMenuButtonNewStart() {
        DispatchQueue.main.async { [self] in
                       func upadteFlagAction () {
                        self.itemTimeArray.forEach({ book in
                            if (book.topicID == self.idTopic && book.flagActive == 0 && book.user == self.user) {
                                book.flagActive = 1
                            }
                        })
                    }
                    

                    if ((sumFactCell(topicI: self.idTopic)) != 0) {
                        let alertController = UIAlertController(title: "Создать новый замер?", message: "", preferredStyle: .alert)

                            // Initialize Actions
                        let yesAction = UIAlertAction(title: "Да", style: .default) { (action) -> Void in
                                print("The user is okay.")
                                stopUpdateLocal()
                                upadteFlagAction ()
                                self.saveItems()
                                self.timer.invalidate()
                                self.saveItems()
                                self.buttonCreate.backgroundColor = UIColor(hexString: "#868a8d")
                                self.buttonCreate.isEnabled  = false
                                self.labelAllTime.text =  (castTime(localTimeDelta: 0))
//                                contentStepManager.performActive(loginLet: self.user)
                                self.tableView.reloadData()
                                let jsonTo = self.convertToJSONArray(moArray: self.itemTimeArray)
                                let jsonString = self.convertIntoJSONString(arrayObject: jsonTo)!
                                self.backMainForm = false
                                self.stepManager.performRequest(loginRegLet: self.user, json: jsonString)
                                self.contentStepManager.performCheckFeedback(activeID: self.activeID)
                                activeFlag = true
                                
                            }

                        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                                print("The user is not okay.")
                            activeID = sercheActive(searchValue: idTopic)

                            }

                            // Add Actions
                        
                            alertController.addAction(yesAction)
                            alertController.addAction(noAction)
                 

                            // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        let alertController = UIAlertController(title: "Информация", message: "Замеров не производилось", preferredStyle: .alert)

                            // Initialize Actions
                        let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                                print("The user is okay.")
//                                upadteFlagAction ()
//                            activeID = sercheActive(searchValue: idTopic)
                            

                            }



                            // Add Actions
                        
                            alertController.addAction(yesAction)
//                            alertController.addAction(noAction)
                 

                            // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                    }

        }

    }
    

}

extension tableStepController: ContentStepManagerDelegate {
    func didCheckFeedBack(_ Content: ContentStepManager, content: AddLoccation) {
        DispatchQueue.main.async {
            
            if content.statusAddLocation == 0 && self.TYPE_FEEDBACK > 0  {
                self.activeFlagRunStep2 = false
                self.openFeedBackOforn()
            }
        }
 
    }
    
    func didAddLocation(_ Content: ContentStepManager, content: AddLoccation) {
        
    }
    
    func didActimeTime(_ Content: ContentStepManager, content: AddActiveModel) {
//        K.activeIDStep = content.idAddActive
        
        K.activeIDStep = content.idAddActive
        activeID = content.idAddActive
        upadteActId(activeIdUp: activeID)
    }
    
    
    func didContentStepData(_ Content: ContentStepManager, content: [TopicStep]) {

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {

            self.content = content
            self.contentFix = content
        
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            self.removeLoadingScreen()
        }
        
        
    }
    
    func didAddTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        
    }
    
    func didDelTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        
    }
}

//MARK: Json
extension NSManagedObject {
  func toJSON() -> String? {
    let keys = Array(self.entity.attributesByName.keys)
    let dict = self.dictionaryWithValues(forKeys: keys)
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        return reqJSONStr
    }
    catch{}
    return nil
  }

}





// MARK: - Timer
extension tableStepController {
    
    
    @objc func updateTimer() {

        
        let dataSumAll = timeDeltaSumAll(value: idTopic)
        let localTimeInt =  localTime.timeIntervalSince1970
        let localTimeDelta = Int(Date().timeIntervalSince1970) - Int(localTimeInt)
        self.labelAllTime.text = (castTime(localTimeDelta: dataSumAll + localTimeDelta))

    
          if let cell = tableView.cellForRow(at: IndexPath(row: indexRow, section: 0)) as? CustomTableViewCellStep {
     
                
            cell.updateTime(localTime: localTime)
            cell.updateTimeAll(deltaTime: timeDeltaSum(value: self.idStepIn) , localTime: localTime)
            cell.updateCountStep(count: countStepSum(value: self.idStepIn))
    //Радиус cell
//            cell.layer.masksToBounds = true
//            cell.layer.cornerRadius = 16
//            cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
            
//              print(indexPath.row)
          }
        }
    
}


extension tableStepController: StepManagerDelegate {
    func didPostStep(_ weatherRegister: StepManager, register: StepModel) {

      
        
        func openMainController() {
            
//
            
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {
                newViewController.user = self.user
                newViewController.group = self.group
                newViewController.resetCoredata = self.resetCoredata
                newViewController.numberOfRows = self.numberOfRowsMain
                newViewController.valueSearch = self.valueSearchStep
                if self.activeFlagRunStep && activeFlagRunStep2 && self.TYPE_FEEDBACK > 0 {
                    DispatchQueue.main.async {
                    self.openFeedBackOforn()
                    }
                }
//                self.contentStepManager.performCheckFeedback(activeID: self.activeID)
                _ = navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotifStep"), object: nil)
                
                
               }
        }
        
        
        DispatchQueue.main.async {
            
            if register.statusAddStep > 0 && self.backMainForm == true  {
            openMainController()
                  
        } else {
            
        }
        }
    }
    
    
}

//MARK -- Color gradient


extension UIViewController {

    func showToast(message : String, font: UIFont, backgroundColor: UIColor, time: Int) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.bounds.maxY-70, width: 250, height: 35))
//    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.backgroundColor =  backgroundColor
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
        
    self.view.addSubview(toastLabel)
        UIView.animate(withDuration: TimeInterval(time), delay: 2, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
    
}


//MARK: Геолокация
extension tableStepController: CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("New Location")
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            if let activeIDLoc = self.activeID  {
                self.contentStepManager.performAddLocation(activeID: activeIDLoc, lat: String(lat), lon: String(lon))
//                print(activeIDLoc)
            }

        } 
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}




//MARK: Всплывающее меню

class FeedBackTopic: UIViewController {

    
    let chipNo = UIButton()
    let chipYes = UIButton()
    let titleLabel = UITextView()
    let buttonCreate = UIButton()
    var commentManager = CommentManager()
    var selectOform: Int!
    let alertCustom = AlertCustom()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.alpha = 1
   
        
        
        view.makeCorner(withRadius: 16.0)

      
        let halfHeight = view.bounds.height / 1.5
        
//        disButtom.frame = CGRect(x: 0, y: 0, width: 20, height: 54)

        
        let labelTextMain = UILabel()
        labelTextMain.frame = CGRect(x: 20 , y: 15, width: 300, height: 40)
        labelTextMain.text = "Замер успешно завершен"
        labelTextMain.textAlignment = .left
        labelTextMain.font = UIFont(name: K.fontBold, size: 17)
        view.addSubview(labelTextMain)
        
        
        let headerLine = UIView()
        headerLine.frame = CGRect(x: 0, y: labelTextMain.frame.maxY + 15, width: view.frame.width, height: 1)
        headerLine.backgroundColor = UIColor(hexString: "#EEEEEF")
        view.addSubview(headerLine)
        
        
        
        let labelTextDesc = UILabel()
        labelTextDesc.frame = CGRect(x: 20 , y: headerLine.frame.maxY + 22, width: 300, height: 40)
        labelTextDesc.text = "Клиент оформил продукт?"
        labelTextDesc.textAlignment = .left
        labelTextDesc.font = UIFont(name: K.fontRegular, size: 17)
        view.addSubview(labelTextDesc)
        
         
   
        chipYes.frame = CGRect(x: 20, y: labelTextDesc.frame.maxY + 14, width: 51, height: 32)
        chipYes.backgroundColor = .none
        chipYes.setTitle("Да", for: .normal)
        chipYes.setTitleColor(UIColor(hexString: "#478ECC"), for: .normal)
        chipYes.layer.cornerRadius = 12
        chipYes.titleLabel?.font = UIFont(name: K.fontSemiBold, size: 14)
        chipYes.layer.borderColor = UIColor(hexString: "#478ECC").cgColor
        chipYes.layer.borderWidth  = 1.0
        chipYes.tag = 1
        chipYes.addTarget(self, action: #selector(didTapChip(sender:)), for: .touchUpInside)
        view.addSubview(chipYes)
        
        

        chipNo.frame = CGRect(x: chipYes.frame.maxX + 10, y: labelTextDesc.frame.maxY + 14, width: 51, height: 32)
        chipNo.backgroundColor = .none
        chipNo.setTitle("Нет", for: .normal)
        chipNo.setTitleColor(UIColor(hexString: "#478ECC"), for: .normal)
        chipNo.layer.cornerRadius = 12
        chipNo.titleLabel?.font = UIFont(name: K.fontSemiBold, size: 14)
        chipNo.layer.borderColor = UIColor(hexString: "#478ECC").cgColor
        chipNo.layer.borderWidth  = 1.0
        chipNo.tag = 0
        chipNo.addTarget(self, action: #selector(didTapChip(sender:)), for: .touchUpInside)
        view.addSubview(chipNo)
        
        
        let labelTextComment = UILabel()
        labelTextComment.frame = CGRect(x: 20 , y: chipNo.frame.maxY + 26, width: 300, height: 40)
        labelTextComment.text = "Комментарий к замеру"
        labelTextComment.textAlignment = .left
        labelTextComment.font = UIFont(name: K.fontRegular, size: 17)
        view.addSubview(labelTextComment)
        
        
       
        buttonCreate.frame = CGRect(x: (view.frame.width/2) - (338/2)-10, y: halfHeight - 25 - 56, width: 338, height: 56)
        buttonCreate.backgroundColor = UIColor(hexString: "#cbcdce")
        buttonCreate.setTitle("Сохранить", for: .normal)
        buttonCreate.layer.cornerRadius = 8
        buttonCreate.layer.borderWidth = 0
        buttonCreate.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonCreate.isEnabled = false
        view.addSubview(buttonCreate)
        
        

        titleLabel.frame = CGRect(x: 20, y: labelTextComment.frame.maxY + 0 ,width: view.frame.width - 60 , height: buttonCreate.frame.minY -  labelTextComment.frame.maxY - 30)
        titleLabel.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        titleLabel.layer.cornerRadius = 4
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont(name: K.fontRegular, size: 14)
        view.addSubview(titleLabel)
        
        
    }
    
    
    @objc func didTapNext()  {

        commentManager.performUpdateFeedback(activeID: K.activeIDStep, val: self.selectOform, type: 1)
        commentManager.performUpdateComment(activeID: K.activeIDStep, comment: titleLabel.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapChip(sender: UIButton)  {
        
        if sender.tag == 0 {
            chipNo.backgroundColor = UIColor(hexString: "#478ECC")
            chipNo.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
            
            chipYes.backgroundColor = UIColor(hexString: "#FFFFFF")
            chipYes.setTitleColor(UIColor(hexString: "#478ECC"), for: .normal)
            self.selectOform = sender.tag
        
        } else {
            chipYes.backgroundColor = UIColor(hexString: "#478ECC")
            chipYes.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
            
            chipNo.backgroundColor = UIColor(hexString: "#FFFFFF")
            chipNo.setTitleColor(UIColor(hexString: "#478ECC"), for: .normal)
            
            self.selectOform = sender.tag
        }
        
        loadAlpha ()
        
    }
    
    
    func loadAlpha () {
//        buttonCreate.backgroundColor = UIColor(hexString: "#cbcdce")

     UIView.animate(withDuration: 0.1, delay: 0, animations: {
        self.buttonCreate.backgroundColor = UIColor(hexString: "#478ECC")
        self.buttonCreate.isEnabled = true
         })
     }
    
}

extension FeedBackTopic: CommentManagerDelegate {
    func didUpdateFeedback(_ Content: CommentManager, content: UpdateComment) {
        
        print(content.success)
    }
    
    func didUpdateComment(_ Content: CommentManager, content: UpdateComment) {
        
        
        
    }
    
    func didShowComment(_ Content: CommentManager, content: ShowComment) {

    }
    
    
}



class PresentationController: UIPresentationController {
    
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let halfHeight = bounds.height / 1.5
        return CGRect(x: 10,
                      y: halfHeight - (halfHeight/1.5),
                             width: bounds.width - 20,
                             height: halfHeight)
    }
    
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        

        
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    

    
}



extension UIView {
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
}



class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
   
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return  DimmPresentationController(presentedViewController: presented,
presenting: presenting ?? source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
    

}





class DimmPresentationController: PresentationController {
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmView, at: 0)
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmView.frame = containerView!.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
}


extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}


class PresentAnimation: NSObject {
    let duration: TimeInterval = 0.3

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // transitionContext.view содержит всю нужную информацию, извлекаем её
        let to = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!) // Тот самый фрейм, который мы задали в PresentationController
        // Смещаем контроллер за границу экрана
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.frame = finalFrame // Возвращаем на место, так он выезжает снизу
        }

        animator.addCompletion { (position) in
        // Завершаем переход, если он не был отменён
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}


class DismissAnimation: NSObject {
    let duration: TimeInterval = 0.3

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let from = transitionContext.view(forKey: .from)!
        let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        }

        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}

extension DismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
