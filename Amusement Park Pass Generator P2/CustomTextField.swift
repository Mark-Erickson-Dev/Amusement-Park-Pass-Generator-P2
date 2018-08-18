//
//  CustomTextField.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

// Custom text field that will except only certain characters
class CustomTextField: UITextField, UITextFieldDelegate {
    
    // Character limit
    var maxCharacters: Int = 20
    
    // Only characters listed can be entered into text field
    var permittedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-' 1234567890"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    // Every time a key is pressed, the character is checked to see if it is a permitted character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let permittedCharacterSet = CharacterSet(charactersIn: permittedCharacters)
        let inputCharacterSet = CharacterSet(charactersIn: string)
        
        // If the amount of characters entered does not exceed the number permitted and
        // the characters entered are listed among the permitted characters, the character
        // will appear in the text field
        return currentText.count + string.count <= maxCharacters && permittedCharacterSet.isSuperset(of: inputCharacterSet)
    }
    
    // Upon entering the text field, the autocapitalizationType and autocorrectionType are set
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.autocapitalizationType = .words
        self.autocorrectionType = .no
    }
}

// Accepts only characters suitable for a name
class NameTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        permittedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-' "
    }
}

// Accepts only numbers
class SSNTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        maxCharacters = 9
        permittedCharacters = "1234567890"
    }
    
    // Removes the dashes from ssn text field
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let currentText = textField.text?.replacingOccurrences(of: "-", with: "")
        textField.text = currentText
    }
    
    // Inserts dashes into the ssn text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let currentText = textField.text, currentText != "", currentText.count == 9 else {
            return
        }
        
        textField.text?.insert("-", at: (currentText.index((currentText.startIndex), offsetBy: 3)))
        textField.text?.insert("-", at: (currentText.index((currentText.startIndex), offsetBy: 6)))
    }
}

// Accepts only 5 numbers
class ZipcodeTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        maxCharacters = 5
        permittedCharacters = "1234567890"
    }
}

// Accepts only 2 letters, both are automatically capitalized
class StateTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        maxCharacters = 2
        permittedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.autocapitalizationType = .allCharacters
        self.autocorrectionType = .no
    }
}

// Values are captured from a picker instead of keyboard input
class CompanyTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        clearsOnBeginEditing = true
        
        // Creates a toolbar with a done button above the picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        toolbar.items = [flexSpace, button]
        self.inputAccessoryView = toolbar
    }
    
    // Dimsisses the picker when the done button is tapped
    @objc func doneTapped() {
        self.resignFirstResponder()
    }
    
    // Prevents keyboard presses to be entered as a picker is used instead
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
}

// Values are captured from a date picker instead of keyboard input
class DateOfBirthTextField: CustomTextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        clearsOnBeginEditing = true
        
        // Creates a toolbar with a done button above the picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        toolbar.items = [flexSpace, button]
        self.inputAccessoryView = toolbar
    }
    
    // Dimsisses the picker when the done button is tapped
    @objc func doneTapped() {
        self.resignFirstResponder()
    }
    
    // Prevents keyboard presses to be entered as a date picker is used instead
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
    
    // Upon entering the dateOfBirth text field the date picker is presented
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    // Once a value is selected from the date picker, it is formatted to MM/dd/yyy
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: sender.date)
        self.text = dateString
    }
}
