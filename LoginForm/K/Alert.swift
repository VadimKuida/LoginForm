//
//  Alert.swift
//  LoginForm
//
//  Created by Вадим Куйда on 31.03.2021.
//

import Foundation
import UIKit


struct AlertCustom {
    func showAlertOk(main: String, second: String, control: UITabBarController) {
        let alertController = UIAlertController(title: main, message: second, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                print("The user is okay.")
            }
            alertController.addAction(yesAction)
        control.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOkView(main: String, second: String, control: UIViewController, dismissView: Bool, notificcationStr: String!) {
        let alertController = UIAlertController(title: main, message: second, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                print("The user is okay.")
            if dismissView {
            control.dismiss(animated: true)
            }
            if notificcationStr != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificcationStr), object: nil)
            }
            }
            alertController.addAction(yesAction)
        control.present(alertController, animated: true, completion: nil)
    }
    
}



struct LoadScreen {


    
    func setLoadingScreen(xF: CGFloat, yF: CGFloat, widthF: CGFloat, heightF: CGFloat, showLabel: Bool, viewF: UIView) {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (imageQR.frame.width / 2) - (width / 2)
        let y = (imageQR.frame.height / 2) - (height / 2)
//        let x:  CGFloat = 1
//        let y: CGFloat = 1
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont(name: "fontRegular", size: 16)
        loadingLabel.text = "Заxгрузка..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium  //.gray
        spinner.frame = CGRect(x: xF, y: yF , width: widthF, height: heightF)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        if showLabel {loadingView.addSubview(loadingLabel)}
        

        viewF.addSubview(loadingView)

    }
    
     func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }
}



