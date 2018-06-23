//
//  Park+Extensions.swift
//  AdventureCalls
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Park {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
