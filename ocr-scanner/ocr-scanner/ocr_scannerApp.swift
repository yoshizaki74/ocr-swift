//
//  ocr_scannerApp.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/08/26.
//

import SwiftUI

@main
struct ocr_scannerApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.showSplash {
                SplashScreen(appState: appState)
            } else if appState.loggedIn && appState.showContent {
                ContentView()
            } else {
                LoginView(appState: appState)
            }
        }
    }
}


class AppState: ObservableObject {
    @Published var showSplash: Bool = true
    @Published var splashOpacity: Double = 1.0
    @Published var loggedIn: Bool = false
    @Published var showContent: Bool = false

    init() {
        // 0.5秒後にスプラッシュスクリーンの透明度を減少させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.7)) {
                self.splashOpacity = 0.0
            }
            
            // アニメーションの後にスプラッシュスクリーンを非表示にする
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.showSplash = false
                    self.showContent = true
                }
            }
        }
    }
}


struct SplashScreen: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // 画面全体を白にする
            
            Image("companyIcon") // 会社のアイコン画像をAssetsに追加してください。
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .opacity(appState.splashOpacity)
        }
    }
}
