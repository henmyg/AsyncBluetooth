// Henrik Top Mygind, 16/06/2022

import Foundation
import CoreBluetooth

public class MockPeripheral : Peripheral {
    public init() { }
    
    public var identifier: UUID = UUID()
    
    public var name: String?
    
    public weak var delegate: PeripheralDelegate?
    
    public var state: CBPeripheralState = .disconnected
    
    public var services: [Service]?
    
    public var discoverServicesHandler: ((_ serviceUUIDs: [CBUUID]?) -> Void)?
    public func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        discoverServicesHandler?(serviceUUIDs)
    }
    
    public var discoverCharacteristicsHandler: ((_ characteristicUUIDs: [CBUUID]?, _ service: Service) -> Void)?
    public func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service) {
        discoverCharacteristicsHandler?(characteristicUUIDs, service)
    }
    
    public var setNotifyHandler: ((Bool, Characteristic) -> Void)?
    public func setNotifyValue(_ value: Bool, for characteristic: Characteristic) {
        setNotifyHandler?(value, characteristic)
    }
    
    public var readValueHandler: ((_ characteristic: Characteristic) -> Void)?
    public func readValue(for characteristic: Characteristic) {
        readValueHandler?(characteristic)
    }
    
    public var writeHandler: ((Data, Characteristic, CBCharacteristicWriteType) -> Void)?
    public func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType) {
        writeHandler?(data, characteristic, type)
    }
    
    public func readRSSI() {
    }
}
