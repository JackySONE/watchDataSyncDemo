//
//  WDSAlertService.swift
//  WatchDataSyncDemo
//
//  Created by JackySONE on 2018/12/10.
//  Copyright © 2018 JackySONE. All rights reserved.
//

import UIKit

class WDSAlertService {

    private init() {}

    static func addAlert(in vc: UIViewController,
                         completion: @escaping (String, Int?, String?) -> Void) {

        let alert = UIAlertController(title: "新增播放清單", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "輸入播放清單名稱"
        }
        alert.addTextField { (scoreTF) in
            scoreTF.placeholder = "輸入喜愛分數"
        }
        alert.addTextField { (describeTF) in
            describeTF.placeholder = "輸入歌單描述"
        }

        let action = UIAlertAction(title: "新增", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let scoreString = alert.textFields?[1].text,
                let describeString = alert.textFields?.last?.text
                else { return }

            let score = scoreString == "" ? nil : Int(scoreString)
            let describe = describeString == "" ? nil : describeString

            completion(name, score, describe)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alert.addAction(action)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }

    static func updateAlert(in vc: UIViewController,
                            songList: WDSPlayList,
                            completion: @escaping (String, Int?, String?) -> Void) {

        let alert = UIAlertController(title: "更新播放清單", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "輸入播放清單名稱"
            nameTF.text = songList.name
        }
        alert.addTextField { (scoreTF) in
            scoreTF.placeholder = "輸入喜愛分數"
            scoreTF.text = songList.scoreString()
        }
        alert.addTextField { (describeTF) in
            describeTF.placeholder = "輸入歌單描述"
            describeTF.text = songList.describe
        }

        let action = UIAlertAction(title: "Update", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let scoreString = alert.textFields?[1].text,
                let describeString = alert.textFields?.last?.text
                else { return }

            let score = scoreString == "" ? nil : Int(scoreString)
            let describe = describeString == "" ? nil : describeString

            completion(name, score, describe)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alert.addAction(action)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }

}
