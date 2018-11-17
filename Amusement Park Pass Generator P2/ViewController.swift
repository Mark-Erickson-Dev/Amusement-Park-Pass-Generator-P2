//
//  ViewController.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainMenu: UIStackView!
    @IBOutlet weak var subMenu: UIStackView!
    
    @IBOutlet var guestSubMenu: [UIButton]!
    @IBOutlet var employeeSubMenu: [UIButton]!
    @IBOutlet var managerSubMenu: [UIButton]!
    var projectNumberSubMenu = [UIButton]()
    
    @IBOutlet weak var dateOfBirthText: UITextField!
    @IBOutlet weak var ssnText: UITextField!
    @IBOutlet weak var projectNumberText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var streetAddressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipCodeText: UITextField!
    
    @IBOutlet var allTextFields: [UITextField]!
    @IBOutlet var personalInfoTexts: [UITextField]!
    
    @IBOutlet weak var generatePass: UIButton!
    @IBOutlet weak var populateData: UIButton!
    
    let mainMenuColor = UIColor.init(red: 119/255.0, green: 86/255.0, blue: 153/255.0, alpha: 1.0)
    let subMenuColor = UIColor.init(red: 48/255.0, green: 40/255.0, blue: 56/255.0, alpha: 1.0)
    let backgroundColor = UIColor.init(red: 210/255.0, green: 204/255.0, blue: 215/255.0, alpha: 1.0)
    
    let dummyButton = UIButton()
    var entrant: Entrant!
    var menus = [[UIButton]]()
    var companyPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A company picker view is used to get the company instead of keyboard input
        companyPicker.dataSource = self
        companyPicker.delegate = self
        companyText.inputView = companyPicker
        
        // Creates a menu of buttons for each project number
        let projectNumbers = ProjectData.projectNumbers
        for number in projectNumbers {
            let button = UIButton()
            button.backgroundColor = subMenuColor
            button.setTitle(number, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(ViewController.projectNumberSelected(_:)), for: .touchUpInside)
            
            // Buttons are added to a collection to act as a submenu
            projectNumberSubMenu.append(button)
        }
        
        // The project number sub menu collection is added to the subMenu stackView
        for item in projectNumberSubMenu {
            
            subMenu.addArrangedSubview(item)
        }
        
        // Initial set up of the menus
        setupInitialSubmenus()
        menus = [guestSubMenu, employeeSubMenu, managerSubMenu, projectNumberSubMenu]
        
        generatePass.layer.cornerRadius = 5
        populateData.layer.cornerRadius = 5
        
        // Disables generate pass at launch
        disableGeneratePass()
    }
    
    // Resets the UI and sets up the menus each time this view controller is presented after returning from the PassViewController
    override func viewWillAppear(_ animated: Bool) {
        
        disableGeneratePass()
        resetAllText()
        setupInitialSubmenus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // All sub menu items and text fields are hidden at start
    func setupInitialSubmenus() {
        
        hideMenu(subMenu: guestSubMenu)
        hideMenu(subMenu: employeeSubMenu)
        hideMenu(subMenu: managerSubMenu)
        hideMenu(subMenu: projectNumberSubMenu)
        
        dummyButton.backgroundColor = subMenuColor
        subMenu.addArrangedSubview(dummyButton)
        
        hideTextFields(textFields: allTextFields)
    }
    
    // Attempts to generate a pass based on menu choices and text input
    @IBAction func generatePassPressed(_ sender: AnyObject) {
        
        do {
            
            // Get the entrant's personal information, if applicable, and validates it
            if entrant.personalInfoIsRequired {
                
                try validatePersonalInfo(entrant: entrant)
                print(entrant.personalInfo ?? "")
            }
            
            // For vendors, company name and project number are validated and access is set
            if entrant.passType == .Vendor {
                
                entrant.companyName = try validateCompanyName()
                entrant.projectNumber = try validateProjectNumber()
                setVendorAccess(entrant: entrant)
            }
            
            // For contractors, project number is validated and access is set
            if entrant.passType == .ContractEmployee {
                
                entrant.projectNumber = try validateProjectNumber()
                setContractorAccess(entrant: entrant)
            }
            
        } catch InfoError.InvalidDateOfBirth {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidDateOfBirth.description, vc: self)
            
        } catch InfoError.InvalidChildAge {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidChildAge.description, vc: self)
            
        } catch InfoError.InvalidSSN {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidSSN.description, vc: self)
            
        } catch InfoError.InvalidFirstName {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidFirstName.description, vc: self)
            
        } catch InfoError.InvalidLastName {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidLastName.description, vc: self)
            
        } catch InfoError.InvalidStreetAddress {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidStreetAddress.description, vc: self)
            
        } catch InfoError.InvalidCity {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidCity.description, vc: self)
            
        } catch InfoError.InvalidState {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidState.description, vc: self)
            
        } catch InfoError.InvalidZipCode {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidZipCode.description, vc: self)
            
        } catch InfoError.InvalidCompany {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidCompany.description, vc: self)
            
        } catch InfoError.InvalidProjectNumber {
            Alert.showAlert(title: "Info Error", message: InfoError.InvalidProjectNumber.description, vc: self)
            
        } catch let error {
            print(error)
        }
    }
    
    // When a pass is generated, the entrant object is passed to the PassViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPass" {
            if let destinationVC = segue.destination as? PassViewController {
                
                destinationVC.entrant = entrant
            }
        }
    }
    
    // Pressing the Populate Data button, automatically populates the text fields with data from the Data object
    @IBAction func populateDataPressed(_ sender: AnyObject) {
        
        let personalInfo = PersonalData().personalInfo
        
        if dateOfBirthText.isEnabled {
            dateOfBirthText.text = personalInfo.dateOfBirth
        }
        
        if ssnText.isEnabled {
            ssnText.text = personalInfo.ssn
        }
        
        if firstNameText.isEnabled {
            firstNameText.text = personalInfo.firstName
        }
        
        if lastNameText.isEnabled {
            lastNameText.text = personalInfo.lastName
        }
        
        if companyText.isEnabled {
            companyText.text = VendorData.vendorName
        }
        
        if streetAddressText.isEnabled {
            streetAddressText.text = personalInfo.streetAddress
        }
        
        if cityText.isEnabled {
            cityText.text = personalInfo.city
        }
        
        if stateText.isEnabled {
            stateText.text = personalInfo.state
        }
        
        if zipCodeText.isEnabled {
            zipCodeText.text = personalInfo.zipCode
        }
    }
    
    // MARK: - Validation
    
    // Checks for required data from the personalInfo object, missing data reults in an error message being thrown
    func validatePersonalInfo(entrant: Entrant) throws {
        
        // Initializes a personalInfo object
        var personalInfo = PersonalInfo(dateOfBirth: nil, ssn: nil, firstName: nil, lastName: nil, streetAddress: nil, city: nil, state: nil, zipCode: nil)
        
        // Gets the dateOfBirth from the text field, provided it is not nil or empty
        if dateOfBirthText.isEnabled {
            
            guard let dateOfBirth = dateOfBirthText.text, dateOfBirth != "" else {
                
                throw InfoError.InvalidDateOfBirth
            }
            
            // Gets the age from the date of birth string
            let age = DOBChecker().getAge(dateOfBirth: dateOfBirth)
            
            // Checks if a child is older than 5
            if entrant.passType == .FreeChildGuest {
                guard age < 5 else {
                    
                    throw InfoError.InvalidChildAge
                }
            }
            
            personalInfo.dateOfBirth = dateOfBirth
        }
        
        // Gets the ssn from the text field, provided it is not nil or empty
        if ssnText.isEnabled {
            
            guard let ssn = ssnText.text, ssn != "" else {
                
                throw InfoError.InvalidSSN
            }
            
            personalInfo.ssn = ssn
        }
        
        // Gets the firstName and lastName from the text fields, provided they are not nil or empty
        if firstNameText.isEnabled {
            
            guard let firstName = firstNameText.text, firstName != "" else {
                
                throw InfoError.InvalidFirstName
            }
            
            guard let lastName = lastNameText.text, lastName != "" else {
                
                throw InfoError.InvalidLastName
            }
            
            personalInfo.firstName = firstName
            personalInfo.lastName = lastName
        }
        
        // Gets the streetAddress, city, state, and zipCode from the text fields, provided they are not nil or empty
        if streetAddressText.isEnabled {
            
            guard let streetAddress = streetAddressText.text, streetAddress != "" else {
                
                throw InfoError.InvalidStreetAddress
            }
            
            guard let city = cityText.text, city != "" else {
                
                throw InfoError.InvalidCity
            }
            
            guard let state = stateText.text, state != "" else {
                
                throw InfoError.InvalidState
            }
            
            guard let zipCode = zipCodeText.text, zipCode != "" else {
                
                throw InfoError.InvalidZipCode
            }
            
            personalInfo.streetAddress = streetAddress
            personalInfo.city = city
            personalInfo.state = state
            personalInfo.zipCode = zipCode
        }
        
        // The validated personalnInfo object is set to the entrant personalInfo object
        entrant.personalInfo = personalInfo
    }
    
    // Gets the companyName from the text field, provided it is not nil or empty
    func validateCompanyName() throws -> String {
        
        guard let companyName = companyText.text, companyName != "" else {
            
            throw InfoError.InvalidCompany
        }
        
        return companyName
    }
    
    // Gets the projectNumber from the text field, provided it is not nil or empty
    func validateProjectNumber() throws -> String {
        
        guard let projectNumber = projectNumberText.text, projectNumber != "" else {
            
            throw InfoError.InvalidProjectNumber
        }
        
        return projectNumber
    }
    
    // MARK: - Contractor/Vendor Access
    
    // Sets the contractor's access based on project number
    // All access is false by default, so each case switches certain access to true
    func setContractorAccess(entrant: Entrant) {
        
        switch entrant.projectNumber {
            
        case "1001":
            entrant.isAmusementAreaAccesible = !entrant.isAmusementAreaAccesible
            entrant.isRideControlAreaAccessible = !entrant.isRideControlAreaAccessible
            
        case "1002":
            entrant.isAmusementAreaAccesible = !entrant.isAmusementAreaAccesible
            entrant.isRideControlAreaAccessible = !entrant.isRideControlAreaAccessible
            entrant.isMaintenanceAreaAccessible = !entrant.isMaintenanceAreaAccessible
            
        case "1003":
            entrant.isAmusementAreaAccesible = !entrant.isAmusementAreaAccesible
            entrant.isKitchenAreaAccessible = !entrant.isKitchenAreaAccessible
            entrant.isRideControlAreaAccessible = !entrant.isRideControlAreaAccessible
            entrant.isMaintenanceAreaAccessible = !entrant.isMaintenanceAreaAccessible
            entrant.isOfficeAreaAccessible = !entrant.isOfficeAreaAccessible
            
        case "2001":
            entrant.isOfficeAreaAccessible = !entrant.isOfficeAreaAccessible
            
        case "2002":
            entrant.isKitchenAreaAccessible = !entrant.isKitchenAreaAccessible
            entrant.isMaintenanceAreaAccessible = !entrant.isMaintenanceAreaAccessible
            
        default:
            return
        }
    }
    
    // Setst the vendor's access based on company name
    // All access is false by default, so each case switches certain access to true
    func setVendorAccess(entrant: Entrant) {
        
        switch entrant.companyName {
            
        case "Acme":
            entrant.isKitchenAreaAccessible = !entrant.isKitchenAreaAccessible
            
        case "Orkin":
            entrant.isAmusementAreaAccesible = !entrant.isAmusementAreaAccesible
            entrant.isKitchenAreaAccessible = !entrant.isKitchenAreaAccessible
            entrant.isRideControlAreaAccessible = !entrant.isRideControlAreaAccessible
            
        case "Fedex":
            entrant.isMaintenanceAreaAccessible = !entrant.isMaintenanceAreaAccessible
            entrant.isOfficeAreaAccessible = !entrant.isOfficeAreaAccessible
            
        case "NW Electrical":
            entrant.isAmusementAreaAccesible = !entrant.isAmusementAreaAccesible
            entrant.isKitchenAreaAccessible = !entrant.isKitchenAreaAccessible
            entrant.isRideControlAreaAccessible = !entrant.isRideControlAreaAccessible
            entrant.isMaintenanceAreaAccessible = !entrant.isMaintenanceAreaAccessible
            entrant.isOfficeAreaAccessible = !entrant.isOfficeAreaAccessible
            
        default:
            return
        }
    }
    
    // MARK: - Main Menu
    
    // Tapping a button on the main menu presents the appropriate sub menu
    @IBAction func mainMenuButtonTapped(_ sender: UIButton) {
        
        // Which button is tapped is identified by the title
        let buttonTitle = sender.titleLabel?.text
        
        switch buttonTitle {
        case "Guest":
            showSubMenu(menuToShow: guestSubMenu)
        case "Employee":
            showSubMenu(menuToShow: employeeSubMenu)
        case "Manager":
            showSubMenu(menuToShow: managerSubMenu)
        case "Contractor":
            entrant = ContractEmployee()
            showSubMenu(menuToShow: projectNumberSubMenu)
        case "Vendor":
            entrant = Vendor()
            showSubMenu(menuToShow: projectNumberSubMenu)
        default:
            return
        }
    }
    
    // MARK: - Sub Menu
    
    // Tapping a button on the submenu initializes an entrant object and shows the appropriate text fields
    @IBAction func subMenuButtonTapped(_ sender: UIButton) {
        
        // Which button is tapped is identified by the title
        let buttonTitle = sender.titleLabel?.text
        
        // All text fields are disabled until a selection is made
        resetAllText()
        
        switch buttonTitle {
            
        case "Child":
            dateOfBirthText.backgroundColor = UIColor.white
            dateOfBirthText.isEnabled = true
            entrant = FreeChildGuest()
        case "Classic":
            entrant = ClassicGuest()
        case "Senior Guest":
            firstNameText.backgroundColor = UIColor.white
            firstNameText.isEnabled = true
            lastNameText.backgroundColor = UIColor.white
            lastNameText.isEnabled = true
            dateOfBirthText.backgroundColor = UIColor.white
            dateOfBirthText.isEnabled = true
            entrant = SeniorGuest()
        case "VIP":
            entrant = VIPGuest()
        case "Season Pass":
            showTextFields(textFields: personalInfoTexts)
            ssnText.backgroundColor = backgroundColor
            ssnText.isEnabled = false
            entrant = SeasonPassGuest()
        case "Food Services":
            showTextFields(textFields: personalInfoTexts)
            entrant = FoodServicesEmployee()
        case "Ride Services":
            showTextFields(textFields: personalInfoTexts)
            entrant = RideServicesEmployee()
        case "Maintenance":
            showTextFields(textFields: personalInfoTexts)
            entrant = MaintenanceEmployee()
        case "Senior Manager":
            showTextFields(textFields: personalInfoTexts)
            entrant = Manager(managerType: Entrant.ManagerType.SeniorManager)
        case "General Manager":
            showTextFields(textFields: personalInfoTexts)
            entrant = Manager(managerType: Entrant.ManagerType.GeneralManager)
        case "Shift Manager":
            showTextFields(textFields: personalInfoTexts)
            entrant = Manager(managerType: Entrant.ManagerType.ShiftManager)
        default:
            return
        }
        
        // Generate Pass button is enabled after an entrant type is selected
        enableGeneratePass()
    }
    
    // Tapping a project number shows the appropriate text fields
    @objc func projectNumberSelected(_ sender: UIButton) {
        
        if let selection = sender.currentTitle {
            projectNumberText.text = selection
            
            if entrant.passType == .Vendor {
                companyText.backgroundColor = UIColor.white
                companyText.isEnabled = true
            }
            
            showTextFields(textFields: personalInfoTexts)
            enableGeneratePass()
        }
    }
    
    // MARK: - UI
    
    // Shows the sub menu corresponding to the main menu choice, and hides the other sub menus
    func showSubMenu(menuToShow: [UIButton]) {
        
        // Hides all the textfields
        resetAllText()
        
        for menu in menus {
            if menuToShow == menu {
                showMenu(subMenu: menu)
            } else {
                hideMenu(subMenu: menu)
            }
        }
        
        // Disables Generate Pass until a sub menu choice is made
        disableGeneratePass()
    }
    
    // Shows all of the buttons in a menu collection
    func showMenu(subMenu: [UIButton]) {
        
        dummyButton.removeFromSuperview()
        
        for item in subMenu {
            item.isHidden = false
        }
    }
    
    // Hides all of the buttons in a menu collection
    func hideMenu(subMenu: [UIButton]) {
        
        for item in subMenu {
            item.isHidden = true
        }
    }
    
    // Shows all of the text fields in a collection
    func showTextFields(textFields: [UITextField]) {
        
        for item in textFields {
            item.backgroundColor = UIColor.white
            item.isEnabled = true
        }
    }
    
    // Hides all of the text fields in a collection
    func hideTextFields(textFields: [UITextField]) {
        
        for item in textFields {
            item.backgroundColor = backgroundColor
            item.isEnabled = false
        }
    }
    
    // Sets all of the text fields in a collection to an empty string and hides the text field
    func resetAllText() {
        
        for item in allTextFields {
            item.text = ""
        }
        
        hideTextFields(textFields: allTextFields)
    }
    
    // Enables Generate Pass button and changes to active color
    func enableGeneratePass() {
        generatePass.isEnabled = true
        generatePass.backgroundColor = #colorLiteral(red: 0.3058823529, green: 0.5411764706, blue: 0.5176470588, alpha: 1)
    }
    
    // Disables Generate Pass button and changes to inactive color
    func disableGeneratePass() {
        generatePass.isEnabled = false
        generatePass.backgroundColor = UIColor.gray
    }
    
}

// MARK: - Company PickerView

// A picker view is used to set the company name instead of keyboard input
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows is determined by the number of values in the vendorNames array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return VendorData.vendorNames.count
    }
    
    // The data for the rows of the picker come from the vendorNames array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return VendorData.vendorNames[row]
    }
    
    // The company text field is set to the value chosen from the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        companyText.text = VendorData.vendorNames[row]
    }
}

