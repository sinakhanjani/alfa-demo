//
//  ListVorodTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 4/28/1401 AP.
//

import UIKit

/// This class `ListVorodTableViewCell` is used to manage specific logic in the application.
class ListVorodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var lastEnterLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
