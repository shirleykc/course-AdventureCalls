//
//  Photo+Extensions.swift
//  AdventureCalls
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
