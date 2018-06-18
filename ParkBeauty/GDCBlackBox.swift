//
//  GDCBlackBox.swift
//  ParkBeauty
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

// MARK: performUIUpdatesOnMain

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        
        updates()
    }
}
