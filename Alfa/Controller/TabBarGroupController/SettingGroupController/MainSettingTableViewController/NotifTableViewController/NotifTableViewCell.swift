//
//  NotifTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 4/28/1401 AP.
//

import UIKit

/// This class `NotifTableViewCell` is used to manage specific logic in the application.
class NotifTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
