//
//  ParkTableCell.swift
//  AdventureCalls
//
//  Created by Shirley on 6/5/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit

// MARK: - ParkTableCell: UITableViewCell

class ParkTableCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkStateLabel: UILabel!
    @IBOutlet weak var parkCodeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        parkNameLabel.text = nil
        parkStateLabel.text = nil
        parkCodeLabel.text = nil
    }
}
