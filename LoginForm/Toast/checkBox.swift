//
//  CheckBox.swift
//  LoginForm
//
//  Created by 08395593 on 03.09.2021.
//

import UIKit



final class CheckBox: UIView {
    
    private var isChecked: Bool = false
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = false
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "checkmark.square")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        layer.borderWidth = 0.6
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.cornerRadius = frame.size.width / 2
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.bounds.size.height = 50
        layer.bounds.size.width = 50
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: frame.size.width  - frame.size.width * 1.25, y: frame.size.width  - frame.size.width * 1.25, width: frame.size.width * 1.5 , height: frame.size.height * 1.5)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.inset(by: UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)).contains(point)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setChecked() -> Bool {
        self.isChecked = !isChecked
        if self.isChecked {
            backgroundColor = .systemBlue
            layer.borderColor = UIColor(hexString: "#007aff").cgColor
            layer.borderWidth = 0.6
            return true
       } else {
            backgroundColor = .systemBackground
            layer.borderColor = UIColor.secondaryLabel.cgColor
            layer.borderWidth = 0.6
            return false
       }
      
    }

}
