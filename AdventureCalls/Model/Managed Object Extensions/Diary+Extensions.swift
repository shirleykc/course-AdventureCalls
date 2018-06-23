//
//  Diary+Extensions.swift
//  AdventureCalls
//
//  Created by Shirley on 6/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Diary {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
