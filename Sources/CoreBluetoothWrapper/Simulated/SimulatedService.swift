// Henrik Top Mygind, 13/06/2022

import Foundation
import CoreBluetooth

public class SimulatedService: Service {
    public init(
        uuid: CBUUID? = nil,
        simulatedCharacteristics: [SimulatedCharacteristic]? = nil
    ) {
        self.uuid = uuid ?? self.uuid
        self._simulatedCharacteristics = simulatedCharacteristics
    }
    
    public private(set) var uuid: CBUUID = CBUUID()
    
    public let isPrimary: Bool = false
    
    final public private(set) var characteristics: [Characteristic]?
    
    // SIMULATION
    private var _simulatedCharacteristics: [Characteristic]?
    public var simulatedCharacteristics: [Characteristic] {
        guard let _simulatedCharacteristics = _simulatedCharacteristics else {
            let characteristics = createSimulatedCharacteristics()
            _simulatedCharacteristics = characteristics
            return characteristics
        }

        return _simulatedCharacteristics
    }
    func createSimulatedCharacteristics() -> [SimulatedCharacteristic] {
        return [ SimulatedCharacteristic() ]
    }
    
    final func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?) async {
        try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
        if let characteristicUUIDs = characteristicUUIDs {
            let newCharacteristics = simulatedCharacteristics.filter { characteristicUUIDs.contains($0.uuid) }
            characteristics = ((characteristics ?? []) + newCharacteristics).distinct{ $0.uuid }
        } else {
            characteristics = simulatedCharacteristics
        }
    }
}
