// Henrik Top Mygind, 05/06/2022

import Foundation
import CoreBluetooth

public protocol BasicCentralManagerDelegate: AnyObject {
    func centralManagerDidUpdateState(_ central: CentralManager)
}

class BasicDelegate: NSObject, CBCentralManagerDelegate {
    weak var centralManager: CentralManager?
    weak var delegate: BasicCentralManagerDelegate?
    init(_ centralManager: CentralManager, _ delegate: BasicCentralManagerDelegate) {
        self.centralManager = centralManager
        self.delegate = delegate
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManagerDidUpdateState(centralManager)
    }
}
