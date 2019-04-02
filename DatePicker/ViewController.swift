//
//  ViewController.swift
//  DatePicker
//
//  Created by Novare Account on 02/04/2019.
//  Copyright © 2019 Alvin Joseph Valdez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.rootView.birthDateTextField.inputView = self.rootView.birthDatePicker
        
        self.rootView.birthDateTextField.addInputAccessoryView(
            title: "Done",
            target: self,
            selector: #selector(ViewController.donePicker)
        )        
    }

    private var rootView: MainView { return self.view as! MainView }
    
    @objc func donePicker() {
        switch self.rootView.birthDateTextField.isEditing {
        case true:
            self.rootView.birthDateTextField.resignFirstResponder()
        case false:
            self.view.endEditing(true)
        }
    }
}


extension UIView {
    
    
    
    func subview(forAutoLayout subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func subviews(forAutoLayout subviews: UIView...) {
        self.subviews(forAutoLayout: subviews)
    }
    
    func subviews(forAutoLayout subviews: [UIView]) {
        subviews.forEach(self.subview)
    }
    
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
