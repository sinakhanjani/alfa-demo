//
//  MoqeyatTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 7/19/22.
//

import UIKit

/// This protocol `MoqeyatTableViewCellDelegate` defines the required contracts for implementation.
protocol MoqeyatTableViewCellDelegate: AnyObject {
/// This method `deleteMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func deleteMoqeyatTapped(cell: MoqeyatTableViewCell)
/// This method `editMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func editMoqeyatTapped(cell: MoqeyatTableViewCell)
/// This method `shareMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func shareMoqeyatTapped(cell: MoqeyatTableViewCell)
/// This method `linkMoqeyatTapped` is used to perform a specific operation in a class or struct.
    func linkMoqeyatTapped(cell: MoqeyatTableViewCell)
}

/// This class `MoqeyatTableViewCell` is used to manage specific logic in the application.
class MoqeyatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateExLabel: UILabel!
    @IBOutlet weak var timeExLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!

    weak var delegate: MoqeyatTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
/// This method `update` is used to perform a specific operation in a class or struct.
    func update(item: Eshterak) {
        self.titleLabel.text = (item.active ?? false) ? "فعال": "غیرفعال"
        self.nameLabel.text = item.userName
        self.dateExLabel.text = item.expireDate?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "yyyy/MM/dd")
        self.timeExLabel.text = item.expireDate?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "HH:mm")
        self.serialLabel.text = item.imei
        self.linkButton.setTitle(item.urlLink ?? "", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func linkMoqeyatTapped() {
        delegate?.linkMoqeyatTapped(cell: self)
    }
    
    @IBAction func deleteMoqeyatTapped() {
        delegate?.deleteMoqeyatTapped(cell: self)
    }

    @IBAction func editMoqeyatTapped() {
        delegate?.editMoqeyatTapped(cell: self)
    }
    
    @IBAction func shareMoqeyatTapped() {
        delegate?.shareMoqeyatTapped(cell: self)
    }

}
