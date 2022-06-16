// Henrik Top Mygind, 06/06/2022

import CoreBluetooth
import Utils

class ActualPeripheral: NSObject, Peripheral {
    let peripheral: CBPeripheral
    private var _services = [CBUUID : Weak<ActualService>]()
    
    init(_ peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    var identifier: UUID { peripheral.identifier }
    
    var name: String? { peripheral.name }    
    
    weak var delegate: PeripheralDelegate? {
        didSet {
            if delegate == nil {
                peripheral.delegate = nil
            } else {
                peripheral.delegate = self
            }
        }
    }
    
    var state: CBPeripheralState { peripheral.state }
    
    var services: [Service]? {
        peripheral.services?.map {
            getService(for: $0)
        }
    }
    
    private var characteristics: [Characteristic] {
        services?.flatMap { $0.characteristics ?? [] } ?? []
    }
    
    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        peripheral.discoverServices(serviceUUIDs)
    }
    
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service) {
        guard let service = getService(for: service) else { return }
        peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
    }
    
    func setNotifyValue(_ value: Bool, for characteristic: Characteristic) {
        guard let characteristic = getCharacteristic(for: characteristic) else { return }
        peripheral.setNotifyValue(value, for: characteristic)
    }
        
    func readValue(for characteristic: Characteristic) {
        guard let characteristic = getCharacteristic(for: characteristic) else { return }
        peripheral.readValue(for: characteristic)
    }
    
    func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType) {
        guard let characteristic = getCharacteristic(for: characteristic) else { return }
        peripheral.writeValue(data, for: characteristic, type: type)
    }
    
    func readRSSI() {
        peripheral.readRSSI()
    }
    
    private func getService(for service: CBService) -> Service {
        if let existingService = _services[service.uuid]?.value {
            return existingService
        }
        
        let newService = ActualService(service)
        _services[service.uuid] = Weak(newService)
        return newService
    }
    
    private func getService(for service: Service) -> CBService? {
        peripheral.services?.first { $0.uuid == service.uuid }
    }
    
    private func getCharacteristic(for characteristic: Characteristic) -> CBCharacteristic? {
        characteristic as? CBCharacteristic
    }
}

extension ActualPeripheral: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        delegate?.peripheral(self, didDiscoverServices: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        delegate?.peripheral(self, didDiscoverCharacteristicsFor: getService(for: service), error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristic = getCharacteristic(for: characteristic) else { return }
        delegate?.peripheral(self, didUpdateValueFor: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate?.peripheral(self, didReadRSSI: RSSI, error: error)
    }
}
