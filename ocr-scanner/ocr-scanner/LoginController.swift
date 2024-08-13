//
//  LoginController.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/09/30.
//

import Foundation

class LoginController {
    func login(with userID: String) -> Bool {
        if userID == "0001" {
            print("ログイン成功")
            return true
        } else {
            print("ログイン失敗")
            return false
        }
    }
}
