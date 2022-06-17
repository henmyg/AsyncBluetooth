// Henrik Top Mygind, 05/06/2022

import Foundation
import CoreBluetooth
import Utils

public class ActualCentralManager: NSObject, CentralManager {
    private var centralManager: CBCentralManager!
    
    private var peripherals = [UUID : Weak<ActualPeripheral>]()
    
    public init(delegate: CentralManagerDelegate?, queue: DispatchQueue?, options: [String : Any]) {
        super.init()
        centralManager = CBCentralManager(delegate: nil, queue: queue, options: options)
        self.delegate = delegate
    }
    
    private var _delegate: CBCentralManagerDelegate?
    
    public var delegate: CentralManagerDelegate? {
        get { return nil }
        set {
            switch newValue {
            case let .basic(delegate: basic):
                _delegate = BasicDelegate(self, basic.delegate)
            case let .simple(delegate: simple):
                _delegate = SimpleDelegate(self, simple.delegate)
            case let .restoring(delegate: restoring):
                _delegate = RestoringDelegate(self, restoring.delegate)
            default:
                centralManager.delegate = nil
            }
            centralManager.delegate = _delegate
        }
    }
    
    public var state: CBManagerState { centralManager.state }
    
    public var isScanning: Bool { centralManager.isScanning }
    
    public func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    public func stopScan() {
        centralManager.stopScan()
    }
    
    public func connect(_ peripheral: Peripheral, options: [String : Any]?) {
        guard let actualPeripheral = peripheral as? ActualPeripheral else { return }
        
        centralManager.connect(actualPeripheral.peripheral, options: options)
    }
    
    public func cancelPeripheralConnection(_ peripheral: Peripheral) {
        guard let actualPeripheral = peripheral as? ActualPeripheral else { return }
        
        centralManager.cancelPeripheralConnection(actualPeripheral.peripheral)
    }
    
    func getPeripheral(for peripheral: CBPeripheral) -> Peripheral {
        if let existingPeripheral = peripherals[peripheral.identifier]?.value {
            return existingPeripheral
        }
        
        let newPeripheral = ActualPeripheral(peripheral)
        peripherals[peripheral.identifier] = Weak(newPeripheral)
        return newPeripheral
    }
}
