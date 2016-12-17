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
	var qrCodeFrameView:UIView?
	var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
	var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
	var output = AVCaptureMetadataOutput()
	var previewLayer: AVCaptureVideoPreviewLayer?
	
	var captureSession = AVCaptureSession()
	var code: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.clear
		self.setupCamera()
	}
	
	private func setupCamera() {
		let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
		if self.captureSession.canAddInput(input) {
			self.captureSession.addInput(input)
		}
		self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		if let videoPreviewLayer = self.previewLayer {
			videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
			videoPreviewLayer.frame = self.view.bounds
			view.layer.addSublayer(videoPreviewLayer)
			if let qrCodeFrameView = qrCodeFrameView {
				qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
				qrCodeFrameView.layer.borderWidth = 2
				view.addSubview(qrCodeFrameView)
				view.bringSubview(toFront: qrCodeFrameView)
			}
		}
		qrCodeFrameView = UIView()
		view.bringSubview(toFront: navbar)
		let metadataOutput = AVCaptureMetadataOutput()
		if self.captureSession.canAddOutput(metadataOutput) {
			self.captureSession.addOutput(metadataOutput)
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
		} else {
			print("Could not add metadata output")
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if (captureSession.isRunning == false) {
			captureSession.startRunning();
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if (captureSession.isRunning == true) {
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
		// This is the delegate'smethod that is called when a code is readed
		for metadata in metadataObjects {
			let readableObject = metadata as! AVMetadataMachineReadableCodeObject
			let code = readableObject.stringValue
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			self.dismiss(animated: true, completion: nil)
			self.delegate?.barcodeRead(barcode: code!)
			print(code!)
		}
	}
}
/*
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
*/
