//
//  MarkerContentView.swift
//  Alfa
//
//  Created by Sina khanjani on 4/17/1401 AP.
//

import UIKit

/// This class `MarkerContentView` is used to manage specific logic in the application.
class MarkerContentView: UIView {
    
/// This variable `contetView` is used to store a specific value in the application.
    let contetView: UIView = {
/// This variable `view` is used to store a specific value in the application.
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.borderColor = .lightGray
        view.borderWidth = 1
        
        return view
    }()
    
/// This variable `imageView` is used to store a specific value in the application.
    let imageView: UIImageView = {
/// This variable `img` is used to store a specific value in the application.
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "car")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
/// This variable `titleLabel` is used to store a specific value in the application.
    let titleLabel: UILabel = {
/// This variable `label` is used to store a specific value in the application.
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.iranSans(.medium, size: 14)
        label.numberOfLines = 1
        label.text = "XX"
        label.textAlignment = .left
        
        return label
    }()
    
/// This variable `descriptionLabel` is used to store a specific value in the application.
    let descriptionLabel: UILabel = {
/// This variable `label` is used to store a specific value in the application.
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.iranSans(.medium, size: 14)
        label.numberOfLines = 1
        label.text = "YY"
        label.textAlignment = .left
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contetView)
        addSubview(imageView)
        
        contetView.addSubview(titleLabel)
        contetView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            contetView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            contetView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contetView.heightAnchor.constraint(equalToConstant: 64),
            contetView.widthAnchor.constraint(equalToConstant: 94),
            // imageView constraint:
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 18),
            // titleLabel constraint:
            titleLabel.leftAnchor.constraint(equalTo: contetView.leftAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contetView.topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            titleLabel.widthAnchor.constraint(equalToConstant: 120),
            // descriptionLabel constraint:
            descriptionLabel.leftAnchor.constraint(equalTo: contetView.leftAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 32),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //
    }
}
