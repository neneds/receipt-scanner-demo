/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 View controller from which to invoke the document scanner.
 */

import UIKit
import VisionKit
import Vision
import ReceiptScanner


class DocumentScanningViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let otherContentsIdentifier = "otherContentsVC"
    let scanner = VisionKeywordScanner()
    
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func scan(_ sender: UIControl) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    @IBAction func imagePickerAction(_ sender: UIControl) {
        showImagePickerController()
    }
    
    private func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension DocumentScanningViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        resultsViewController = storyboard?.instantiateViewController(withIdentifier: DocumentScanningViewController.otherContentsIdentifier) as? (UIViewController & RecognizedTextDataSource)
        
        self.activityIndicator.startAnimating()
        
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.scanner.recognize(source: image) { (candidate, error) in
                        if error != nil {
                            print("Error: \(error?.localizedDescription ?? "")")
                        }
                        DispatchQueue.main.async {
                            if let resultsVC = self.resultsViewController {
                                self.resultsViewController?.addRecognizedText(recognizedText: candidate)
                                self.navigationController?.pushViewController(resultsVC, animated: true)
                            }
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
                
            }
        }
    }
}

extension DocumentScanningViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        resultsViewController = storyboard?.instantiateViewController(withIdentifier: DocumentScanningViewController.otherContentsIdentifier) as? (UIViewController & RecognizedTextDataSource)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        self.activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async  {
            self.scanner.recognize(source: image) { (candidate, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
                
                DispatchQueue.main.async {
                    if let resultsVC = self.resultsViewController {
                        picker.dismiss(animated: true, completion: nil)
                        self.resultsViewController?.addRecognizedText(recognizedText: candidate)
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
