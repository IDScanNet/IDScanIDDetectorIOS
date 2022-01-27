import XCTest
import IDScanPDFDetector
import IDScanMRZDetector

final class IDScanIDDetectorTests: XCTestCase {
    func test() {
        var errors = [String]()
        errors.append(contentsOf: self.testPDF())
//        errors.append(contentsOf: self.testMRZ())
        
        self.assertErrors(errors: errors, componentName: "IDScanIDDetector")
    }
    
    func testPDF() -> [String] {
        guard let image = UIImage(named: "PDFSample.png", in: .module, compatibleWith: nil), let ciImage = CIImage(image: image) else {
            return ["PDF DETECTING: can't get PDFSample.png"]
        }
        
        let detector = IDScanPDFDetector()

        guard let resultPDF = detector.detect(from: ciImage), let resultString = resultPDF["string"] as? String, resultString.count > 4 else {
            return ["PDF DETECTING: result is nil"]
        }
        
        var errors: [String] = []
        
        if let resultString = resultPDF["string"] as? String {
            if resultString.count < 5 {
                errors.append("PDF DETECTING: wrong resultString length (\(resultString.count))")
            }
        } else {
            errors.append("PDF DETECTING: can't get resultString")
        }
        
        if let barcodeRows = resultPDF["barcodeRows"] as? Int {
            if barcodeRows != 19 {
                errors.append("PDF DETECTING: wrong barcodeRows (\(barcodeRows)). But 19 expected")
            }
        } else {
            errors.append("PDF DETECTING: can't get barcodeRows")
        }
        if let barcodeColumns = resultPDF["barcodeColumns"] as? Int {
            if barcodeColumns != 15 {
                errors.append("PDF DETECTING: wrong barcodeColumns (\(barcodeColumns)). But 15 expected")
            }
        } else {
            errors.append("PDF DETECTING: can't get barcodeColumns")
        }
        
        let points = [CGPoint(x: 169.27513122558594, y: 218.7144012451172),
                      CGPoint(x: 575.4749755859375, y: 215.96351623535156),
                      CGPoint(x: 577.0595703125, y: 307.7650451660156),
                      CGPoint(x: 170.40989685058594, y: 313.8861389160156)]
        if let barcodePoints = resultPDF["barcodePoints"] as? [CGPoint] {
            if barcodePoints != points {
                errors.append("PDF DETECTING: wrong barcodePoints")
            }
        } else {
            errors.append("PDF DETECTING: can't get barcodePoints")
        }
        
        return errors
    }
    
    //It is not possible to test MRZ scanning in Simulator at the moment
//    func testMRZ() -> [String] {
//        var errors: [String] = []
//
//        #if targetEnvironment(simulator)
//
//        #else
//
//        #endif
//
//        return errors
//    }
    
    func formatErrors(_ errors: [String], componentName: String) -> String? {
        if errors.count == 0 {
            return nil
        }
        
        let newLineCorrectedErrors = errors.map { (error) -> String in
            return error.replacingOccurrences(of: "\n", with: "\n    ")
        }
        
        let bottomSeparator = String(repeating: "#", count: 100)
        let topSeparator = "## \(componentName) Errors: " + bottomSeparator.dropLast(componentName.count + 12)
        
        let formattedErrors = "\n\n\n\(topSeparator)\n\n" + " -> " + newLineCorrectedErrors.joined(separator: "\n\n -> ") + "\n\n\(bottomSeparator)\n\n\n"
        
        return formattedErrors
    }
    
    func assertErrors(errors: [String], componentName: String) {
        if let formattedErrors = self.formatErrors(errors, componentName: componentName) {
            XCTFail(formattedErrors)
        }
    }
}
