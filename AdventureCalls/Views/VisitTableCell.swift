//
//  VisitTableCell.swift
//  AdventureCalls
//
//  Created by Shirley on 6/10/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit

// MARK: - VisitTableCell: UITableViewCell

class VisitTableCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var visitTitleLabel: UILabel!
    @IBOutlet weak var visitDateLabel: UILabel!
    @IBOutlet weak var ratingStar1Image: UIImageView!
    @IBOutlet weak var ratingStar2Image: UIImageView!
    @IBOutlet weak var ratingStar3Image: UIImageView!
    @IBOutlet weak var ratingStar4Image: UIImageView!
    @IBOutlet weak var ratingStar5Image: UIImageView!
        
    override func prepareForReuse() {
        super.prepareForReuse()
        visitTitleLabel.text = nil
        visitDateLabel.text = nil
    }
}
