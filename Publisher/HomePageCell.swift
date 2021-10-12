//
//  HomePageCell.swift
//  Publisher
//
//  Created by PoChieh Chuang on 2021/10/12.
//

import UIKit

class HomePageCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
