//
//  Data.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct PersonalData {
    
    // Uncomment below to test personal info
    
    // Full personal info
    // Change dateOfBirth to test under 5 years old and happy b-day
    let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "10101")
    
    //DOB = nil
    //let personalInfo = PersonalInfo(dateOfBirth: nil, ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "10101")
    
    // SSN = ""
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "10101")
    
    // First name = nil
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: nil, lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "10101")
    
    // Last name = ""
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "10101")
    
    // Street address = nil
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: nil, city: "Gotham", state: "IL", zipCode: "10101")
    
    // City = ""
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "", state: "IL", zipCode: "10101")
    
    // State = nil
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: nil, zipCode: "10101")
    
    // Zipcode = ""
    //let personalInfo = PersonalInfo(dateOfBirth: "01/01/1970", ssn: "123-45-6789", firstName: "Bruce", lastName: "Wayne", streetAddress: "123 Bat Cave", city: "Gotham", state: "IL", zipCode: "")
    
}

struct ProjectData {
    
    static let projectNumbers = ["1001", "1002", "1003", "2001", "2002"]
}

struct VendorData {
    
    static let vendorNames = ["Acme", "Orkin", "Fedex", "NW Electrical"]
    
    // Uncomment below to test different vendors
    //static let vendorName = "Acme"
    //static let vendorName = "Orkin"
    //static let vendorName = "Fedex"
    static let vendorName = "NW Electrical"
}
