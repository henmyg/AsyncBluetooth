// Henrik Top Mygind, 18/06/2022

import Foundation

public class MockPeripheralDelegate: PeripheralDelegate {
    public init() { }
    
    public var didDiscoverServicesHandler: ((_ peripheral: Peripheral, _ error: Error?) -> Void)?
    public func peripheral(_ peripheral: Peripheral, didDiscoverServices error: Error?) {
        didDiscoverServicesHandler?(peripheral, error)
    }
    
    public var didDiscoverCharacteristicsHandler: ((_ peripheral: Peripheral, _ service: Service, _ error: Error?) -> Void)?
    public func peripheral(_ peripheral: Peripheral, didDiscoverCharacteristicsFor service: Service, error: Error?) {
        didDiscoverCharacteristicsHandler?(peripheral, service, error)
    }
    
    public var didUpdateValueHandler: ((_ peripheral: Peripheral, _ characteristic: Characteristic, _ error: Error?) -> Void)?
    public func peripheral(_ peripheral: Peripheral, didUpdateValueFor characteristic: Characteristic, error: Error?) {
        didUpdateValueHandler?(peripheral, characteristic, error)
    }
    
    public var didReadRssiHandler: ((_ peripheral: Peripheral, _ rssi: NSNumber, _ error: Error?) -> Void)?
    public func peripheral(_ peripheral: Peripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        didReadRssiHandler?(peripheral, RSSI, error)
    }
}
   
