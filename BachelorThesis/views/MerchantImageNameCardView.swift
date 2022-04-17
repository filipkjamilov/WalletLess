//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct MerchantImageNameCardView: View {
    
    var merchant: MerchantDto
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            AsyncImage(url: URL(string: merchant.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 120)
            .cornerRadius(15)
            .padding(.all, 10)
            
            Text(merchant.name)
                .font(.system(size: 26, weight: .bold, design: .default))
                .padding(.trailing, 10)
                .foregroundColor(.primary)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               alignment: .topLeading)
        .background(.secondary)
        .modifier(CardModifier())
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
}
