//
//  ViewController.swift
//  WatchDataSyncDemo
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import UIKit
import RealmSwift
import WatchConnectivity

class ViewController: UIViewController {

    var playLists: Results<WDSPlayList>!
    var notificationToken: NotificationToken?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayList()

        WDSRealmService.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No error detected")
        }

        activateSession()
    }

    deinit {
        notificationToken?.invalidate()
        WDSRealmService.shared.stopObserving(in: self)
    }

    @IBAction func onAddTapped() {
        WDSAlertService.addAlert(in: self) { (name, score, describe) in
            let newPlayList = WDSPlayList(name: name, score: score, describe: describe)
            WDSRealmService.shared.create(newPlayList)
        }
    }

    func setupPlayList() {
        let realm = WDSRealmService.shared.realm
        playLists = realm.objects(WDSPlayList.self)

        notificationToken = realm.observe { [unowned self] (notification, realm) in
            self.tableView.reloadData()
            self.transferRealmFile()

        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WDSPlayListCell") as? WDSPlayListCell else { return UITableViewCell() }

        let playList = playLists[indexPath.row]
        cell.configure(with: playList)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playList = playLists[indexPath.row]

        WDSAlertService.updateAlert(in: self, songList: playList) { (name, score, describe) in
            let dict: [String: Any?] = ["name": name,
                                        "favoriteScore": score,
                                        "describe": describe]
            WDSRealmService.shared.update(playList, with: dict)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let playList = playLists[indexPath.row]
        WDSRealmService.shared.delete(playList)
    }
}

extension ViewController: WCSessionDelegate {

    func activateSession(){
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func transferRealmFile(){
        if let path = Realm.Configuration().fileURL {
            WCSession.default.transferFile(path, metadata: nil)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let _ = userInfo[PayloadKey.realmDataRequest] as? Bool {
            transferRealmFile()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
        print("\(#function): activationDidComplete = \(session.activationState.rawValue)")

    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
}
