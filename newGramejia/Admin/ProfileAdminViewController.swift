//
//  ProfileAdminViewController.swift
//  newGramejia
//
//  Created by Putra  on 29/11/24.
//

import UIKit

class ProfileAdminViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutBtnToLog(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isAdminLoggedIn")
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
        UserDefaults.standard.removeObject(forKey: "loggedInEmail")
        
        navigateToLogin()
    }
    
    
    func navigateToLogin() {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
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
