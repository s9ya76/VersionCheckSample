//
//  ViewController.swift
//  VersionCheckSample
//
//  Created by 關貿開發者 on 2016/11/11.
//  Copyright © 2016年 關貿開發者. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let appStoreId = "1135330432"
    
    @IBOutlet weak var versionMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        // 檢查APP是否有新版本可供更新並顯示訊息
        hasNewAPPVersionAndShow()
    }
    
    // 檢查APP是否有新版本可供更新並顯示訊息
    func hasNewAPPVersionAndShow() {
        UIDevice().hasNewAPPVersion(appStoreId, completion: { (version) in
            print("架上最新版本:\(version)")
            if(UIDevice().getVersion() != version) {
                dispatch_async(dispatch_get_main_queue()) {
                    let body = "APP推出新版本\(version)"
                    self.versionMsgLabel.text = body
                    self.showMsg("訊息", message: body, btnTitle: "更新",
                        handler: { (UIAlertAction) in
                            self.openAPPStore()
                    })
                }
            }
        })
    }
    
    // 開啟APP Store
    func openAPPStore() {
        let urlStr = "https://itunes.apple.com/tw/app/unigo/id\(appStoreId)"
        let url = NSURL(string: urlStr)
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication()
                .openURL(url!, options: [:], completionHandler: nil)
        }
    }
    
    // 顯示訊息
    func showMsg(title: String, message: String, btnTitle: String = "確定",
                 isShowCancelBtn: Bool = false, handler: ((UIAlertAction) -> Void)?,
                 cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        // 初始化Alert
        let alertController
            = UIAlertController(title: title,
                                message: message,
                                preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(
            title: btnTitle, style: UIAlertActionStyle.Default, handler: handler))
        if(isShowCancelBtn) {
            alertController.addAction(UIAlertAction(
                title: "取消", style: UIAlertActionStyle.Cancel, handler: cancelHandler))
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
