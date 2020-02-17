/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The protocol that a class must conform to in order to receive recognized text information.
*/

import UIKit
import Vision
import ReceiptScanner

protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: NumberElement?)
}
