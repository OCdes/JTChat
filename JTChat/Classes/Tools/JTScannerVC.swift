//
//  JTScannerVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/4/3.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import AVFoundation
class JTScannerVC: BaseViewController {
    var input: AVCaptureInput?
    let output: AVCaptureMetadataOutput = {
        let op = AVCaptureMetadataOutput.init()
        op.connection(with: .metadata)
        return op
    }()
    let session: AVCaptureSession = {
        let s = AVCaptureSession.init()
        if s.canSetSessionPreset(AVCaptureSession.Preset.high) {
            s.sessionPreset = .high
        }
        return s
    }()
    let prelayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        if checkCameraAuth() {
            configSession()
            initView()
//        } else {
//            SVPShowError(content: "未允许相机调用，请前往设置中修改")
//        }
        // Do any additional setup after loading the view.
    }
    
    func checkCameraAuth() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
        
    }
    
    func configSession() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            self.input = try AVCaptureDeviceInput.init(device: device)
        } catch {
            
        }
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        prelayer.session = session
        if session.canAddInput(input!) && session.canAddOutput(output) {
            session.addInput(input!)
            session.addOutput(output)
            // 设置元数据处理类型(注意, 一定要将设置元数据处理类型的代码添加到  会话添加输出之后)
            output.metadataObjectTypes = [.ean13, .ean8, .upce, .code39, .code93, .code128, .code39Mod43, .qr]
        }
        
        let flag = view.layer.sublayers?.contains(prelayer)
        if flag == false || flag == nil {
            self.prelayer.frame = view.bounds
            view.layer.insertSublayer(self.prelayer, at: 0)
        }
        session.startRunning()
    }
    
    func initView() {
        
        
    }

}

extension JTScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var result = [String]()
        for obj in metadataObjects {
            guard let codeObj = obj as? AVMetadataMachineReadableCodeObject else {
                return
            }
            result.append(codeObj.stringValue ?? "")
        }
    }
}
