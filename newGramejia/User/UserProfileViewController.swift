//
//  UserProfileViewController.swift
//  newGramejia
//
//  Created by Putra  on 29/11/24.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var usnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var totalBalanceLbl: UILabel!
    
    var balance: Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUserInfo()
        loadBalance()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBalance()
        updateBalanceLabel()
    }
    
    func updateBalanceLabel() {
        totalBalanceLbl.text = " Rp\(Int(balance))"
    }
    
    func loadBalance() {
        balance = UserDefaults.standard.integer(forKey: "userBalance")
        updateBalanceLabel()
    }
    
    @IBAction func topUpClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let topUpVC = storyboard.instantiateViewController(withIdentifier: "PunyaTopUp") as? UserTopUpViewController {
            topUpVC.onTopUpComplete = { [weak self] topUpAmount in
                guard let self = self else { return }
                self.balance += topUpAmount
                UserDefaults.standard.set(self.balance, forKey: "userBalance")
                self.updateBalanceLabel()
            }
            present(topUpVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func logBtnToLog(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
        UserDefaults.standard.removeObject(forKey: "loggedInEmail")
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        navigateToLogin()
    }
    
    
    func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
    func displayUserInfo() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Persons")
        
        do {
            let result = try context.fetch(fetchRequest)
            if let user = result.first {
                let username = user.value(forKey: "personsUsername") as? String ?? "N/A"
                let email = user.value(forKey: "personsEmail") as? String ?? "N/A"
                
                print("Fetched username: \(username), email: \(email)")
                
                usnameLbl.text = "\(username)"
                emailLbl.text = "\(email)"
            } else {
                print("User not found in Core Data")
                usnameLbl.text = "User not found"
                emailLbl.text = "Email not found"
            }
        } catch {
            print("Failed to fetch user data: \(error)")
            usnameLbl.text = "Error"
            emailLbl.text = "Error"
        }
    }
    
    func saveUserInfo(username: String, email: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Persons")
        
        do {
            let result = try context.fetch(fetchRequest)

            if let user = result.first {
                user.setValue(username, forKey: "personsUsername")
                user.setValue(email, forKey: "personsEmail")
            } else {
                let newUser = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Persons", in: context)!, insertInto: context)
                newUser.setValue(username, forKey: "personsUsername")
                newUser.setValue(email, forKey: "personsEmail")
            }
            
            try context.save()
        } catch {
            print("Failed to save user data: \(error)")
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


