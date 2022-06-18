// Henrik Top Mygind, 11/06/2022

import CoreBluetooth

public class SimulatedPeripheral: Peripheral {
    public init(
        identifier: UUID? = nil,
        name: String? = nil,
        simulatedServices: [SimulatedService]? = nil
    ) {
        self.identifier = identifier ?? self.identifier
        self.name = name ?? self.name
        self._simulatedServices = simulatedServices
    }
    
    public private(set) var identifier: UUID = UUID()
    
    public private(set) var name: String? = "Simulated"
    
    public weak var delegate: PeripheralDelegate?
    
    final public private(set) var state: CBPeripheralState = .disconnected {
        didSet {
            if state == .disconnected {
                services = nil
            }
        }
    }
    
    final public private(set) var services: [Service]?
    
    final public func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
            if let serviceUUIDs = serviceUUIDs {
                let newServices = simulatedServices.filter { serviceUUIDs.contains($0.uuid) }
                services = ((services ?? []) + newServices).distinct{ $0.uuid }
            } else {
                services = simulatedServices
            }
            delegate?.peripheral(self, didDiscoverServices: nil)
        }
    }
    
    final public func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service) {
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        guard let service = service as? SimulatedService else {
            fatalError("Only supporting simulated services")
        }
        
        Task {
            await service.discoverCharacteristics(characteristicUUIDs)
            delegate?.peripheral(self, didDiscoverCharacteristicsFor: service, error: nil)
        }
    }
    
    final public func setNotifyValue(_ value: Bool, for characteristic: Characteristic) {
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        guard let characteristic = characteristic as? SimulatedCharacteristic else {
            fatalError("Only supporting simulated characteristics")
        }
        
        characteristic.setIsNotifying(value)
    }
    
    final public func readValue(for characteristic: Characteristic) {
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
            delegate?.peripheral(self, didUpdateValueFor: characteristic, error: nil)
        }
    }
    
    final public func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType) {
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        guard let characteristic = characteristic as? SimulatedCharacteristic else {
            fatalError("Only supporting simulated characteristics")
        }
        
        characteristic.setValue(data)
        
        if characteristic.isNotifying {
            Task {
                try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
                delegate?.peripheral(self, didUpdateValueFor: characteristic, error: nil)
            }
        }
    }
    
    final public func readRSSI() {
    }
    
    // SIMULATION
    private var _simulatedServices: [SimulatedService]?
    public var simulatedServices: [SimulatedService] {
        guard let _simulatedServices = _simulatedServices else {
            let services = createSimulatedServices()
            _simulatedServices = services
            return services
        }
        return _simulatedServices
        
    }
    
    public func createSimulatedServices() -> [SimulatedService] {
        return [SimulatedService()]
    }
    
    public func setState(_ state: CBPeripheralState) {
        self.state = state
    }
}

extension Array {
    func distinct<TKey: Hashable>(using keyExtractor: (Element) -> TKey) -> Array {
        var uniques = Set<TKey>()
        return self.filter {
            let key = keyExtractor($0)
            if uniques.contains(key) {
                return false
            }
            uniques.insert(key)
            return true
        }
    }
}
