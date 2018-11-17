//
//  PassViewController.swift
//  Amusement Park Pass Generator P2
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit
import AVFoundation

class PassViewController: UIViewController {
    
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var eyeletView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var projectCompanyLabel: UILabel!
    @IBOutlet weak var rideAccessLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchandiseDiscountLabel: UILabel!
    @IBOutlet weak var testResultsLabel: UILabel!
    
    @IBOutlet weak var areaAccessButton: UIButton!
    @IBOutlet weak var rideAccessButton: UIButton!
    @IBOutlet weak var discountAccessButton: UIButton!
    @IBOutlet weak var createNewPassButton: UIButton!
    
    @IBOutlet var areaAccessSubMenu: [UIButton]!
    @IBOutlet var rideAccessSubMenu: [UIButton]!
    @IBOutlet var discountAccessSubMenu: [UIButton]!
    
    let grantedColor = UIColor.init(red: 23/255.0, green: 173/255.0, blue: 43/255.0, alpha: 1.0)
    let deniedColor = UIColor.init(red: 171/255.0, green: 21/255.0, blue: 64/255.0, alpha: 1.0)
    let defaultBG = UIColor.init(red: 191/255.0, green: 185/255.0, blue: 196/255.0, alpha: 1.0)
    let defaultText = UIColor.init(red: 110/255.0, green: 106/255.0, blue: 113/255.0, alpha: 1.0)
    
    enum Access: String {
        
        case Granted = "Granted"
        case Denied = "Denied"
    }
    
    var entrant: Entrant?
    var menus = [[UIButton]]()
    var grantedAudioPlayer: AVAudioPlayer?
    var deniedAudioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menus = [areaAccessSubMenu, rideAccessSubMenu, discountAccessSubMenu]
        
        // All labels are initially empty
        nameLabel.text = ""
        passTypeLabel.text = ""
        projectCompanyLabel.text = ""
        setupViewsAndButtons()
        
        // All menus are initially hidden
        hideMenu(subMenu: areaAccessSubMenu)
        hideMenu(subMenu: rideAccessSubMenu)
        hideMenu(subMenu: discountAccessSubMenu)
        
        // Prepares the audio files for access granted and denied play back
        preparePlayer()
        
