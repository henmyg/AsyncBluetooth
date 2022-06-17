// Henrik Top Mygind, 16/06/2022

import Foundation
import CoreBluetooth

public class MockPeripheral : Peripheral {
    public init() { }
    
    public var identifier: UUID = UUID()
    
    public var name: String?
    
    public var delegate: PeripheralDelegate?
    
    public var state: CBPeripheralState = .disconnected
    
    public var services: [Service]?
    
    public func discoverServices(_ serviceUUIDs: [CBUUID]?) {
    }
    
    public func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service) {
    }
    
    public func setNotifyValue(_ value: Bool, for characteristic: Characteristic) {
    }
    
    public func readValue(for characteristic: Characteristic) {
    }
    
    public func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType) {
    }
    
    public func readRSSI() {
    }
}
