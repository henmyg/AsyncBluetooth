// Henrik Top Mygind, 09/06/2022

import Foundation
import CoreBluetooth

public class MockCentralManager: CentralManager {
    
    public init() { }
    
    public var delegate: CentralManagerDelegate?
    public var state: CBManagerState = .poweredOn
    public var isScanning: Bool = false
    
    public func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
    }
    
    public func stopScan() {
    }
    
    public func connect(_ peripheral: Peripheral, options: [String : Any]?) {
    }
    
    public func cancelPeripheralConnection(_ peripheral: Peripheral) {
    }
}
