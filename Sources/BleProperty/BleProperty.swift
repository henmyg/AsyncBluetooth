// Henrik Top Mygind, 21/06/2022

import Foundation
import Combine
import CoreBluetooth
import CoreBluetoothWrapper
import AsyncBle

open class AsymetricBleProperty<TRead: DataDecodable, TWrite: DataEncodable> {
    
    public init?(_ peripheral: AsyncPeripheral,
          service: CBUUID,
          characteristic: CBUUID) {
        guard
            let characteristic = peripheral.services?.first(where: { $0.uuid == service })?
                .characteristics?.first(where: { $0.uuid == characteristic })
        else {
            return nil
        }
        
        self.peripheral = peripheral
        self.characteristic = characteristic
    }
    
    public init(_ peripheral: AsyncPeripheral,
         characteristic: Characteristic) {
        self.peripheral = peripheral
        self.characteristic = characteristic
    }
    
    public let peripheral: AsyncPeripheral
    public let characteristic: Characteristic
    
    public var values: AnyPublisher<TRead?, Never> {
        peripheral.didUpdateValue
            .filter { [weak self] in $0.characteristic.uuid == self?.characteristic.uuid }
            .map { .init($0.characteristic.value) }
            .eraseToAnyPublisher()
    }
}

open class BleProperty<TValue: DataEncodable & DataDecodable> : AsymetricBleProperty<TValue, TValue> { }
