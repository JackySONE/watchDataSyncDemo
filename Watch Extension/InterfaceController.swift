//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift
import WatchConnectivity

struct WatchSettings {
    static let sharedContainerID = "group.com.sone.SimpleWatchConnectivity"
    static let lastPlayListSyncTime = "lastPlayListSyncTime"
}

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var playListTable: WKInterfaceTable!
    @IBOutlet weak var lastUpdateLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        activateSession()

        configueRealmURL(with: getRealmFileUrl())

        setupPlayList()

        setupLastUpdateTime()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func setupPlayList() {
        let realm = try! Realm()
        let playLists = realm.objects(WDSPlayList.self)

        playListTable.setNumberOfRows(playLists.count, withRowType: "PlayListRow")

        for index in 0..<playListTable.numberOfRows {
            guard let controller = playListTable.rowController(at: index) as? WDSPlayListRowController else { continue }

            controller.playList = playLists[index]
        }
    }

    func setupLastUpdateTime() {
        if let defaults = UserDefaults(suiteName: WatchSettings.sharedContainerID) {
            if let lastSyncTime = defaults.string(forKey: WatchSettings.lastPlayListSyncTime) {
                lastUpdateLabel.setText(lastSyncTime)
            }
        }
    }

    func getRealmFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("data.realm")
    }

    func configueRealmURL(with realmURL: URL) {
        var config = Realm.Configuration()
        config.fileURL = realmURL
        Realm.Configuration.defaultConfiguration = config
    }

    func updateLastSyncTime() {

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())

        if let defaults = UserDefaults(suiteName: WatchSettings.sharedContainerID) {
            defaults.set(timeString, forKey: WatchSettings.lastPlayListSyncTime)
        }

        lastUpdateLabel.setText(timeString)
    }
}

extension InterfaceController: WCSessionDelegate {

    func activateSession(){
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }

    // When the file was received
    func session(_ session: WCSession, didReceive file: WCSessionFile) {

        //set the recieved file to default Realm file
        let realmURL = getRealmFileUrl()
        if FileManager.default.fileExists(atPath: realmURL.path){
            try! FileManager.default.removeItem(at: realmURL)
        }
        try! FileManager.default.copyItem(at: file.fileURL, to: realmURL)

        configueRealmURL(with: file.fileURL)

        setupPlayList()

        updateLastSyncTime()
    }
}
