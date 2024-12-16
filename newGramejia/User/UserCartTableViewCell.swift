//
//  UserCartTableViewCell.swift
//  newGramejia
//
//  Created by Putra  on 03/12/24.
//

import UIKit

class UserCartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbelName: UILabel!
    @IBOutlet weak var lbelBrand: UILabel!
    @IBOutlet weak var lbelPrice: UILabel!
    @IBOutlet weak var kurangBtn: UIButton!
    @IBOutlet weak var qtyLbel: UILabel!
    @IBOutlet weak var tambahBtn: UIButton!
    
    func configure(with cartItem: CartBarang) {
        lbelName.text = cartItem.name
        lbelBrand.text = cartItem.brand
        lbelPrice.text = formatToRp(cartItem.price)
        qtyLbel.text = "\(cartItem.qty)"
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

}
