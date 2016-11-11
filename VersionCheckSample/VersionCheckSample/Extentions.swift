//
//  Extentions.swift
//  VersionCheckSample
//
//  Created by 關貿開發者 on 2016/11/11.
//  Copyright © 2016年 關貿開發者. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

extension UIDevice {
    public func hasNewAPPVersion(appId: String,
                                 completion: (latestVersion: String) -> Void) {
        let url = "https://itunes.apple.com/tw/app/itunes-u/id\(appId)"
        Alamofire.request(.GET, url)
            .response { request, response, data, error in
                if(response?.statusCode == 200) {
                    let dataStr: NSString
                        = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    let versionHtmlTag = "<span itemprop=\"softwareVersion\">"
                    do {
                        let regexStr = "\(versionHtmlTag).+?</span>"
                        let regex = try NSRegularExpression(pattern: regexStr, options: [])
                        let results = regex.matchesInString(dataStr as String,
                            options: [], range: NSMakeRange(0, dataStr.length))
                        if(results.count > 0) {
                            let result = results.map{dataStr.substringWithRange($0.range)}[0]
                            var latestVersion = result
                                .stringByReplacingOccurrencesOfString(versionHtmlTag, withString: "")
                            latestVersion = latestVersion
                                .stringByReplacingOccurrencesOfString("</span>", withString: "")
                            completion(latestVersion: latestVersion)
                        }
                    } catch let error as NSError {
                        print("invalid regex: \(error.localizedDescription)")
                    }
                } else {
                    print("Check version: \(response), \(error)")
                }
        }
    }
    
    public func getVersion() -> String? {
        if let version = NSBundle.mainBundle()
            .infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }
}
