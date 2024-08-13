//
//  TourDetailView.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/09/30.
//

import SwiftUI

struct TourDetailView: View {
    let tour: [String: String]

    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all) // 画面全体の背景色を設定
            VStack(alignment: .leading, spacing: 4) {
                Text(tour["tourName"] ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                Text("参加者氏名: \(tour["participantName"] ?? "")")
                    .foregroundColor(.mainTextColor)
                Text("詳細: \(tour["detail"] ?? "")")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(nil) // 複数行のテキストを表示
            }
            .padding()
        }
    }
}
