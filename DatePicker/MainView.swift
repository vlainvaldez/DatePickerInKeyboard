//
//  Step3Cell.swift
//  Earnest
//
//  Created by  on 22/02/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SnapKit

public final class MainView: UIView {
    
    // MARK: Subviews
    private let titleLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "Create your profile"
        view.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight.bold
        )
        view.textColor = UIColor.black
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view: UIScrollView = UIScrollView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let viewContainer: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    public let noteLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = """
        This will be how people see and interact with
        you on Earnest
        """
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.black
        view.numberOfLines = 2
        return view
    }()
    
    private let firstNameLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "First name"
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.black
        return view
    }()
    
    public let firstNameTextField: UITextField = {
        let view: UITextField = UITextField()
        view.placeholder = "First Name"
        return view
    }()
    
    private let firstNameValidationLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "Invalid FirstName"
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.red
        view.isHidden = true
        return view
    }()
    
    private let lastNameLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "last name"
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.black
        return view
    }()
    
    public let lastNameTextField: UITextField = {
        let view: UITextField = UITextField()
        view.placeholder = "Last Name"
        return view
    }()
    
    private let lastNameValidationLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "Invalid LastName"
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.red
        view.isHidden = true
        return view
    }()
    
    private let birthDateLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "Birthdate"
        view.font = UIFont.systemFont(
            ofSize: 17,
            weight: UIFont.Weight.light
        )
        view.textColor = UIColor.black
        return view
    }()
    
    public lazy var birthDateTextField: UITextField = {
        let view: UITextField = UITextField()
        view.textAlignment = NSTextAlignment.left
        view.borderStyle = UITextField.BorderStyle.line
        return view
    }()
    
    public let birthDatePicker: UIDatePicker = {
        let view: UIDatePicker = UIDatePicker()
        view.datePickerMode = UIDatePicker.Mode.date
        guard let minimumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else { return view }
        view.maximumDate = minimumDate
        return view
    }()
    
    // MARK: Stored Properties
    private var keyboardManager: KeyboardManager?
    private var temporaryDate: String = ""
    // MARK: Computed Properties
    
    // MARK: Initializer
    //swiftlint:disable:next function_body_length
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.keyboardManager = KeyboardManager(scrollView: self.scrollView)
        
        self.subviews(forAutoLayout: [
            self.scrollView
        ])
        
        self.scrollView.subviews(forAutoLayout: [
            self.viewContainer
        ])
        
        self.viewContainer.subviews(forAutoLayout: [
            self.birthDateLabel, self.birthDateTextField
        ])
        
        self.scrollView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }
        
        self.viewContainer.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.birthDateLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(20.0)
            make.leading.equalToSuperview()
        }
        
        self.birthDateTextField.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.birthDateLabel.snp.bottom).offset(10.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(60.0)
            make.bottom.equalToSuperview()
        }
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.birthDateTextField.delegate = self
        
        self.keyboardManager?.beginObservingKeyboard()
        
        self.firstNameTextField.becomeFirstResponder()
        
        self.birthDatePicker.addTarget(
            self,
            action: #selector(MainView.datePickerDidSelect),
            for: UIControl.Event.valueChanged
        )
        
        self.lastNameTextField.addInputAccessoryView(
            title: "Done",
            target: self,
            selector: #selector(MainView.donePicker)
        )
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.keyboardManager?.endObservingKeyboard()
        
        print("deinitializing")
    }
}

// MARK: - UITextFieldDelegate Methods
extension MainView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.birthDateTextField {
            self.birthDateTextField.inputView = self.birthDatePicker
            self.birthDateTextField.addInputAccessoryView(
                title: "Done",
                target: self,
                selector: #selector(MainView.donePicker)
            )
        }
        
        return true
    }
}

// MARK: - Target Action Methods
extension MainView {
    
    @objc func datePickerDidSelect() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        self.birthDateTextField.text = formatter.string(from: self.birthDatePicker.date)
    }
    
    @objc func donePicker() {
        switch self.birthDateTextField.isEditing {
        case true:
            self.birthDateTextField.resignFirstResponder()
        case false:
            self.endEditing(true)
        }
    }
}

// MARK: - Helper Methods
extension MainView {
    
    //    private func conductValidation() {
    //
    //        self.firstNameTextField.rx.text.orEmpty.subscribe(onNext: { (text: String) -> Void in
    //            self.step3ViewModel.firstName.value = text
    //            self.step3ViewModel.firstNameIsValid.onNext(true)
    //        }).disposed(by: self.disposeBag)
    //
    //        self.lastNameTextField.rx.text.orEmpty.subscribe(onNext: { (text: String) -> Void in
    //            self.step3ViewModel.lastName.value = text
    //            self.step3ViewModel.lastNameIsValid.onNext(true)
    //        }).disposed(by: self.disposeBag)
    //
    //        let valids: [ReplaySubject<Bool>] = [
    //            self.step3ViewModel.firstNameIsValid,
    //            self.step3ViewModel.lastNameIsValid
    //        ]
    //
    //        _ = Observable.combineLatest(valids) { iterator -> Bool in
    //                return iterator.reduce(true, { return $0 && $1 })
    //            }.subscribe(onNext: { [weak self] (valid: Bool) -> Void in
    //                guard let self = self else { return }
    //                self.step3ViewModel.isPassed.value = valid
    //                print("step 3 is \(valid)")
    //        }).disposed(by: self.disposeBag)
    //
    //        self.step3ViewModel.firstNameIsValid
    //            .subscribe(onNext: { [weak self](isValid: Bool) -> Void in
    //                guard let self = self else { return }
    //                self.firstNameValidationLabel.isHidden = isValid
    //            }
    //        ).disposed(by: self.disposeBag)
    //
    //        self.step3ViewModel.lastNameIsValid
    //            .subscribe(onNext: { [weak self](isValid: Bool) -> Void in
    //                guard let self = self else { return }
    //                self.lastNameValidationLabel.isHidden = isValid
    //            }
    //        ).disposed(by: self.disposeBag)
    //    }
}

extension UITextField {
    
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(
            x: 0.0,
            y: 0.0,
            width: UIScreen.main.bounds.size.width,
            height: 44.0)
        )
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

