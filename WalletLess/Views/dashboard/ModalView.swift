//  Created by Filip Kjamilov on 14.3.22.

import SwiftUI

struct ModalView: View {
    
    @Binding var isShowing: Bool
    @Binding public var merchant: MerchantDto
    @State private var isDragging = false
    
    @State private var prevDragTranslation = CGSize.zero
    @State private var curHeight: CGFloat = 400
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var dragPercentage: Double {
        let res = Double((curHeight - minHeight) / (maxHeight - minHeight))
        return max(0, min(1, res))
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                
                mainView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
    
    var mainView: some View {
        VStack {
            
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(dragGesture)
            
            ZStack {
                VStack {
                    // Content goes here.
                    Text("\(merchant.name)")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: true, vertical: true)
                        .padding(.all, 0)
                    
                    Image(uiImage: generateCode(from: merchant.name, codeType: merchant.typeOfCode?.rawValue))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                    
                    Text("\(merchant.scannedCode ?? "")")
                        .font(.system(size: 30))
                        .padding(.bottom, 50)
                    
                    
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
                .foregroundColor(Color(UIColor.systemBackground))
        )
        .animation(.easeInOut(duration: 0.45), value: isDragging == false)
        .onDisappear {
            curHeight = minHeight
        }
    }
    
    var dragGesture: some Gesture {
        
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                
                if !isDragging {
                    isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
                
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeight > maxHeight {
                    curHeight = maxHeight
                    // When dragging down more that minHeight - 25 // Dismiss the view
                } else if curHeight < minHeight - 25 {
                    isShowing.toggle()
                } else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
}

func generateCode(from string: String, codeType: String?) -> UIImage {
    let data = Data(string.utf8)
    let context = CIContext()
    let fallbackCodeType = "CICode128BarcodeGenerator"
    
    if let filter = CIFilter(name: codeType ?? fallbackCodeType) {
        filter.setValue(data, forKey: "inputMessage")
        
        if let barcodeImage = filter.outputImage {
            if let barcodeCGImage = context.createCGImage(barcodeImage, from: barcodeImage.extent) {
                return UIImage(cgImage: barcodeCGImage)
            }
        }
    }
    
    return UIImage(systemName: "xmark") ?? UIImage()
}
