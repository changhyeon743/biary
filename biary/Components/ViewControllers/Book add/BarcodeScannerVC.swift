//
//  BarcodeScannerVC.swift
//  biary
//
//  Created by 이창현 on 09/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import AVFoundation
import UIKit

class BarcodeScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var video = AVCaptureVideoPreviewLayer()
    
    var searchVC:BookAddSearchVC?
    
    let session = AVCaptureSession()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.setRightBarButton(UIBarButtonItem(title: "완료".localized, style: .done, target: self, action: #selector(close)), animated: true)
        navigationItem.title = "책 뒤의 바코드를 찾아주세요.".localized
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch {
            print("Error")
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.ean13,.ean8,.upce]
        
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //var imageLink = URL(string:"");
        if metadataObjects.count != 0 {
            if let objects = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if let str = objects.stringValue {
                    searchVC?.searchField.text = str;
                    searchVC?.search()
                    dismiss(animated: true, completion: nil)
                }
                
                session.stopRunning()
                return
            }
            
            
            
        }
    }
    
}



