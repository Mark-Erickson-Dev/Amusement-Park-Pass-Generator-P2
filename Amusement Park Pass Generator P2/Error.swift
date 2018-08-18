//
//  Error.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

enum InfoError: Error {
    
    case InvalidFirstName, InvalidLastName, InvalidStreetAddress, InvalidCity, InvalidState, InvalidZipCode, InvalidDateOfBirth, InvalidChildAge, InvalidSSN, InvalidCompany, InvalidProjectNumber
    
    var description: String {
        
        switch self {
        case .InvalidFirstName: return "Enter a valid first name."
        case .InvalidLastName: return "Enter a valid last name."
        case .InvalidStreetAddress: return "Enter a valid street address."
        case .InvalidCity: return "Enter a valid city."
        case .InvalidState: return "Enter a valid state."
        case .InvalidZipCode: return "Enter a valid zip code."
        case .InvalidDateOfBirth: return "Enter a valid date of birth."
        case .InvalidChildAge: return "Child must be under 5 years old."
        case .InvalidSSN: return "Enter a valid social security number."
        case .InvalidCompany: return "Choose a company."
        case .InvalidProjectNumber: return "Choose a project number."
        }
    }
}
