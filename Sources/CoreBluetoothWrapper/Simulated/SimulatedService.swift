// Henrik Top Mygind, 13/06/2022

import Foundation
import CoreBluetooth

public class SimulatedService: Service {
    public let uuid: CBUUID = CBUUID()
    
    public let isPrimary: Bool = false
    
    final public private(set) var characteristics: [Characteristic]?
    
    // SIMULATION
    func createSimulatedCharacteristics() -> [SimulatedCharacteristic] {
        return [ SimulatedCharacteristic() ]
    }
    
    final func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?) async {
        // TODO: Handler individual characteristics
        try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
        characteristics = createSimulatedCharacteristics()
    }
}
