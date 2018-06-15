//
//  DiaryTableCell.swift
//  ParkBeauty
//
//  Created by Shirley on 6/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - DiaryTableCell: UITableViewCell

class DiaryTableCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var iconImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        diaryTitleLabel.text = nil
        noteLabel.text = nil
        dateLabel.text = nil
    }
}
