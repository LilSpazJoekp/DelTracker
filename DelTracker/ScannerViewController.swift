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
	func barcodeRead(barcode: String, light: Bool, photo: UIImage?)
}
class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {
	
	@IBOutlet var navbar: UINavigationBar!
	@IBAction func toggle(_ sender: UIBarButtonItem) {
		toggleFlash()
		
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var delegate: BarcodeDelegate?
	var barcodeCaptureSession: AVCaptureSession?
	var photoCaptureSession: AVCaptureSession?
	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	var photoPreviewLayer: AVCaptureVideoPreviewLayer?
	var qrCodeFrameView: UIView?
	let supportedCodeTypes = [AVMetadataObjectTypeCode39Code]
	var photoData: Data? = nil
	var barcode: String?
	var light: Bool = false
	var photoJpeg: UIImage?
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			barcodeCaptureSession = AVCaptureSession()
			barcodeCaptureSession?.addInput(input)
			let captureMetadataOutput = AVCaptureMetadataOutput()
			barcodeCaptureSession?.addOutput(captureMetadataOutput)
			barcodeCaptureSession?.addOutput(photoOutput)
			photoOutput.isHighResolutionCaptureEnabled = false
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
			videoPreviewLayer = AVCaptureVideoPreviewLayer(session: barcodeCaptureSession)
			videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
			videoPreviewLayer?.frame = view.layer.bounds
			view.layer.addSublayer(videoPreviewLayer!)
			barcodeCaptureSession?.startRunning()
			view.bringSubview(toFront: navbar)
			qrCodeFrameView = UIView()
			if let qrCodeFrameView = qrCodeFrameView {
				qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
				qrCodeFrameView.layer.borderWidth = 2
				view.addSubview(qrCodeFrameView)
				view.bringSubview(toFront: qrCodeFrameView)
			}
		} catch {
			print(error)
			return
		}
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
	func toggleFlash() {
		if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
			do {
				try device.lockForConfiguration()
				let torchOn = !device.isTorchActive
				try device.setTorchModeOnWithLevel(1.0)
				device.torchMode = torchOn ? .on : .off
				device.unlockForConfiguration()
				light = torchOn
			} catch {
				print("error")
			}
		}
	}
	
	// MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
	var captured: Bool = false
	private let photoOutput = AVCapturePhotoOutput()
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
		// Check if the metadataObjects array is not nil and it contains at least one object.
		if metadataObjects == nil || metadataObjects.count == 0 {
			qrCodeFrameView?.frame = CGRect.zero
			print("No barcode is detected")
			return
		}
		// Get the metadata object.
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		if !captured {
			activityIndicator(msg: "   Capturing...", true)
			if supportedCodeTypes.contains(metadataObj.type) {
				let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
				qrCodeFrameView?.frame = barCodeObject!.bounds
				if metadataObj.stringValue != nil {
					AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
					barcode = metadataObj.stringValue
					captured = true
			let photoSettings = AVCapturePhotoSettings()
			photoSettings.flashMode = .off
			photoSettings.isHighResolutionPhotoEnabled = false
			if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
				photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
			}
			photoOutput.capturePhoto(with: photoSettings, delegate: self)
				}
			}
		} else if captured {
			return
		}
	}
	func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
		if let photoSampleBuffer = photoSampleBuffer {
			let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
			photoJpeg = UIImage(data: photoData!)
			var barcodeDropped = barcode!
			barcodeDropped.remove(at: (barcodeDropped.startIndex))
			barcodeDropped.remove(at: (barcodeDropped.startIndex))
			barcodeDropped.remove(at: (barcodeDropped.startIndex))
			self.delegate?.barcodeRead(barcode: barcodeDropped, light: light, photo: photoJpeg)
			
		} else {
			print("Error capturing photo: \(error)")
			return
		}
		barcodeCaptureSession?.stopRunning()
		self.messageFrame.removeFromSuperview()
		self.dismiss(animated: true, completion: nil)
	}
	func activityIndicator(msg:String, _ indicator:Bool ) {
		print(msg)
		strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
		strLabel.text = msg
		strLabel.textColor = UIColor.white
		messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 90, width: 180, height: 50))
		messageFrame.layer.cornerRadius = 15
		messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
		if indicator {
			activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
			activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			activityIndicator.startAnimating()
			messageFrame.addSubview(activityIndicator)
		}
		messageFrame.addSubview(strLabel)
		view.addSubview(messageFrame)
	}
}
