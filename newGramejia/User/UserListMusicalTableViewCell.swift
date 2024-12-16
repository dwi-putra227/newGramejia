//
//  UserListMusicalTableViewCell.swift
//  newGramejia
//
//  Created by Putra  on 02/12/24.
//

import UIKit

class UserListMusicalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var labelCat: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var tambahDiCart: UIButton!
    
    var musical: Muscikal?
    
    func configure(with instrument: Muscikal) {
        labelName.text = instrument.name
        labelBrand.text = instrument.brand ?? "Unknown"
        labelCat.text = instrument.category ?? "Unknown"
        labelPrice.text = formatToRp(instrument.price)
    }

    func formatToRp(_ value: Double) -> String {
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "id_ID")
        formater.currencySymbol = "Rp"
        formater.maximumFractionDigits = 0
        return formater.string(from: NSNumber(value: value)) ?? "Rp0"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tambahDiCartClick(_ sender: Any) {
        guard let musical = musical else { return }
    }
    

}
