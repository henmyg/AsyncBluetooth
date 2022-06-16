// Henrik Top Mygind, 01/06/2022

import CoreBluetooth

public protocol CentralManager: AnyObject {
    var delegate: CentralManagerDelegate? { get set }
    var state: CBManagerState { get }
    var isScanning: Bool { get }
    
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?)
    func stopScan()
    
    func connect(_ peripheral: Peripheral, options: [String : Any]?)
    func cancelPeripheralConnection(_ peripheral: Peripheral)
}

public extension CentralManager {
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?) {
        scanForPeripherals(withServices: serviceUUIDs, options: nil)
    }
    
    func connect(_ peripheral: Peripheral) {
        connect(peripheral, options: nil)
    }
}

public enum CentralManagerDelegate {
    case basic(delegate: BasicCentralManagerDelegate)
    case simple(delegate: SimpleCentralManagerDelegate)
    case restoring(delegate: RestoringCentralManagerDelegate)
}
