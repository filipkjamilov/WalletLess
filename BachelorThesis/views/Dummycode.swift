/*
enum SheetMode {
    
    case none
    case quarter
    case half
    case full
    
}

struct SheetView<Content: View>: View {
    
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    
//    @Environment(\.dismiss) var dismiss
//    @State public var merchant: MerchantDto
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.sheetMode = sheetMode
    }
    
    private func calculateOffset() -> CGFloat {
        
        switch sheetMode.wrappedValue {
            case .none:
                return UIScreen.main.bounds.height
            case .quarter:
                return UIScreen.main.bounds.height - 200
            case .half:
                return UIScreen.main.bounds.height/2
            case .full:
                return 0
        }
        
    }
    
    var body: some View {
        content()
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
//        HStack {
//            Text("Name: \(merchant.name)")
//            Text("Link image: \(merchant.image)")
//            Text("Type of code: \(merchant.typeOfCode?.rawValue ?? "")")
//            Text("ScannedCode: \(merchant.scannedCode ?? "")")
//
//            Image(uiImage: generateCode(from: merchant.name, codeType: merchant.typeOfCode?.rawValue))
//                .interpolation(.none)
//                .resizable()
//                .scaledToFit()
//        }
    }
}
 
 
 
 
 
 
 
 
 
 
 
 
 
*/
