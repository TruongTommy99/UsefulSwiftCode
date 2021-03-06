//
//  ViewController.swift
//  CustomCamera
//
//  Created by Truong Tommy on 7/5/22.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    //Capture Session
    var session : AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter Button
    private let shutterButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        previewLayer.backgroundColor = UIColor.systemRed.cgColor
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermission()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 100)
    }
    
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined: // request
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self.setUpCamera()
                }
            }
        case .restricted: // show
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
               // previewLayer
                previewLayer.videoGravity =  .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch  {
                print(error)
            }
        }
    }

    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    


}

extension ViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation()  else {
            return
        }
        let image = UIImage(data: data)
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
    }

}
