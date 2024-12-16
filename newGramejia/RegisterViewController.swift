//
//  RegisterViewController.swift
//  newGramejia
//
//  Created by Putra  on 24/11/24.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usnameLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var togglePw: UIButton!
    
    var isPasswordVisible = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPasswordField()
        
    }
    
    func setupPasswordField() {
        passwordLbl.isSecureTextEntry = true // Password awal disembunyikan
        togglePw.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Ikon mata tertutup
    }
    
    @IBAction func togglePwVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle() // Mengubah status visible/invisible
        passwordLbl.isSecureTextEntry = !isPasswordVisible

                // Mengganti ikon tombol berdasarkan status
        if isPasswordVisible {
            togglePw.setImage(UIImage(systemName: "eye"), for: .normal) // Ikon mata terbuka
        } else {
            togglePw.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Ikon mata tertutup
        }
    }
    
    
    @IBAction func logBtn(_ sender: Any) {
        
    }
    
    @IBAction func regBtn(_ sender: Any) {
        let username = usnameLbl.text ?? ""
        let email = emailLbl.text ?? ""
        let password = passwordLbl.text ?? ""
        
        if username.isEmpty || email.isEmpty || password.isEmpty {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        if isUsernameAvailable(username: username) {
            if saveUser(username: username, email: email, password: password) {
                showAlert(title: "Success", message: "Registration successful")
            } else {
                showAlert(title: "Error", message: "Failed to register")
            }
        } else {
            showAlert(title: "Error", message: "Username already taken")
        }
    }
    
    func saveUser(username: String, email: String, password: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Persons", in: context) else {
            print("Entity description not found")
            return false
        }
        
        let newPerson = NSManagedObject(entity: entityDescription, insertInto: context)
        
        newPerson.setValue(username, forKey: "personsUsername")
        newPerson.setValue(email, forKey: "personsEmail")
        newPerson.setValue(password, forKey: "personsPassword")
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save user: \(error)")
            return false
        }
    }
    
    func isUsernameAvailable(username: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Persons")
        fetchRequest.predicate = NSPredicate(format: "personsUsername == %@", username)
        do {
            let result = try context.fetch(fetchRequest)
            return result.isEmpty
        } catch {
            print("Failed to check username availability: \(error)")
            return false
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
