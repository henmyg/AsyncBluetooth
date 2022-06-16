// Henrik Top Mygind, 11/06/2022

import CoreBluetooth

public class SimulatedPeripheral: Peripheral {
    public let identifier: UUID = UUID()
    
    public let name: String? = "Simulated"
    
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
        // TODO: Handler individual services
        
        guard state == .connected else {
            print("Can't communicate with non connected peripheral")
            return
        }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
            services = createSimulatedServices()
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
    
    public func createSimulatedServices() -> [SimulatedService] {
        return [SimulatedService()]
    }
    
    func setState(_ state: CBPeripheralState) {
        self.state = state
    }
}
