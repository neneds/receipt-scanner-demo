/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 View controller for unstructured text.
 */

import UIKit
import Vision
import ReceiptScanner

class OtherContentsViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView?
    var transcript = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.text = transcript
    }
}
// MARK: RecognizedTextDataSource
extension OtherContentsViewController: RecognizedTextDataSource {
    func showCandidate(candidate: NumberElement?) {
        guard let candidate = candidate else {
            transcript = "Could not Scan data from image"
            return
        }
        let text = "Value: \(String(describing: candidate.numberValue))\n Date: \(String(describing: candidate.dateString))"
        transcript = text
    }
}
