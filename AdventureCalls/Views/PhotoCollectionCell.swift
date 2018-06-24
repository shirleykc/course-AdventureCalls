//
//  PhotoCollectionCell.swift
//  AdventureCalls
//
//  Created by Shirley on 6/19/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit

// MARK: - PhotoCollectionCell: UICollectionViewCell

class PhotoCollectionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}
