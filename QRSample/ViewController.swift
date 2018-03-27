//
//  ViewController.swift
//  QRSample
//
//  Created by 藤井陽介 on 2018/03/27.
//  Copyright © 2018 Swimee. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ここから
    
    @IBOutlet var label: UILabel!
    
    // QRリーダーになってくれるViewController
    lazy var readerViewController: QRCodeReaderViewController = {
        
        let builder = QRCodeReaderViewControllerBuilder {
            
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scan(_ sender: Any) {
        
        // これは絶対必要
        readerViewController.delegate = self
        
        // ここにスキャンしたあとの処理を書く
        readerViewController.completionBlock = { result in
            print(result?.value) // ここに設定したテキストがStringで入っている
            // 例
            if let costString = result?.value {
                let cost = Int(costString)  // これでcostに値段の数字が入るはず（QRをその形式で作成すれば）
                // QR作成サービス : https://qr.quel.jp/qr_img_draw.php
                self.label.text = costString
            }
        }
        
        // リーダーを表示する
        readerViewController.modalPresentationStyle = .formSheet
        present(readerViewController, animated: true, completion: nil)
    }
    
    // スキャンできたらどうするか
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    // カメラを切り替えたとき
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        
        // 今回はなにもやらなくてオーケー
    }
    
    // キャンセルされた時
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

