//
//  UserCartViewController.swift
//  newGramejia
//
//  Created by Putra  on 03/12/24.
//

import UIKit
import CoreData

class UserCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usnameLbl: UILabel!
    @IBOutlet weak var totalPrise: UILabel!
    @IBOutlet weak var viewCartTable: UITableView!
    @IBOutlet weak var namaPerson: UILabel!
    
    
    var currentBalance: Int = 0
    var cartItems: [CartBarang] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCartTable.delegate = self
        viewCartTable.dataSource = self
        retrivCartItems()
        updateTotalPrice()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrivCartItems()
        updateTotalPrice()
        loadCurrentBalance()
        displayPerson()
    }
    
    func displayPerson() {
        let username = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "Guest"
        
        namaPerson.text = "\(username)!"
    }
    
    func retrivCartItems() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartBarang> = CartBarang.fetchRequest()
        
        do {
            cartItems = try context.fetch(fetchRequest)
            for item in cartItems {
                print("Fetched Item - Name: \(item.name ?? ""), Brand: \(item.brand ?? ""), Price: \(item.price), Qty: \(item.qty)")
            }
            
            viewCartTable.reloadData()
            updateTotalPrice()
        } catch {
            print("Failed to fetch cart items: \(error)")
        }
    }
    
    func updateTotalPrice() {
        let total = cartItems.reduce(0) { total, item in
                total + (Int(item.price) * Int(item.qty))
            }
        totalPrise.text = formatToRupiah(Double(total))
    }
    
    func formatToRupiah(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "id_ID")
            formatter.currencySymbol = "Rp"
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "Rp0"
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCartTable", for: indexPath) as? UserCartTableViewCell else {
            fatalError("Failed to dequeue CartItemCell")
        }
        
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem)

        cell.tambahBtn.tag = indexPath.row
        cell.kurangBtn.tag = indexPath.row
        
        cell.tambahBtn.addTarget(self, action: #selector(tambahQty(_:)), for: .touchUpInside)
        cell.kurangBtn.addTarget(self, action: #selector(kurangQty(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func tambahQty(_ sender: UIButton) {
        let index = sender.tag
        cartItems[index].qty += 1
        saveContext()
        viewCartTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        updateTotalPrice()
    }
    
    @objc func kurangQty(_ sender: UIButton) {
        let index = sender.tag
        if cartItems[index].qty > 1 {
            cartItems[index].qty -= 1
            saveContext()
            viewCartTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            updateTotalPrice()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(cartItems[indexPath.row])
            cartItems.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            updateTotalPrice()
        }
    }
    
    @IBAction func cekoutBtn(_ sender: Any) {
        let totalHarga = cartItems.reduce(0) { $0 + (Int($1.price) * Int($1.qty)) }
        
        if currentBalance >= totalHarga {
            buatCheckout()
        } else {
            showAlertForInsufficientFunds()
        }
    }
    
    func buatCheckout() {
        let totalHarga = cartItems.reduce(0.0) { $0 + ($1.price * Double($1.qty)) }
        
        saveTransaction(
            name: "Doing Checkout",
            status: "Success",
            totalPrice: totalHarga
        )

        currentBalance -= Int(totalHarga)
        UserDefaults.standard.set(currentBalance, forKey: "userBalance")
        UserDefaults.standard.synchronize()

        clearCart()

        showAlert(title: "Success", message: "Checkout succeeded!")
    }
    
    func loadCurrentBalance() {
        currentBalance = Int(UserDefaults.standard.double(forKey: "userBalance"))
    }
    
    func clearCart() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for item in cartItems {
            context.delete(item)
        }
        cartItems.removeAll()
        
        do {
            try context.save()
        } catch {
            print("Failed to clear cart: \(error)")
        }
        viewCartTable.reloadData()
        updateTotalPrice()
    }
    
    func saveTransaction(name: String, status: String, totalPrice: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newTransaction = Transaction(context: context)
        newTransaction.name = name
        newTransaction.stts = status
        newTransaction.totalPrise = totalPrice
        
        do {
            try context.save()
            print("Transaction saved successfully.")
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
        
    func updateBalanceUI() {

    }
        
    func showAlertForInsufficientFunds() {
        let alert = UIAlertController(title: "Insufficient funds", message: "You have an insufficient balance to checkout. Please go ahead and top-up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveContext() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
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
