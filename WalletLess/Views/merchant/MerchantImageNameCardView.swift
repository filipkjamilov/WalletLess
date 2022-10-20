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
                    Button(action: {
                    }, label: {
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
                AsyncImage(url: URL(string: merchant.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 150, maxWidth: 150, minHeight: 110)
                .cornerRadius(15)
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

struct MerchantImageNameCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack {
                    MerchantImageNameCardView(merchant: MerchantDto(name: "Vero",
                                                                    image: "https://www.linkpicture.com/q/Vero.png",
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "TopShop",
                                                                    image: "https://www.linkpicture.com/q/Topshop.jpeg",
                                                                    locations: nil))
                    MerchantImageNameCardView(merchant: MerchantDto(name: "Neptun",
                                                                    image: "https://www.linkpicture.com/q/Neptun.png",
                                                                    locations: nil))
                }
            }
            .background(
                GradientBackground()
            )
            .navigationTitle("Merchants".localized(.macedonian))
        }
    }
}

// TODO: FKJ - Shimmer feature
//struct ShimmerMarchantCardView: View {
//
//    @AppStorage("language")
//    private var language = LocalizationService.shared.language
//
//    @State var show = false
//
//    var body: some View {
//
//        ZStack {
//            ZStack {
//                CardViewGradient()
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                        }, label: {
//                            Image(systemName: "creditcard")
//                                .font(.title3)
//                                .frame(width: 35, height: 35)
//                                .background(Color.primary.opacity(0.3))
//                                .clipShape(Circle())
//                                .foregroundColor(.white)
//                        })
//                        .padding()
//                        .shadow(radius: 2)
//
//                    }
//                    Spacer()
//                }
//
//                HStack {
//
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.black.opacity(0.09))
//                        .frame(minWidth: 150, maxWidth: 150, minHeight: 110)
//                        .padding(.all, 7)
//
//                    Text("")
//                        .font(.title2)
//                        .foregroundColor(.primary)
//                        .bold()
//
//                    Rectangle()
//                        .fill(Color.black.opacity(0.09))
//                        .frame(width: 150, height: 25)
//                }
//                .frame(minWidth: 0,
//                       maxWidth: .infinity,
//                       alignment: .topLeading)
//                .padding(.leading, 10)
//            }
//            .padding(.leading, 5)
//            .padding(.trailing, 5)
//
//            ZStack {
//                CardViewGradient()
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                        }, label: {
//                            Image(systemName: "creditcard")
//                                .font(.title3)
//                                .frame(width: 35, height: 35)
//                                .background(Color.white.opacity(0.6))
//                                .clipShape(Circle())
//                                .foregroundColor(.white)
//                        })
//                        .padding()
//                        .shadow(radius: 2)
//
//                    }
//                    Spacer()
//                }
//
//                HStack {
//
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.white.opacity(0.6))
//                        .frame(minWidth: 150, maxWidth: 150, minHeight: 110)
//                        .padding(.all, 7)
//
//                    Text("")
//                        .font(.title2)
//                        .foregroundColor(.primary)
//                        .bold()
//
//                    Rectangle()
//                        .fill(Color.white.opacity(0.6))
//                        .frame(width: 150, height: 25)
//                }
//                .frame(minWidth: 0,
//                       maxWidth: .infinity,
//                       alignment: .topLeading)
//                .padding(.leading, 10)
//            }
//            .padding(.leading, 5)
//            .padding(.trailing, 5)
//            .mask {
//                Rectangle()
//                    .fill(Color.white.opacity(0.6))
//                    .frame(width: 7, height: 117)
////                    .rotationEffect(.init(degrees: 70))
//                    .offset(x: 1000)
//            }
//
//        }
//
//
//    }
//}
//
//struct ShimmerMarchantCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ScrollView {
//                ZStack {
//                    ShimmerMarchantCardView()
//                }
//            }
//            .navigationTitle("Merchants".localized(.english_us))
//        }
//    }
//}
