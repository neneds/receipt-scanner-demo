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
    func addRecognizedText(recognizedText: NumberElement?) {
    
    }
}
