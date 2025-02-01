//
//  DeviceTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 4/27/1401 AP.
//

import UIKit

/// This protocol `DeviceTableViewCellDelegate` defines the required contracts for implementation.
protocol DeviceTableViewCellDelegate: AnyObject {
/// This method `setDefaultDeviceButtonTapped` is used to perform a specific operation in a class or struct.
    func setDefaultDeviceButtonTapped(cell: DeviceTableViewCell, button: UIButton)
/// This method `adminButtonTapped` is used to perform a specific operation in a class or struct.
    func adminButtonTapped(cell: DeviceTableViewCell)
/// This method `showOnMapButtonTapped` is used to perform a specific operation in a class or struct.
    func showOnMapButtonTapped(cell: DeviceTableViewCell)
/// This method `settingDeviceButtonTapped` is used to perform a specific operation in a class or struct.
    func settingDeviceButtonTapped(cell: DeviceTableViewCell)
/// This method `deleteButtonTapped` is used to perform a specific operation in a class or struct.
    func deleteButtonTapped(cell: DeviceTableViewCell)
}

/// This class `DeviceTableViewCell` is used to manage specific logic in the application.
class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setDefaultButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var simLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    weak var delegate: DeviceTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
/// This method `config` is used to perform a specific operation in a class or struct.
    func config(item: Car) {
        titleLabel.text = item.deviceName
        typeLabel.text = item.gpsType
        simLabel.text = item.phone
        serialLabel.text = item.imei
        creditLabel.text = "\(item.remainDays ?? 0)"
    }
    
    @IBAction func setDefaultDeviceButtonTapped(sender: UIButton) {
        delegate?.setDefaultDeviceButtonTapped(cell: self, button: sender)
    }

    @IBAction func adminButtonTapped() {
        delegate?.adminButtonTapped(cell: self)
    }
    
    @IBAction func showOnMapButtonTapped() {
        delegate?.showOnMapButtonTapped(cell: self)
    }

    @IBAction func settingDeviceButtonTapped() {
        delegate?.settingDeviceButtonTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped() {
        delegate?.deleteButtonTapped(cell: self)
    }
}
