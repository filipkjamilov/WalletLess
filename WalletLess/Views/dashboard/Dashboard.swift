//  Created by Filip Kjamilov on 27.2.22.

import CoreLocation
import SwiftUI
import RealmSwift
import Combine

struct Dashboard: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject private var viewModel = DashboardViewModel()
    
    @Binding var tabSelection: Int
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
    // MARK: - Location properties
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.realmManager.merchants.filter({ !$0.isInvalidated }).count == 0 {
                    VStack {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.primary)
                        Text("scanCards".localized(language))
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .padding()
                    }
                } else {
                    ScrollView {
                        ForEach(viewModel.realmManager.merchants.filter({ !$0.isInvalidated }), id: \.id) { merchant in
                            
                            Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(.all, 3)
                                .padding(.leading, 7)
                                .padding(.trailing, 7)
                                .listRowInsets(.init())
                                .onTapGesture {
                                    currentMerchant = merchant
                                    viewModel.isPresentingSheet.toggle()
                                }
                                .onLongPressGesture {
                                    currentMerchant = merchant
                                    viewModel.isPresentingConfirmationDialog = true
                                }
                                .alert("Are you sure you want to remove \(currentMerchant.name) from the list?", isPresented: $viewModel.isPresentingConfirmationDialog) {
                                    Button("Confirm".localized(language), role: .destructive) {
                                        viewModel.realmManager.deleteMerchant(id: currentMerchant.id)
                                        currentMerchant = MerchantDto()
                                    }
                                    Button("Cancel".localized(language), role: .cancel) { /* no-op */ }
                                }
                        }
                    }
                }
                // Modal view for showing the card details
                ModalView(isShowing: $viewModel.isPresentingSheet, merchant: $currentMerchant)
            }
            .navigationBarTitle("Dashboard".localized(language), displayMode: .large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground()
            )
        }
        .onAppear {
            /// Start observing location when user is on `Dashboard`.
            viewModel.startSortingCards()
        }
        .onDisappear {
            /// Stop observing location when user not on `Dashboard`.
            viewModel.stopUpdatingLocation()
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

public struct GradientBackground: View {
    public var body: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .frame(width: 300)
                .foregroundStyle(LinearGradient(colors: [Color.mint.opacity(0.5), Color.purple.opacity(0.6)], startPoint: .top, endPoint: .leading))
                .blur(radius: 10)
                .offset(x: -100, y: -150)
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(colors: [Color.purple.opacity(0.6), Color.mint.opacity(0.5)], startPoint: .top, endPoint: .leading))
                .offset(x: 300)
                .blur(radius: 30)
                .rotationEffect(.degrees(30))
            
        }.ignoresSafeArea(.all)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
    }
}
