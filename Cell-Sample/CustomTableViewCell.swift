//
//  CustomTableViewCell.swift
//  Cell-Sample
//
//  Created by 大西玲音 on 2021/06/08.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    func configure(name: String, color: UIColor) {
        label.text = name
        label.textColor = color
    }
    
}
