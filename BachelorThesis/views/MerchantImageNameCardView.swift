//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct MerchantImageNameCardView: View {
    
    var merchant: MerchantDto
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: merchant.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .cornerRadius(15)
                .padding(.all, 10)
                
            } else {
                // TODO: FKJ - Third part lib will be used as main async image view
                // Fallback on earlier versions
            }
            Text(merchant.name)
                .font(.system(size: 26, weight: .bold, design: .default))
                .padding(.trailing, 10)
                .foregroundColor(.white)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 100,
               maxHeight: 100,
               alignment: .topLeading)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 1)
    }
}
