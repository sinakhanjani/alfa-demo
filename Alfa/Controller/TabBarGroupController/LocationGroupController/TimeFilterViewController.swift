//
//  TimeFilterViewController.swift
//  Alfa
//
//  Created by Sina khanjani on 4/23/1401 AP.
//

import UIKit

/// This class `TimeFilterViewController` is used to manage specific logic in the application.
class TimeFilterViewController: BaseViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
/// This variable `completion` is used to store a specific value in the application.
    var completion: ((_ startDate: Date,_ endDate: Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // config date picker
        startDatePicker.locale = Locale(identifier: "fa_IR")
        startDatePicker.calendar = Calendar(identifier: .persian)
        
        endDatePicker.locale = Locale(identifier: "fa_IR")
        endDatePicker.calendar = Calendar(identifier: .persian)
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func agreeButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion?(self.startDatePicker.date,self.endDatePicker.date)
        }
    }
}
