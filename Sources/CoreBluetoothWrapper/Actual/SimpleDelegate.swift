// Henrik Top Mygind, 05/06/2022

import Foundation
import CoreBluetooth

public protocol SimpleCentralManagerDelegate: BasicCentralManagerDelegate {
    func centralManager(_ central: CentralManager, didDiscover peripheral: Peripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    func centralManager(_ central: CentralManager, didConnect peripheral: Peripheral)
    func centralManager(_ central: CentralManager, didFailToConnect peripheral: Peripheral, error: Error?)
    func centralManager(_ central: CentralManager, didDisconnectPeripheral peripheral: Peripheral, error: Error?)
}

class SimpleDelegate: NSObject, CBCentralManagerDelegate {
    weak var centralManager: ActualCentralManager?
    weak var delegate: SimpleCentralManagerDelegate?
    init(_ centralManager: ActualCentralManager, _ delegate: SimpleCentralManagerDelegate) {
        self.centralManager = centralManager
        self.delegate = delegate
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManagerDidUpdateState(centralManager)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManager(centralManager, didDiscover: centralManager.getPeripheral(for: peripheral), advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManager(centralManager, didConnect: centralManager.getPeripheral(for: peripheral))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManager(centralManager, didFailToConnect: centralManager.getPeripheral(for: peripheral), error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        delegate.centralManager(centralManager, didDisconnectPeripheral: centralManager.getPeripheral(for: peripheral), error: error)
    }
}
