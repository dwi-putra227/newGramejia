//
//  UserListMusicalViewController.swift
//  newGramejia
//
//  Created by Putra  on 02/12/24.
//

import UIKit
import CoreData

class UserListMusicalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var namaPerson: UILabel!
    
    
    var instrumens: [Muscikal] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTableView.delegate = self
        userTableView.dataSource = self
        retrivInstruments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrivInstruments()
        userTableView.reloadData()
        displayUsername()
    }
    
    func displayUsername() {

        let username = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "Guest"

        namaPerson.text = "\(username)!"
    }
    
    func retrivInstruments() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Muscikal> = Muscikal.fetchRequest()
        
        do {
            instrumens = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch instruments: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instrumens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentsCellUser", for: indexPath) as? UserListMusicalTableViewCell else {
            fatalError("Failed to dequeue UserInstrumentCell")
        }
        let instrument = instrumens[indexPath.row]
        cell.configure(with: instrument)
        
        cell.tambahDiCart.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        guard let button = sender as? UIButton else { return }
        guard let indexPath = userTableView.indexPathForRow(at: button.convert(CGPoint.zero, to: userTableView)) else { return }

        let musical = instrumens[indexPath.row]
        addToCart(musical: musical)
    }
    
    func addToCart(musical: Muscikal) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<CartBarang> = CartBarang.fetchRequest()
        
        request.predicate = NSPredicate(format: "name == %@", musical.name ?? "")
        
        do {
            let existingCartItems = try context.fetch(request)
            
            if let existingCartItem = existingCartItems.first {
                existingCartItem.qty += 1
            } else {
                let newCartItem = CartBarang(context: context)
                newCartItem.name = musical.name
                newCartItem.brand = musical.brand
                newCartItem.price = musical.price
                newCartItem.qty = 1
            }
            
            try context.save()
            
            showAlert(title: "Success", message: "\(musical.name ?? "Item") has been added to your cart.")
        } catch {
            print("Error adding to cart: \(error)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func formatToRp(_ value: Double) -> String {
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "id_ID")
        formater.currencySymbol = "Rp"
        formater.maximumFractionDigits = 0
        return formater.string(from: NSNumber(value: value)) ?? "Rp0"
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
