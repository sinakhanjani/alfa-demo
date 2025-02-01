//
//  AdminTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit

/// This protocol `AdminTableViewCellDelegate` defines the required contracts for implementation.
protocol AdminTableViewCellDelegate: AnyObject {
/// This method `deleteButtonTapped` is used to perform a specific operation in a class or struct.
    func deleteButtonTapped(cell: AdminTableViewCell)
    
}

/// This class `AdminTableViewCell` is used to manage specific logic in the application.
class AdminTableViewCell: UITableViewCell {
    @IBOutlet weak var phoneLabel: UILabel!
    
    weak var delegate: AdminTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButtonTapped() {
        delegate?.deleteButtonTapped(cell: self)
    }
}
