//
//  WDSPlayList.swift
//  WatchDataSyncDemo
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class WDSPlayList: Object {

    dynamic var name: String = ""
    let favoriteScore = RealmOptional<Int>()
    dynamic var describe: String? = nil

    convenience init(name: String, score: Int?, describe: String?) {
        self.init()
        self.name = name
        self.favoriteScore.value = score
        self.describe = describe
    }

    func scoreString() -> String? {
        guard let score = favoriteScore.value else {
            return nil
        }
        return String(score)
    }
}
