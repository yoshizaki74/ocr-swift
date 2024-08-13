//
//  ColorExtension.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/09/10.
//
import SwiftUI

extension Color {
    /// プライマリーカラー: ターコイズブルー
    static let primaryColor = Color(hex: "23C1C3")
    
    /// ライトプライマリーカラー: ターコイズブルー
    static let LightPrimaryColor = Color(hex: "2DB7B9")
    
    /// セカンダリーカラー: 淡いブルーグリーン
    static let secondaryColor = Color(hex: "A1DADC")
    
    /// アクセントカラー: 明るい青色
    static let accentColor = Color(hex: "007BFF")
    
    /// 背景カラー: 明るいグレー
    static let backgroundColor = Color(hex: "F5F5F5")
    
    /// メインテキストカラー: 深いグリーンブルー
    static let mainTextColor = Color(hex: "0c2323")
    
    /// サブテキストカラー: 中間のグリーンブルー
    static let subTextColor = Color(hex: "4B6464")
    
    /// リンクテキストカラー: 明るい青色
    static let linkTextColor = Color(hex: "007BFF")
    
    /// 非活性テキストカラー: 中間のグレー
    static let disabledTextColor = Color(hex: "B0B0B0")
    
    /// エラーカラー: 明るい赤色
    static let errorColor = Color(hex: "FF4C4C")
    
    /// 成功カラー: 明るい緑色
    static let successColor = Color(hex: "4CAF50")
    
    // 16進数のカラーコードからColorを生成するためのイニシャライザ
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
