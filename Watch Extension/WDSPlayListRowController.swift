//
//  WDSPlayListRowController.swift
//  Watch Extension
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import WatchKit

class WDSPlayListRowController: NSObject {

    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var scoreLabel: WKInterfaceLabel!
    @IBOutlet var decribeLabel: WKInterfaceLabel!

    var playList: WDSPlayList? {
        didSet {
            guard let playList = playList else { return }

            nameLabel.setText(playList.name)
            scoreLabel.setText(playList.scoreString())
            decribeLabel.setText(playList.describe)
        }
    }
}
