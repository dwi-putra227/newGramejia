//
//  AddEdAdminViewController.swift
//  newGramejia
//
//  Created by Putra  on 01/12/24.
//

import UIKit

class AddEdAdminViewController: UIViewController {
    
    @IBOutlet weak var nameTxtFild: UITextField!
    @IBOutlet weak var brandTxtFild: UITextField!
    @IBOutlet weak var catTxtFild: UITextField!
    @IBOutlet weak var priceTxtFild: UITextField!
    
    var instrumentToEdit: Muscikal?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let instrument = instrumentToEdit {
            nameTxtFild.text = instrument.name
            brandTxtFild.text = instrument.brand
            catTxtFild.text = instrument.category
            priceTxtFild.text = "\(instrument.price)"
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addToListOrEdit(_ sender: Any) {
        if instrumentToEdit != nil {
            updetInstruments()
        } else {
            saveInstrument()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func saveInstrument() {
        guard let names = nameTxtFild.text,
              let brands = brandTxtFild.text,
              let categorys = catTxtFild.text,
              let priceTexts = priceTxtFild.text,
              let prices = Double(priceTexts) else {
            print("Invalid input")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newInstrument = Muscikal(context: context)
        newInstrument.name = names
        newInstrument.brand = brands
        newInstrument.category = categorys
        newInstrument.price = prices
        
        do {
            try context.save()
        } catch {
            print("Failed to save instrument: \(error)")
        }
    }
    
    func updetInstruments() {
        guard let instrument = instrumentToEdit,
              let names = nameTxtFild.text,
              let brands = brandTxtFild.text,
              let categorys = catTxtFild.text,
              let priceText = priceTxtFild.text,
              let prices = Double(priceText) else {
            print("Invalid input")
            return
        }
        
        instrument.name = names
        instrument.brand = brands
        instrument.category = categorys
        instrument.price = prices
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Failed to update instrument: \(error)")
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
