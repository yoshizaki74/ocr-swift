//
//  ScannerView.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/08/26.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    // ScannerControllerのインスタンス
    @StateObject private var scannerController = ScannerController()
    // TextRecognitionControllerのインスタンス
    @StateObject private var textRecognitionController = TextRecognitionController()
    
    @State private var isAlertPresented = false
    
    var body: some View {
        VStack {
            // カメラの映像を表示
            CameraPreview(session: scannerController.session)
                .onAppear {
                    // カメラセッションを開始
                    textRecognitionController.setupRecognition(with: scannerController)
                    scannerController.startSession()
                }
                // Viewが非表示になったときにカメラセッションを停止
                .onDisappear(perform: scannerController.stopSession)
            
            // 動的スペース
            Spacer()
            
            // 画面の下部に撮影ボタンを配置
            Button(action: {
                 // カメラからテキストを読み取った後、アラートを表示
                 scannerController.videoSampleBufferHandler = { sampleBuffer in
                     if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                         textRecognitionController.recognizeText(from: pixelBuffer)
                         
                         // アラートを表示する
                         isAlertPresented = true
                     }
                 }
            }) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white) // アイコンの色を白に設定
                    .padding(10)
            }
        }
        .navigationTitle("読み込み")
        // アラート表示
        .alert(isPresented: $isAlertPresented) {
                    Alert(
                        title: Text("登録処理を開始しますか？"),
                        primaryButton: .default(Text("登録")) {
                            // 登録処理を開始するためのコードをここに追加
                        },
                        secondaryButton: .cancel(Text("キャンセル"))
                    )
                }
    }
}

//　UIViewを作成して、AVCaptureVideoPreviewLayerを配置・更新
final class PreviewView: UIView {
    // AVCaptureVideoPreviewLayerへのアクセスを簡単にするプロパティ
    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
    // UIViewのlayerをAVCaptureVideoPreviewLayerとして返すオーバーライド
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // セッションのgetterとsetter。このセッションはカメラの映像を取得するために使用される。
    var session: AVCaptureSession? {
        get {
            return previewLayer.session
        }
        set {
            previewLayer.session = newValue
        }
    }
    
    // サブビューのレイアウトが変更されたときに呼び出される。ここでpreviewLayerのフレームを更新する。
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

// SwiftUIのViewとしてカメラの映像を表示するためのUIViewRepresentableアダプタ
struct CameraPreview: UIViewRepresentable {
    // AVCaptureSessionを持つ。これはカメラからの映像のストリームを管理する。
    let session: AVCaptureSession
    
    // SwiftUIのViewとして表示できるUIViewを生成する
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    // SwiftUIがViewの状態を更新する必要があるときに呼び出される。今回は特に変更点はない。
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}
