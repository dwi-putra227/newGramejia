//
//  UserTrHistoryTableViewCell.swift
//  newGramejia
//
//  Created by Putra  on 07/12/24.
//

import UIKit

class UserTrHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var namaBarang: UILabel!
    @IBOutlet weak var totalBarangHarga: UILabel!
    @IBOutlet weak var berhasilAtauNgga: UILabel!
    
    
    func config(with transaction: Transaction) {
        namaBarang.text = transaction.name
        berhasilAtauNgga.text = transaction.stts
        totalBarangHarga.text = "Rp \(formatToRp(transaction.totalPrise))"
    }
        
    func formatToRp(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "Rp0"
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
