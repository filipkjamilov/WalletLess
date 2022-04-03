//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct Settings: View {
    
    @Binding var tabSelection: Int
    
    var body: some View {
        ZStack {
            Color.blue
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color.white)
                .font(.system(size: 100.0))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(tabSelection: Binding.constant(3))
    }
}
