//
//  CodeScanner.swift
//  BachelorThesis
//
//  Created by Filip Kjamilov on 8.2.22.
//

import AVFoundation
import SwiftUI

public enum ScanError: Error {
    case badInput
    case badOutput
    case initError(_ error: Error)
}

public struct ScanResult {
    
    public let string: String
    
    public let type: AVMetadataObject.ObjectType
    
}

public enum ScanMode {
    case once
    case oncePerCode
}

@available(macCatalyst 14.0, *)
public struct CodeScannerView: UIViewControllerRepresentable {
    
    public let codeTypes: [AVMetadataObject.ObjectType]
    public let scanMode: ScanMode
    public let scanInterval: Double
    public let showViewfinder: Bool
    public var simulatedData = ""
    public var shouldVibrateOnSuccess: Bool
    public var shouldPlaySongOnSuccess: Bool
    public var isTorchOn: Bool
    public var isGalleryPresented: Binding<Bool>
    public var videoCaptureDevice: AVCaptureDevice?
    public var completion: (Result<ScanResult, ScanError>) -> Void
    
    public init(codeTypes: [AVMetadataObject.ObjectType],
                scanMode: ScanMode = .once,
                scanInterval: Double = 2.0,
                showViewfinder: Bool = false,
                simulatedData: String = "",
                shouldVibrateOnSuccess: Bool = false,
                shouldPlaySongOnSuccess: Bool = false,
                isTorchOn: Bool = false,
                isGalleryPresented: Binding<Bool> = .constant(false),
                videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: .video),
                completion: @escaping (Result<ScanResult, ScanError>) -> Void) {
        self.codeTypes = codeTypes
        self.scanMode = scanMode
        self.scanInterval = scanInterval
        self.showViewfinder = showViewfinder
        self.simulatedData = simulatedData
        self.shouldVibrateOnSuccess = shouldVibrateOnSuccess
        self.shouldPlaySongOnSuccess = shouldPlaySongOnSuccess
        self.isTorchOn = isTorchOn
        self.isGalleryPresented = isGalleryPresented
        self.videoCaptureDevice = videoCaptureDevice
        self.completion = completion
    }
    
    public func makeCoordinator() -> ScannerCoordinator {
        ScannerCoordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController(showViewfinder: showViewfinder)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        uiViewController.updateViewController(isTorchOn: isTorchOn,
                                              isGalleryPresented: isGalleryPresented.wrappedValue)
        
    }
    
}

@available(macCatalyst 14.0, *)
struct CodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CodeScannerView(codeTypes: [.qr]) { result in
            // do nothing
        }
    }
}
