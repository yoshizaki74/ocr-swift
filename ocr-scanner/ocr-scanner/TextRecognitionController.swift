//
//  TextRecognitionController.swift
//  ocr-scanner
//
//  Created by Tatsumi.Yoshizaki on 2023/08/26.
//

import Foundation
import Vision

class TextRecognitionController: ObservableObject {
    
    // VNRecognizeTextRequest
    private var textRecognitionRequest: VNRecognizeTextRequest!

    // 検出されたテキスト
    @Published var detectedText: String = ""
    
    init() {
        setupTextRecognition()
    }

    // テキスト認識の設定
    private func setupTextRecognition() {
        
        // VNRecognizeTextRequestを初期化し、結果を処理するクロージャを指定
        self.textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            // 結果をVNRecognizedTextObservationの配列として取得
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            var detectedText = ""
            for observation in observations {
                // 各観測結果から、最も一致確率が高いテキストを取得
                if let topCandidate = observation.topCandidates(1).first {
                    detectedText += topCandidate.string + "\n"
                }
            }
            
            // 検出されたテキストをmainで設定
            DispatchQueue.main.async {
                print("認識した文字")
                print(detectedText)
                self?.detectedText = detectedText
            }
        }
        
        // 日本語、英語、中国語（簡体字 & 繁体字）を認識するための設定
        self.textRecognitionRequest.recognitionLanguages = ["ja_JP", "en_US", "zh_Hans", "zh_Hant"]
        // 高精度を選択
        self.textRecognitionRequest.recognitionLevel = .accurate
    }

    // 指定されたピクセルバッファからテキストを認識するためのメソッド
    func recognizeText(from pixelBuffer: CVPixelBuffer) {
        // VNImageRequestHandlerは、ピクセルバッファからVisionリクエストを実行するためのハンドラ
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        // テキスト認識リクエストを実行
        try? handler.perform([textRecognitionRequest])
    }
    
    // CameraControllerと連携するためのメソッド
    func setupRecognition(with cameraController: ScannerController) {
        cameraController.videoSampleBufferHandler = { [weak self] sampleBuffer in
            // CMSampleBufferをCVPixelBufferに変換
            if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                // このピクセルバッファからテキスト認識を行う
                self?.recognizeText(from: pixelBuffer)
            }
        }
    }
}
