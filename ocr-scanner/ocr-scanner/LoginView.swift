//
//  LoginView.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/09/10.
//
import SwiftUI

struct LoginView: View {
    @ObservedObject var appState: AppState
    @State private var userID: String = ""
    @State private var errorMessage: String?

    let loginController = LoginController() // LoginControllerのインスタンスを作成

    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack(spacing: 20) {
                Text("ログインIDを入力")
                    .font(.headline)
                    .foregroundColor(.mainTextColor)
                
                TextField("IDを入力してください", text: $userID)
                    .padding()
                    .background(Color.secondaryColor)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryColor, lineWidth: 2)
                    )
                
                Button(action: performLogin) {
                    Text("ログイン")
                        .foregroundColor(.mainTextColor)
                        .frame(width: 200, height: 50)
                        .background(Color.primaryColor)
                        .cornerRadius(15)
                }
                .zIndex(1)

                // エラーメッセージの表示
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.errorColor)
                        .padding(.top, 10)
                }
                
            }
            .padding()
        }
    }

    // ログイン処理を更新
    func performLogin() {
        if loginController.login(with: userID) {
            appState.loggedIn = true
            errorMessage = nil
        } else {
            errorMessage = "ログインに失敗しました"
        }
    }

    // キーボードを隠すための関数
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
