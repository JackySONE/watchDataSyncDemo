//
//  WDSRealmService.swift
//  WatchDataSyncDemo
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import Foundation
import RealmSwift

extension Notification.Name {
    static let kWDSRealmError = Notification.Name("kWDSRealmError")
}

class WDSRealmService {

    private init() {}
    static let shared = WDSRealmService()

    var realm = try! Realm()

    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }

    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }

    func post(_ error: Error) {
        NotificationCenter.default.post(name: .kWDSRealmError, object: error)
    }

    func observeRealmErrors(in vc: UIViewController, completion: @escaping(Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: .kWDSRealmError,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }

    func stopObserving(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: .kWDSRealmError, object: nil)
    }
}
