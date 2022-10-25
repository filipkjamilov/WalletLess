//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct MerchantImageNameCardView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var merchant: MerchantDto
    
    var body: some View {
        ZStack {
            
            CardViewGradient()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { /* No action so far! */}, label: {
                        Image(systemName: "creditcard")
                            .font(.title3)
                            .frame(width: 35, height: 35)
                            .background(Color.primary.opacity(0.3))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    })
                    .padding()
                    .shadow(radius: 2)
                    
                }
                Spacer()
            }
            
            HStack {
                Image(uiImage: UIImage(data: merchant.downloadedImage!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 150, maxWidth: 150, minHeight: 70)
                    .cornerRadius(7)
                    .padding(.all, 7)
                
                Text(merchant.name)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .topLeading)
            .padding(.leading, 10)
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
} 
