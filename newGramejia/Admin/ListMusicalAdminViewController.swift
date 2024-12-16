//
//  ListMusicalAdminViewController.swift
//  newGramejia
//
//  Created by Putra  on 01/12/24.
//

import UIKit
import CoreData

class ListMusicalAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ListTableView: UITableView!
    var instruments: [Muscikal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListTableView.delegate = self
        ListTableView.dataSource = self
        // Do any additional setup after loading the view.
        retrivInstruments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrivInstruments()
        ListTableView.reloadData()
    }
    
    func retrivInstruments() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Muscikal> = Muscikal.fetchRequest()
        
        do {
            instruments = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch instruments: \(error)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instruments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentCell", for: indexPath) as? InstrumenTableViewCell else {
            return UITableViewCell()
        }
        
        let instrument = instruments[indexPath.row]
        cell.configure(with: instrument)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "forEdit", sender: indexPath)
    }
    
    
    @IBAction func floatingToAdd(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forEdit",
           let destination = segue.destination as? AddEdAdminViewController {
            if let indexPath = sender as? IndexPath {
                destination.instrumentToEdit = instruments[indexPath.row] // Edit
            } else {
                destination.instrumentToEdit = nil // Add
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(instruments[indexPath.row])
            
            do {
                try context.save()
                instruments.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete instrument: \(error)")
            }
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
