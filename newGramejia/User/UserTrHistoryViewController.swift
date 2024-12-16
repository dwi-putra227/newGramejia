//
//  UserTrHistoryViewController.swift
//  newGramejia
//
//  Created by Putra  on 07/12/24.
//

import UIKit
import CoreData

class UserTrHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabelPiuw: UITableView!
    
    var transaksi: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tabelPiuw.delegate = self
        tabelPiuw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrivTransactionHistory()
        tabelPiuw.reloadData()
    }
    
    func retrivTransactionHistory() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            transaksi = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch transaction history: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaksi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transaksiCell", for: indexPath) as? UserTrHistoryTableViewCell else {
            fatalError("Failed to dequeue TransactionCell")
        }
        
        let transaction = transaksi[indexPath.row]
        cell.config(with: transaction)
        return cell
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
