//
//  DOBChecker.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

class DOBChecker {
    
    // Takes the dateOfBirth as a string and converts it to a date
    func getDOB(dateOfBirth: String) -> Date {
        
        let dobComponents = dateOfBirth.components(separatedBy: "/")
        let dateDOB = Calendar.current.date(from: DateComponents(year: Int(dobComponents[2]), month: Int(dobComponents[0]), day: Int(dobComponents[1])))!
        
        return dateDOB
    }
    
    // Takes the dateOfBirth as a string and returns an age
    func getAge(dateOfBirth: String) -> Int {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Calls getDOB to convert dateOfBirth string to a date
        let dateDOB = getDOB(dateOfBirth: dateOfBirth)
        
        // Extracts year component, as an Int, from date
        let ageComponents = calendar.dateComponents([.year], from: dateDOB, to: currentDate)
        let age = ageComponents.year!
        return age
    }
    
    // Checks date of birth as a date and returns a bool, indicating whether the date of birth matched the current date
    func checkForBirthDay(dateDOB: Date) -> Bool {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Extracts the month and day from the current date and birth date
        let currentDateMonth = calendar.component(.month, from: currentDate)
        let currentDateDay = calendar.component(.day, from: currentDate)
        let dobMonth = calendar.component(.month, from: dateDOB)
        let dobDay = calendar.component(.day, from: dateDOB)
        
        if currentDateMonth == dobMonth && currentDateDay == dobDay {
            return true
        } else {
            return false
        }
    }
}
