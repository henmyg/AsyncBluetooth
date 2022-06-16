// Henrik Top Mygind, 09/06/2022

import Foundation
import CoreBluetooth

class MockCentralManager: CentralManager {
    
    var delegate: CentralManagerDelegate?
    var state: CBManagerState = .poweredOn
    var isScanning: Bool = false
    
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
    }
    
    func stopScan() {
    }
    
    func connect(_ peripheral: Peripheral, options: [String : Any]?) {
    }
    
    func cancelPeripheralConnection(_ peripheral: Peripheral) {
    }
}
