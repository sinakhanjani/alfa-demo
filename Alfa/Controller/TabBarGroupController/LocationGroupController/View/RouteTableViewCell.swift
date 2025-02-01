//
//  RouteTableViewCell.swift
//  Alfa
//
//  Created by Sina khanjani on 4/23/1401 AP.
//

import UIKit

/// This class `RouteTableViewCell` is used to manage specific logic in the application.
class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var aDateLabel: UILabel!
    @IBOutlet weak var bDateLabel: UILabel!

    @IBOutlet weak var aTimeLabel: UILabel!
    @IBOutlet weak var bTimeLabel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

/// This method `updateUI` is used to perform a specific operation in a class or struct.
    func updateUI(item: RouteItem) {
        self.aDateLabel.text = item.startZaman?.toDate()?.toString(style: .medium)
        self.bDateLabel.text = item.lastZaman?.toDate()?.toString(style: .medium)
        
        if let aTime = item.startZaman?.toDate()?.toString(format: "HH:mm") {
            self.aTimeLabel.text = "ساعت \(aTime)"
        }
        if let bTime = item.lastZaman?.toDate()?.toString(format: "HH:mm") {
            self.bTimeLabel.text = "ساعت \(bTime)"
        }
        
        if let masafat = item.masafat {
/// This variable `doub` is used to store a specific value in the application.
            let doub = Double(masafat)/1000
            if masafat < 1000 {
                durationLabel.text = "مسافت \(Int(masafat)) متر"
            } else {
                durationLabel.text = "مسافت \(doub.rounded(toPlaces: 1)) کیلومتر"
            }
        }
        
        if let duration = item.duration {
/// This variable `doub` is used to store a specific value in the application.
            let doub: Int = (duration / 60)
            self.distanceLabel.text = "مدت \(doub) دقیقه"
        }
    }
}
