//
//  OnlineCheck.swift
//  LoginForm
//
//  Created by Вадим Куйда on 28.06.2021.
//

import Foundation
import UIKit


class OnlineCheck: UIViewController {
    
    var labelName = UILabel()
    let viewMain = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMain.frame = view.frame
        viewMain.backgroundColor = .white


        view.backgroundColor = .white
        labelName.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
    //        labelName.text = "Привет МИР!"
        view.addSubview(labelName)
    
    }
}
