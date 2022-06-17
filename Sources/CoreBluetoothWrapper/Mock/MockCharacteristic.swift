// Henrik Top Mygind, 17/06/2022

import Foundation
import CoreBluetooth

public class MockCharacteristic: Characteristic {
    public init() { }
    
    public var uuid: CBUUID = CBUUID()
    
    public var value: Data?
    
    public var properties: CBCharacteristicProperties = [.read, .write, .indicate]
    
    public var isNotifying: Bool = false
}
