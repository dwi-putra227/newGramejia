//
//  InstrumenTableViewCell.swift
//  newGramejia
//
//  Created by Putra  on 01/12/24.
//

import UIKit

class InstrumenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var labelCat: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    func configure(with instrument: Muscikal) {
        labelName.text = instrument.name
        labelBrand.text = "\(instrument.brand ?? "Unknown")"
        labelCat.text = "\(instrument.category ?? "Unknown")"
        labelPrice.text = formatToRp(instrument.price)
    }
    
    func formatToRp(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID") // Locale untuk Indonesia
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0 // Tidak menampilkan desimal
        
        if let formattedValue = formatter.string(from: NSNumber(value: value)) {
            return formattedValue
        } else {
            print("Error: Could not format value")
            return "Rp0"
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupCardStyle() {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = false

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4

        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = UIColor.lightGray.cgColor
    }

}
