//
//  ScannerViewController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 26.03.2021.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var user: String!
    var activeUserManager = ActiveUserManager()
    var imagePicker = UIImagePickerController()
    let viewMain = UIView()
    
    var alertCustom = AlertCustom()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activeUserManager.delegate = self
        viewMain.frame = view.frame
        viewMain.backgroundColor = .white
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        
        let rightBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            style: .plain,
            target: self,
            action: #selector(detectQRCodeButtom))

        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationItem.rightBarButtonItem = rightBackButton
        


        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeFromSuperview()
        view = nil
    }
    
    
    
    @objc func didTapMenuButton() {

        self.dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif1"), object: nil)
    }
    
    
    
    func showViewMain() {
        view.addSubview(viewMain)
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
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        print("Close")


        
        
    }

    func found(code: String) {
        print(code)
        let component = code.components(separatedBy: "val1=") // 2
        if component.count > 1, let appId = component.last { // 3
            print(appId)
            activeUserManager.performUpdateGroup(loginLet: self.user, group: appId)
        } else {
            self.alertCustom.showAlertOkView(main: "Внимание!", second: "QR не распознан", control: self, dismissView: true, notificcationStr: nil)
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    
    @objc func detectQRCodeButtom () {
        
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
                            if let features = self.detectQRCode(image), !features.isEmpty{
                                for case let row as CIQRCodeFeature in features{
                                    print(row.messageString ?? "nope")
                                    let code = row.messageString
                                    let component = code!.components(separatedBy: "=") // 2
                                    if component.count > 1, let appId = component.last { // 3
                                        print(appId)
                                        activeUserManager.performUpdateGroup(loginLet: self.user, group: appId)
                                        captureSession.stopRunning()
                                        self.showViewMain()
//                                        self.dismiss(animated: true)
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                                    }
                                }
                            }
        }

    }
    
    
     func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
            

        }
        return nil
    }
    
    
    
    
}


extension ScannerViewController: ActiveUserManagerDelegate {
    func didShowGroupUser(_ Content: ActiveUserManager, content: [ListAdminUser]) {
        
    }
    
    func didShowGroup(_ Content: ActiveUserManager, content: [ListAdmin]) {
        
    }
    
    func didUpdateGroup(_ Content: ActiveUserManager, content: GroupUpdate) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            if content.success == 1 {
                labelGroupName.text = nil
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                K.idGroupProfile = content.id
                K.groupName = content.name
                
                let alertController = UIAlertController(title: "Информация", message: "Вы перешли в группу \"\(content.name)\"", preferredStyle: .alert)

                    // Initialize Actions
                let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                        print("The user is okay.")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let newViewController = storyboard.instantiateViewController(withIdentifier: "Table") as! tableController
                    
                    newViewController.firstName = K.userName
                    newViewController.user = K.userLogin
                    newViewController.group = K.idGroupProfile
                    newViewController.resetCoredata = true
                    newViewController.userAction = K.userLogin
                    K.numberOfRows = []

                    let navController = UINavigationController(rootViewController: newViewController)
                    navController.modalTransitionStyle = .flipHorizontal
                    navController.modalPresentationStyle = .overFullScreen
                    
                    self.activeUserManager.performActiveUserSeance(loginLet: K.userLogin, action: 2)
                    newViewController.idSeance = nil
        //            newViewController.modalPresentationStyle = .currentContext
        //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
                    self.present(navController, animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: nil)
//                    _ = navigationController?.popViewController(animated: true)
                        self.showViewMain()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                    }
                    alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                self.alertCustom.showAlertOkView(main: "Внимание!", second: "Группы не существует", control: self, dismissView: true, notificcationStr: nil)
            }
        }
        
    }
    
    func didActiveUserSeance(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
    func didActiveUser(_ Content: ActiveUserManager, content: ActiveUser) {
        
    }
    
}
