//
//  commentStep.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.02.2021.
//

import UIKit
import CoreData

class commentStep: UIViewController, UITextViewDelegate {
    
    
    var stepId: Int!
    var itemTimeArray = [Logtimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var commentText: String!
    var commentTextCore: String = ""
    let titleLabel = UITextView()
    var stepName: String!
    var stepNum: String!
    var placeholderLabel = UILabel()
    var titleLabelMain = UILabel()
    var typeView:  String!
    var commentManager = CommentManager()
    
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.delegate = self
        let newView = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 400))
        newView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
//        newView.layer.cornerRadius = 20
//        print(stepId)
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        commentManager.delegate = self
 
            // Заголовок
            let labelTitilAll = UIView(frame: CGRect(x:0, y: 430 ,width: self.view.frame.width ,height:80))
            labelTitilAll.layer.cornerRadius = 10
            labelTitilAll.backgroundColor = .white
            
                //Номер шага
                    let labelTitilStep = UILabel(frame: CGRect(x:16, y: 12 ,width: self.view.frame.width ,height: 10))
                    labelTitilStep.text = stepNum
                    labelTitilStep.font = UIFont(name: K.fontRegular, size: 12)
                    labelTitilStep.numberOfLines = 1
                    labelTitilStep.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
                    labelTitilStep.layer.cornerRadius = 20
                //Название шага
                    let labelTitil = UILabel(frame: CGRect(x:16, y: 22 ,width: self.view.frame.width-10 ,height:labelTitilAll.frame.height/2))
                    labelTitil.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
                    labelTitil.text =  (String(stepName))
                    labelTitil.baselineAdjustment = .alignCenters
                    labelTitil.textAlignment = NSTextAlignment.left
                    labelTitil.font = UIFont(name: K.fontRegular, size: 17)
                    labelTitil.numberOfLines = 1

            labelTitilAll.addSubview(labelTitilStep)
            labelTitilAll.addSubview(labelTitil)

//        placeholderLabel.isHidden = !toTextView.text.isEmpty
        
            //  Основной фрейм
            titleLabelMain.frame = CGRect(x:16, y: 500 ,width: newView.frame.width-32 , height: self.view.frame.maxY - 500 - 40)
            titleLabelMain.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 0)

                titleLabel.frame = CGRect(x:24, y: 500 ,width: newView.frame.width-48 , height: titleLabelMain.frame.maxY - 500 - 40)
                titleLabel.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
                titleLabel.textAlignment = NSTextAlignment.left
                titleLabel.font = UIFont(name: K.fontRegular, size: 14)

                
                    placeholderLabel.text = "Введите комментарий"
                    placeholderLabel.frame = CGRect(x:0, y: 0 ,width: self.view.frame.width , height: 15)
                    placeholderLabel.sizeToFit()
                    placeholderLabel.font = UIFont(name: K.fontRegular, size: 14)
                    placeholderLabel.textColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
                    placeholderLabel.tag = 100
        loadItems()

        self.view.addSubview(labelTitilAll)
        self.view.addSubview(newView)
        self.view.addSubview(titleLabelMain)
        self.view.addSubview(titleLabel)



        
        
        if typeView == "step" {
            titleLabel.addSubview(placeholderLabel)
            titleLabel.text = addComment(value: stepId)
        } else if typeView == "detail" {
            titleLabel.isEditable = false
            setLoadingScreen()
            commentManager.performShowComment(activeID: stepId)
        }


        placeholderLabel.isHidden = !titleLabel.text.isEmpty



        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
   
    }
    

    
    
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (titleLabel.frame.width / 2) - (width / 2)
        let y = (titleLabel.frame.height / 2) - (height / 2)
//        let x:  CGFloat = 1
//        let y: CGFloat = 1
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont(name: K.fontRegular, size: 16)
        loadingLabel.text = "Загрузка..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium  //.gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        titleLabel.addSubview(loadingView)

    }
    
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print(!titleLabel.text.isEmpty)
        placeholderLabel.isHidden = true

//        placeholderLabel.text = ""
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {

//        updateComment(value: stepId, textComment: "11223")
//        titleLabel.text = ""
//        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
//            loadItems()
            
            if typeView == "step" {
            updateComment(value: stepId, textComment: titleLabel.text)
            } else if typeView == "detail" {
                commentManager.performUpdateComment(activeID: stepId, comment: titleLabel.text)
            }
        }
    }
    
    // Сохранение
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
    }
    
    //Загрузка в массив
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func addComment(value searchValue: Int) -> String
    {
        loadItems()
        if let i = itemTimeArray.lastIndex(where: { $0.stepID == Int16(searchValue)}) {
            commentTextCore =  itemTimeArray[i].comment != nil ? itemTimeArray[i].comment! : ""
        }
        return  commentTextCore
    }
    
    
    func updateComment(value searchValue: Int, textComment: String)
    {
            if let i = itemTimeArray.lastIndex(where: { $0.stepID == Int16(searchValue)}) {
            itemTimeArray[i].setValue(textComment, forKey: "comment")
            self.saveItems()
        }
    }
    


}


extension commentStep: CommentManagerDelegate {
    func didUpdateFeedback(_ Content: CommentManager, content: UpdateComment) {
        
    }
    
    func didUpdateComment(_ Content: CommentManager, content: UpdateComment) {
        
        
        
    }
    
    func didShowComment(_ Content: CommentManager, content: ShowComment) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            if content.comm != nil {
                self.removeLoadingScreen()
                self.titleLabel.isEditable = true
                self.titleLabel.text = content.comm
            } else {
                self.removeLoadingScreen()
                self.titleLabel.isEditable = true
                self.titleLabel.addSubview(self.placeholderLabel)
            }
        }
    }
    
    
}
