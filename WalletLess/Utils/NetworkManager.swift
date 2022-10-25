//  Created by Filip Kjamilov on 28.4.22.

import Foundation
import Network

final class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    @Published var isConnected = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
