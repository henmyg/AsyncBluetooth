// Henrik Top Mygind, 13/06/2022

import Foundation
import CoreBluetooth

public class SimulatedCharacteristic: Characteristic {
    public init(uuid: CBUUID? = nil, properties: CBCharacteristicProperties? = nil) {
        self.uuid = uuid ?? self.uuid
        self.properties = properties ?? self.properties
    }
    public private(set) var uuid: CBUUID = CBUUID()
    
    final public private(set) var value: Data?
    
    public private(set) var properties: CBCharacteristicProperties = [.read, .write, .notify]
    
    final public private(set) var isNotifying: Bool = false
    
    // SIMULATION
    func setValue(_ value: Data?) {
        self.value = value
    }
    
    func setIsNotifying(_ isNotifying: Bool) {
        self.isNotifying = isNotifying
    }
}
