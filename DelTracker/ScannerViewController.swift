//
//  BarcodeViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/16/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import AVFoundation
import UIKit

protocol BarcodeDelegate {
	func barcodeRead(barcode: String)
}
class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	@IBOutlet var navbar: UINavigationBar!
	var delegate: BarcodeDelegate?
	var captureSession: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	var qrCodeFrameView:UIView?
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.black
		captureSession = AVCaptureSession()
		let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
		let videoInput: AVCaptureDeviceInput
		do {
			qrCodeFrameView = UIView()
			if let qrCodeFrameView = qrCodeFrameView {
    qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
    qrCodeFrameView.layer.borderWidth = 2
    view.addSubview(qrCodeFrameView)
    view.bringSubview(toFront: qrCodeFrameView)
			}
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}
		if (captureSession.canAddInput(videoInput)) {
			captureSession.addInput(videoInput)
		} else {
			failed();
			return;
		}
		let metadataOutput = AVCaptureMetadataOutput()
		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
		} else {
			failed()
			return
		}
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
		previewLayer.frame = view.layer.bounds;
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		view.layer.addSublayer(previewLayer);
		view.bringSubview(toFront: navbar)
		captureSession.startRunning();
	}
	func failed() {
		let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
		captureSession = nil
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if (captureSession?.isRunning == false) {
			captureSession.startRunning();
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if (captureSession?.isRunning == true) {
			captureSession.stopRunning();
		}
	}
	@IBAction func toggle(_ sender: UIBarButtonItem) {
		toggleFlash()
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	func toggleFlash() {
		if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
			do {
				try device.lockForConfiguration()
				let torchOn = !device.isTorchActive
				try device.setTorchModeOnWithLevel(1.0)
				device.torchMode = torchOn ? .on : .off
				device.unlockForConfiguration()
			} catch {
				print("error")
			}
		}
	}
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
		captureSession.stopRunning()
		if let metadataObject = metadataObjects.first {
			let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			found(code: readableObject.stringValue);
		}
		dismiss(animated: true)
	}
	func found(code: String) {
		print(code)
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
}
