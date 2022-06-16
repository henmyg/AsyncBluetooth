// Henrik Top Mygind, 05/06/2022

import Foundation
import CoreBluetooth

public protocol Peripheral: AnyObject {
    var identifier: UUID { get }
    var name: String? { get }
    var delegate: PeripheralDelegate? { get set }
    var state: CBPeripheralState { get }
    var services: [Service]? { get }
    
    func discoverServices(_ serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service)
    
    func setNotifyValue(_ value: Bool, for characteristic: Characteristic)
        
    func readValue(for characteristic: Characteristic)
    func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType)
    
    func readRSSI()
}

public protocol PeripheralDelegate: AnyObject {
    func peripheral(_ peripheral: Peripheral, didDiscoverServices error: Error?)
    func peripheral(_ peripheral: Peripheral, didDiscoverCharacteristicsFor service: Service, error: Error?)
    func peripheral(_ peripheral: Peripheral, didUpdateValueFor characteristic: Characteristic, error: Error?)
    
    func peripheral(_ peripheral: Peripheral, didReadRSSI RSSI: NSNumber, error: Error?)
}