        // Sets the labels on the pass according to the entrant object recieved from ViewController
        configurePass()
    }
    
    // Displays an alert, after the view is loaded, if it is the entrant's birthday
    override func viewDidAppear(_ animated: Bool) {
        checkForBirthday()
    }
    
    // Checks date of birth and returns a bool, indicating whether the date of birth matched the current date
    func checkForBirthday() {
        
        if let entrant = entrant, let dateOfBirth = entrant.personalInfo?.dateOfBirth {
            let dateDOB = DOBChecker().getDOB(dateOfBirth: dateOfBirth)
            let result = DOBChecker().checkForBirthDay(dateDOB: dateDOB)
            
            // An alert is presented if it is the entrant's birthday
            if result {
                if let name = entrant.personalInfo?.firstName {
                    Alert.showAlert(title: "Birthday", message: "Happy B-Day, \(name)!", vc: self)
                } else {
                    Alert.showAlert(title: "Birthday", message: "Happy B-Day!", vc: self)
                }
            }
        }
    }
    
    // Checks the main bundle for audio files and creates players to play back the files
    func preparePlayer() {
        
        do {
            // If the audio file is found the grantedAudioPlayer is set
            if let grantedURL = Bundle.main.path(forResource: "AccessGranted", ofType: "wav") {
                grantedAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: grantedURL))
            }
            
            // If the audio file is found the deniedAudioPlayer is set
            if let deniedURL = Bundle.main.path(forResource: "AccessDenied", ofType: "wav") {
                deniedAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: deniedURL))
            }
            
        } catch let error {
            print("Cannot play audio file \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sets labels to display information on the pass, based on the entrant
    func configurePass() {
        
        guard let entrant = entrant else {
            return
        }
        
        if let personalInfo = entrant.personalInfo {
            if let firstName = personalInfo.firstName, let lastName = personalInfo.lastName {
                let fullName = firstName + " " + lastName
                nameLabel.text = fullName
            }
        }
        
        if entrant.passType == .Manager {
            if let managerType = entrant.managerType {
                passTypeLabel.text = managerType.rawValue
            }
        } else {
            passTypeLabel.text = entrant.passType.rawValue
        }
        
        if entrant.passType == .ContractEmployee {
            if let projectNumber = entrant.projectNumber {
                projectCompanyLabel.text = "Project #: \(projectNumber)"
            }
        }
        
        if entrant.passType == .Vendor {
            if let company = entrant.companyName, let projectNumber = entrant.projectNumber {
                projectCompanyLabel.text = "Project #: \(projectNumber) - \(company)"
            }
        }
        
        rideAccessLabel.text = entrant.rideAccess.rawValue
        foodDiscountLabel.text = "Food Discount: \(Int(entrant.foodDiscount * 100))%"
        merchandiseDiscountLabel.text = "Merchandise Discount: \(Int(entrant.merchandiseDiscount * 100))%"
    }
    
    // MARK: - Main Menu
    
    // Shows sub menu based on the main menu button tapped
    @IBAction func mainMenuButtonTapped(_ sender: UIButton) {
        
        // Which button is tapped is identified by the title
        let buttonTitle = sender.titleLabel?.text
        
        switch buttonTitle {
            
        case "Area Access":
            showSubMenu(menuToShow: areaAccessSubMenu)
        case "Ride Access":
            showSubMenu(menuToShow: rideAccessSubMenu)
        case "Discount Access":
            showSubMenu(menuToShow: discountAccessSubMenu)
        default:
            return
        }
    }
    
    // MARK: - Swipe Methods
    
    // Tests whether or not an entrant has access to certain areas, rides, line skipping, or discounts
    // A message is printed to show the result
    @IBAction func swipeTestButtonTapped(_ sender: UIButton) {
        
        // Which button is tapped is identified by the title
        let buttonTitle = sender.titleLabel?.text
        
        if let entrant = entrant {
            switch(buttonTitle) {
                
            case "Amusement":
                let message = "Amusement Area Access:"
                let result = shouldGrantAccess(isGranted: entrant.isAmusementAreaAccesible)
                displayTestResult(message: message, result: result)
            case "Kitchen":
                let message = "Kitchen Area Access:"
                let result = shouldGrantAccess(isGranted: entrant.isKitchenAreaAccessible)
                displayTestResult(message: message, result: result)
            case "Ride Control":
                let message = "Ride Control Area Access:"
                let result = shouldGrantAccess(isGranted: entrant.isRideControlAreaAccessible)
                displayTestResult(message: message, result: result)
            case "Maintenance":
                let message = "Maintenance Area Access:"
                let result = shouldGrantAccess(isGranted: entrant.isMaintenanceAreaAccessible)
                displayTestResult(message: message, result: result)
            case "Office":
                let message = "Office Area Access:"
                let result = shouldGrantAccess(isGranted: entrant.isOfficeAreaAccessible)
                displayTestResult(message: message, result: result)
            case "Ride Access":
                let message = "Ride Access:"
                let result = shouldGrantAccess(isGranted: entrant.rideAccess == .PriorityRider || entrant.rideAccess == .StandardRider)
                displayTestResult(message: message, result: result)
            case "Skip Lines":
                let message = "Line Skipping:"
                let result = shouldGrantAccess(isGranted: entrant.rideAccess == .PriorityRider)
                displayTestResult(message: message, result: result)
            case "Food Discount":
                let message = "Food Discount:"
                let result = shouldGrantAccess(isGranted: entrant.foodDiscount > 0.00)
                displayTestResult(message: message, result: result, discount: entrant.foodDiscount)
            case "Merchandise Discount":
                let message = "Merchandise Discount:"
                let result = shouldGrantAccess(isGranted: entrant.merchandiseDiscount > 0.00)
                displayTestResult(message: message, result: result, discount: entrant.merchandiseDiscount)
            default:
                return
            }
        }
    }
    
    // Returns a bool value and plays a sound indicating if access is granted or denied
    func shouldGrantAccess(isGranted: Bool) -> Bool {
        
        testResultsLabel.textColor = UIColor.white
        
        if isGranted {
            
            grantedAudioPlayer?.currentTime = 0
            grantedAudioPlayer?.play()
            
            return true
            
        } else {
            deniedAudioPlayer?.currentTime = 0
            deniedAudioPlayer?.play()
            
            return false
        }
    }
    
    // Displays a message indicating whether access was granted or denied - used for area and ride access
    func displayTestResult(message: String, result: Bool) {
        
        testResultsLabel.textColor = UIColor.white
        
        if result {
            testResultsLabel.backgroundColor = grantedColor
            testResultsLabel.text = "\(message) \(Access.Granted.rawValue)"
        } else {
            testResultsLabel.backgroundColor = deniedColor
            testResultsLabel.text = "\(message) \(Access.Denied.rawValue)"
        }
    }
    
    // Displays a message indicating whether access was granted or denied - used for discounts
    func displayTestResult(message: String, result: Bool, discount: Double) {
        
        testResultsLabel.textColor = UIColor.white
        
        if result {
            testResultsLabel.backgroundColor = grantedColor
            testResultsLabel.text = "\(message) \(Int(discount * 100))%"
        } else {
            testResultsLabel.backgroundColor = deniedColor
            testResultsLabel.text = "\(message) \(Int(discount * 100))%"
        }
    }
    
    // Dismisses the PassViewController
    @IBAction func createNewPassPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion:nil)
    }
    
    // MARK: - UI
    
    // Set up views with rounded corners
    func setupViewsAndButtons() {
        
        passView.layer.cornerRadius = 10
        eyeletView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        testResultsLabel.layer.masksToBounds = true
        testResultsLabel.layer.cornerRadius = 5
        
        areaAccessButton.layer.cornerRadius = 5
        rideAccessButton.layer.cornerRadius = 5
        discountAccessButton.layer.cornerRadius = 5
        createNewPassButton.layer.cornerRadius = 5
    }
    
    // Shows the sub menu corresponding to the main menu choice, and hides the other sub menus
    func showSubMenu(menuToShow: [UIButton]) {
        
        resetTestResults()
        
        for menu in menus {
            if menuToShow == menu {
                showMenu(subMenu: menu)
            } else {
                hideMenu(subMenu: menu)
            }
        }
    }
    
    // Shows all of the buttons in a menu collection
    func showMenu(subMenu: [UIButton]) {
        
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
    
    // Resets test result area to default values
    func resetTestResults() {
        
        testResultsLabel.text = "Test Results"
        testResultsLabel.textColor = defaultText
        testResultsLabel.backgroundColor = defaultBG
    }
    
}
