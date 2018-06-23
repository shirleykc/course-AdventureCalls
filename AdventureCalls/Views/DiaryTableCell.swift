//
//  DiaryTableCell.swift
//  AdventureCalls
//
//  Created by Shirley on 6/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - DiaryTableCell: UITableViewCell

class DiaryTableCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var diaryTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        diaryTitleLabel.text = nil
    }
}
