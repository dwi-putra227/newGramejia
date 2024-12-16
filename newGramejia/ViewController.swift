//
//  ViewController.swift
//  newGramejia
//
//  Created by Putra  on 24/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var usnameLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var mataVisiblePw: UIButton!
    
    var isPasswordVisible = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoginStatus()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logBtn(_ sender: Any) {
        let username = usnameLbl.text ?? ""
        let password = passwordLbl.text ?? ""

        if username.isEmpty || password.isEmpty {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }

        if username == "saya_admin" && password == "@admin227" {
            UserDefaults.standard.set(true, forKey: "isAdminLoggedIn")
            navigateToAdminHome()
        }
        else if let credentials = checkUserCredentials(username: username, password: password) {
            
            saveUserInfo(username: credentials.username, email: credentials.email)
            UserDefaults.standard.set(credentials.username, forKey: "loggedInUsername")
            UserDefaults.standard.set(credentials.email, forKey: "loggedInEmail")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
            UserDefaults.standard.synchronize()
            
            
            navigateToUserHome()
        } else {
            showAlert(title: "Error", message: "Invalid username or password")
        }
    }
    
    func setupPasswordField() {
        passwordLbl.isSecureTextEntry = true // Password awal disembunyikan
        mataVisiblePw.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Ikon mata tertutup
    }
    
    @IBAction func mataBtn(_ sender: Any) {
        isPasswordVisible.toggle() // Mengubah status visible/invisible
        passwordLbl.isSecureTextEntry = !isPasswordVisible

                // Mengganti ikon tombol berdasarkan status
        if isPasswordVisible {
            mataVisiblePw.setImage(UIImage(systemName: "eye"), for: .normal) // Ikon mata terbuka
        } else {
            mataVisiblePw.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Ikon mata tertutup
        }
    }
    
    
    
    func checkUserCredentials(username: String, password: String) -> (username: String, email: String)? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Persons")
        fetchRequest.predicate = NSPredicate(format: "personsUsername == %@ AND personsPassword == %@", username, password)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let user = result.first,
               let email = user.value(forKey: "personsEmail") as? String {
                return (username: username, email: email)
            }
        } catch {
            print("Failed to check user credentials: \(error)")
        }
        return nil
    }
    
    func checkLoginStatus() {
        if UserDefaults.standard.bool(forKey: "isAdminLoggedIn") {
                navigateToAdminHome()
            } else if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                navigateToUserHome()
            } else {
                print("Tidak ada user yang login, tetap di login screen")
            }
    }
    
    func saveUserInfo(username: String, email: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Persons")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let user = result.first {
                // Jika data sudah ada, perbarui data
                user.setValue(username, forKey: "personsUsername")
                user.setValue(email, forKey: "personsEmail")
            } else {
                // Jika data belum ada, buat data baru
                let newUser = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Persons", in: context)!, insertInto: context)
                newUser.setValue(username, forKey: "personsUsername")
                newUser.setValue(email, forKey: "personsEmail")
            }
            
            try context.save()
        } catch {
            print("Failed to save user data: \(error)")
        }
    }
    
    func navigateToAdminHome() {
        guard let adminHomeViewController = storyboard?.instantiateViewController(withIdentifier: "AdminHomeViewController") else {
            return
        }
        adminHomeViewController.modalPresentationStyle = .fullScreen
        present(adminHomeViewController, animated: true, completion: nil)
    }
    
    func navigateToUserHome() {
        guard let userHomeViewController = storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController") else {
            return
        }
        userHomeViewController.modalPresentationStyle = .fullScreen
        present(userHomeViewController, animated: true, completion: nil)
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func regBtn(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}

