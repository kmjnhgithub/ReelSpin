//
//  AppDelegate.swift
//  ReelSpin
//
//  Created by mike liu on 2025/5/3.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // 1.必須宣告 window
    var window: UIWindow?

    // 2.App 啟動入口
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 手動建立 UIWindow
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MoviesViewController()   // ← 換成我的主 VC
        self.window = window
        window.makeKeyAndVisible()

        return true
    }

}

