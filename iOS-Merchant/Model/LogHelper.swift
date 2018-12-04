//
//  LogHelper.swift
//  iOS-Merchant
//
//  Created by Nick Wen on 2018/12/2.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//
// 範例
// 在 class 內建立 全域變數 TAG
// let TAG = "XXXViewController"
// LogHelper.println(tag: TAG, line: #line, "MAG")

// 輸出結果
// 在 XXXViewController 的 50 行,
// 訊息：MAG

import Foundation

final class LogHelper {
    static func println(tag: String, line: Int, _ msg: String) {
        print("在 \(tag) 的 \(line) 行,\n訊息：\(msg)\n")
    }
}
