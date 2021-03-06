// Henrik Top Mygind, 17/06/2022

import Foundation
import Combine
import CoreBluetooth
import CoreBluetoothWrapper

public class AsyncPeripheral {
    public init(_ peripheral: Peripheral) {
        self.peripheral = peripheral
        peripheral.delegate = self
    }
    
    public let peripheral: Peripheral
    
    // MARK: Delegate
    private let _didDiscoverServices = PassthroughSubject<DidDiscoverServicesValue, Never>()
    public var didDiscoverServices: AnyPublisher<DidDiscoverServicesValue, Never> { _didDiscoverServices.eraseToAnyPublisher() }
    
    private let _didDiscoverCharacteristics = PassthroughSubject<DidDiscoverCharacteristicsValue, Never>()
    public var didDiscoverCharacteristics: AnyPublisher<DidDiscoverCharacteristicsValue, Never> {
        _didDiscoverCharacteristics.eraseToAnyPublisher()
    }
    
    private let _didUpdateValue = PassthroughSubject<DidUpdateValueValue, Never>()
    public var didUpdateValue: AnyPublisher<DidUpdateValueValue, Never> { _didUpdateValue.eraseToAnyPublisher() }
    
    private let _didReadRssi = PassthroughSubject<DidReadRssiValue, Never>()
    public var didReadRssi: AnyPublisher<DidReadRssiValue, Never> { _didReadRssi.eraseToAnyPublisher() }
    
    // MARK: Peripheral
    public var identifier: UUID { peripheral.identifier }
    public var name: String? { peripheral.name }
    public var state: CBPeripheralState { peripheral.state }
    public var services: [Service]? { peripheral.services }
    
    public func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        peripheral.discoverServices(serviceUUIDs)
    }
    
    public func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: Service) {
        peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
    }
    
    public func setNotifyValue(_ value: Bool, for characteristic: Characteristic) {
        peripheral.setNotifyValue(value, for: characteristic)
    }
    
    public func readValue(for characteristic: Characteristic) {
        peripheral.readValue(for: characteristic)
    }
    
    public func writeValue(_ data: Data, for characteristic: Characteristic, type: CBCharacteristicWriteType) {
        peripheral.writeValue(data, for: characteristic, type: type)
    }
    
    public func readRSSI() {
        peripheral.readRSSI()
    }
    
    // MARK: ValueTypes
    public struct DidDiscoverServicesValue {
        public let peripheral: Peripheral
        public let error: Error?
    }
    
    public struct DidDiscoverCharacteristicsValue {
        public let peripheral: Peripheral
        public let service: Service
        public let error: Error?
    }
    
    public struct DidUpdateValueValue {
        public let peripheral: Peripheral
        public let characteristic: Characteristic
        public let error: Error?
    }
    
    public struct DidReadRssiValue {
        public let peripheral: Peripheral
        public let rssi: NSNumber
        public let error: Error?
    }
}

extension AsyncPeripheral : PeripheralDelegate {
    public func peripheral(_ peripheral: Peripheral, didDiscoverServices error: Error?) {
        _didDiscoverServices.send(DidDiscoverServicesValue(peripheral: peripheral, error: error))
    }
    
    public func peripheral(_ peripheral: Peripheral, didDiscoverCharacteristicsFor service: Service, error: Error?) {
        _didDiscoverCharacteristics.send(DidDiscoverCharacteristicsValue(
            peripheral: peripheral,
            service: service,
            error: error))
    }
    
    public func peripheral(_ peripheral: Peripheral, didUpdateValueFor characteristic: Characteristic, error: Error?) {
        _didUpdateValue.send(DidUpdateValueValue(
            peripheral: peripheral,
            characteristic: characteristic,
            error: error))
    }
    
    public func peripheral(_ peripheral: Peripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        _didReadRssi.send(DidReadRssiValue(peripheral: peripheral, rssi: RSSI, error: error))
    }
}
