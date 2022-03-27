//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct ScannerView: View {
    
    @State public var isPresentingScanner = false
    @State public var scannedCode: String?
    @State public var barcodeType: String?
    
    var body: some View {
        VStack(spacing: 10) {
            if let code = scannedCode,
               let barcodeType = barcodeType{
                Text("Data: \(code)")
                Text("BarcodeType: \(barcodeType)")
            }
            
            Button("Scan Code") {
                isPresentingScanner = true
            }
            
            Text("Scan a QR code to begin")
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.qr, .code128, .code39, .code93, .ean8, .ean13, .upce], simulatedData: "Filip Kjamilov", shouldVibrateOnSuccess: true, shouldPlaySongOnSuccess: true) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    barcodeType = result.type.rawValue
                    isPresentingScanner = false
                }
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
