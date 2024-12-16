//
//  UserTopUpViewController.swift
//  newGramejia
//
//  Created by Putra  on 03/12/24.
//

import UIKit

class UserTopUpViewController: UIViewController {
    
    
    @IBOutlet weak var inputManualTopUp: UITextField!
    
    @IBOutlet weak var sepuluhBtn: UIButton!
    @IBOutlet weak var duapuluhBtn: UIButton!
    @IBOutlet weak var limapuluhBtn: UIButton!
    @IBOutlet weak var seratusBtn: UIButton!
    @IBOutlet weak var duaratusBtn: UIButton!
    @IBOutlet weak var limaratusBtn: UIButton!
    
    var onTopUpComplete: ((Int) -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addAmountToTextField(amount: Int) {
        let currentAmount = Int(inputManualTopUp.text ?? "0") ?? 0
        let newAmount = currentAmount + amount
        inputManualTopUp.text = "\(newAmount)"
    }
    
    
    @IBAction func sepuluhPress(_ sender: Any) {
        addAmountToTextField(amount: 10000)
    }
    
    @IBAction func duapuluhPress(_ sender: Any) {
        addAmountToTextField(amount: 20000)
    }
    
    @IBAction func limapuluhPress(_ sender: Any) {
        addAmountToTextField(amount: 50000)
    }
    
    @IBAction func seratusPress(_ sender: Any) {
        addAmountToTextField(amount: 100000)
    }
    
    @IBAction func duaratusPress(_ sender: Any) {
        addAmountToTextField(amount: 200000)
    }
    
    @IBAction func limaratusPress(_ sender: Any) {
        addAmountToTextField(amount: 500000)
    }
    
    
    @IBAction func topupBtn(_ sender: Any) {
        if let amountText = inputManualTopUp.text, let amount = Int(amountText), amount > 0 {
            
            var currentBalance = UserDefaults.standard.integer(forKey: "userBalance")
            currentBalance += amount

            UserDefaults.standard.set(currentBalance, forKey: "userBalance")
            UserDefaults.standard.synchronize()
            
            onTopUpComplete?(amount)
            dismiss(animated: true, completion: nil)
            
        } else {
            showAlert(title: "Invalid Amount", message: "Please enter a valid top-up amount.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
