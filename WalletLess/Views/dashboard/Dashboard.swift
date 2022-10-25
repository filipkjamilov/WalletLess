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
    
    // TODO: FKJ - Check if we can remove this!
    @State private var currentMerchant: MerchantDto = MerchantDto()
    
    // MARK: - Location properties
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.realmManager.merchants.filter({ !$0.isInvalidated }).count == 0 {
                    
                    VStack(spacing: 0) {
                        if !viewModel.locationServicesEnabled {
                            AlertView(imageNameAsset: "NoLocation.png",
                                      headerText: "locationPermission",
                                      description: "locationPermissionDescription")
                            AlertView(imageNameAsset: "ScanCards.png",
                                      headerText: "scanCards",
                                      description: "scanCardsDescription")
                            Spacer()
                        }
                    }
                } else {
                    ScrollView {
                        if !viewModel.locationServicesEnabled {
                            AlertView(imageNameAsset: "NoLocation.png",
                                      headerText: "locationPermission",
                                      description: "locationPermissionDescription")
                        }
                        ForEach(viewModel.realmManager.merchants.filter({ !$0.isInvalidated }), id: \.id) { merchant in
                            if merchant.downloadedImage != Data() {
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
                            } else {
                                ProgressView()
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
            viewModel.viewAppeared()
        }
        .onDisappear {
            /// Stop observing location when user not on `Dashboard`.
            viewModel.viewDissapeared()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(tabSelection: Binding.constant(1))
    }
}
