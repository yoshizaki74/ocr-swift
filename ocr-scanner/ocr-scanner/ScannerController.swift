//
//  CameraController.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/08/26.
//

import Foundation
import AVFoundation

class ScannerController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session = AVCaptureSession()
    private let dataOutput = AVCaptureVideoDataOutput()
    
    // 非同期を行うためキューを用意
    public let sessionQueue = DispatchQueue(label: "session queue")
    
    // Visionとの受け渡しで利用するクロージャ
    var videoSampleBufferHandler: ((CMSampleBuffer) -> Void)?

    override init() {
        super.init()
        
        // デフォルトのバックカメラを使用
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("カメラの立ち上げに失敗")
            return
        }
        
        // カメラからの入力を取得
        let input = try? AVCaptureDeviceInput(device: camera)
        if session.canAddInput(input!) {
            session.addInput(input!)
        }
        
        // 出力を設定
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        }
    }

    /// カメラのセッション開始
    func startSession(){
        // セッションが実行中でないか確認
        guard !session.isRunning else { return }
        
        print("カメラ起動")
        
        // バックグラウンドで非同期に実行
        DispatchQueue(label: "camera_session", qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    /// カメラのセッション終了
    func stopSession() {
        // セッションが実行中であるか確認
        guard session.isRunning else { return }
        
        print("カメラ終了")
        
        // バックグラウンドで非同期に実行
        DispatchQueue(label: "camera_session", qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    /// `AVCaptureVideoDataOutputSampleBufferDelegate`のデリゲートメソッド。
    /// 新しいビデオフレームがキャプチャされたときに呼び出される。
    /// - Parameters:
    ///   - output: 新しいフレームを生成した出力オブジェクト。
    ///   - sampleBuffer: キャプチャされたビデオフレームを含むサンプルバッファ。
    ///   - connection: 新しいフレームのソースとなる入力ポートと出力の間の接続。
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // videoSampleBufferHandlerが設定されている場合のみ処理を行います
        videoSampleBufferHandler?(sampleBuffer)
        // 処理が終わったらリセット
        videoSampleBufferHandler = nil
    }
}
