//
//  ContentView.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/08/26.
//

import SwiftUI

struct ContentView: View {
    // 読み取り画面の表示制御
    @State private var isScannerViewPresented: Bool = false
    // ツアーリストの表示制御
    @State private var isTourListPresented: Bool = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.LightPrimaryColor.edgesIgnoringSafeArea(.all) // 画面全体の背景色を設定
                
                VStack(spacing: 20) { // spacingを追加してボタン間のスペースを開けます。
                    /// 読み取り遷移ボタン
                    Button(action: {
                        isScannerViewPresented = true
                    }) {
                        Text("読み取り")
                            .foregroundColor(.subTextColor)
                            .frame(width: 150, height: 50)
                            .background(Color.secondaryColor)
                            .cornerRadius(15)
                    }
                    .navigationDestination(isPresented: $isScannerViewPresented) {
                        ScannerView()
                    }

                    /// ツアー一覧ボタン
                    Button(action: {
                        // 一覧画面を表示
                        isTourListPresented = true
                    }) {
                        Text("一覧")
                            .foregroundColor(.subTextColor)
                            .frame(width: 150, height: 50)
                            .background(Color.secondaryColor)
                            .cornerRadius(15)
                    }
                    .navigationDestination(isPresented: $isTourListPresented) {
                        TourListView() // ツアー一覧画面への遷移
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
