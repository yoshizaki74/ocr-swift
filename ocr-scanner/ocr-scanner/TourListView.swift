//
//  TourListView.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/09/30.
//

import SwiftUI

struct TourListView: View {
    // ダミーのサンプルデータ
    let sampleData: [[String: String]] = [
        ["tourName": "ツアー1", "participantName": "参加者A", "detail": "ツアー1の詳細情報"],
        ["tourName": "ツアー2", "participantName": "参加者B", "detail": "ツアー2の詳細情報"],
        ["tourName": "ツアー3", "participantName": "参加者C", "detail": "ツアー3の詳細情報"]
    ]
    
    var body: some View {
        NavigationView {
            List(sampleData, id: \.self) { tour in
                NavigationLink(destination: TourDetailView(tour: tour)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tour["tourName"] ?? "")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.mainTextColor)
                            .padding(.vertical, 5)
                        Text("参加者氏名: \(tour["participantName"] ?? "")")
                            .foregroundColor(Color.mainTextColor)
                        Text("詳細: \(tour["detail"] ?? "")")
                            .lineLimit(2) // 最大2行まで表示
                            .font(.caption)
                            .foregroundColor(Color.mainTextColor)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal) // 左右の余白を追加
                }
                .background(Color.backgroundColor)
                .cornerRadius(5)
            }
            .navigationTitle("ツアーリスト")
        }
        .background(Color.gray) // TourListView 全体の背景色をグレーに設定
        .accentColor(.black) // ナビゲーションバーのテーマカラーを黒に設定
    }
}


struct TourListView_Previews: PreviewProvider {
    static var previews: some View {
        TourListView()
    }
}
