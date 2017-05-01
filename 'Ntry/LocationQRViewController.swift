//
//  LocationQRViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/27/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//
import UIKit
import AVFoundation


protocol LocationQRViewControllerDelegate:class{
    func addItemViewController(controller:LocationQRViewController,didFinishEnteringItem item:NSString)
    
}

class LocationQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, LocationQRViewControllerDelegate{
    
    
    weak var artLabelDelegate: LocationQRViewControllerDelegate?
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    let itemToPasssPack = "Pass this Back to ScanViewController"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        artLabelDelegate = self;
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            //Setting frame of camera
            let screenWidth = UIScreen.main.bounds.size.width
            
            videoPreviewLayer?.frame = CGRect(x:0, y:55, width:screenWidth, height:200)
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture.
            captureSession?.startRunning()
            
            
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItemViewController(controller: LocationQRViewController, didFinishEnteringItem item: NSString) {
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                
            }
        }
    }
    
    @IBAction func selectButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ScanView") as! ScanViewController
        myVC.locationLabel.text = messageLabel.text!
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
