//
//  extension.swift
//  infinity-scrolling-banner
//
//  Created by inooph on 2023/09/15.
//

import Foundation
import UIKit

protocol PrDo {}

extension PrDo {
    mutating func `do`(_ block: (inout Self) -> Void) {
        block(&self)
    }
}



extension NSObject: PrDo {}
extension Array: PrDo {}

extension UIColor {
    static func getCol(_ idx: Int) -> UIColor {
        let tmpRn: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue]
        
        return tmpRn[idx % tmpRn.count].withAlphaComponent(0.3)
    }
}

func pr<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function : String = #function, _ line: Int = #line) {
    #if DEBUG
    let value = object()
    //let fileURL: String = NSURL(fileURLWithPath: file).lastPathComponent ?? "Unknown.swift"
    
    let filePaths    = file.split(separator: "/")
    let appName     = String(describing: filePaths[filePaths.count - 2])
    let fileName    = String(describing: filePaths[filePaths.count - 1].split(separator: ".").first ?? "")
//    let queue = Thread.isMainThread ? "UI" : "BG"
    print("[\(appName)] [\(getCurrentDate())] [\(fileName)]\n[\(function)] [\(line)]\n\(String(reflecting: value))\n")
    #endif
}

private func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss.SSSSSS"
    return (formatter.string(from: Date()) as NSString) as String
}

extension UIView {
    @IBInspectable var cornerRadi: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
}
