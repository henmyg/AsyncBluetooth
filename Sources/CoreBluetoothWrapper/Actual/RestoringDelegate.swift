// Henrik Top Mygind, 05/06/2022

import Foundation
import CoreBluetooth

public protocol RestoringCentralManagerDelegate: SimpleCentralManagerDelegate {
    func centralManager(_ central: CentralManager, willRestoreState dict: [String : Any])
}

class RestoringDelegate: NSObject, CBCentralManagerDelegate {
    weak var centralManager: ActualCentralManager?
    weak var delegate: RestoringCentralManagerDelegate?
    init(_ centralManager: ActualCentralManager, _ delegate: RestoringCentralManagerDelegate) {
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
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        guard let centralManager = centralManager,
              let delegate = delegate else { return }
        
        var restoreDict = dict
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            restoreDict[CBCentralManagerRestoredStatePeripheralsKey] = peripherals.map {
                centralManager.getPeripheral(for: $0)
            }
        }
        
        delegate.centralManager(centralManager, willRestoreState: restoreDict)
    }
}
