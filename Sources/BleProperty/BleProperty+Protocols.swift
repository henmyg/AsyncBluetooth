// Henrik Top Mygind, 21/06/2022

import Foundation
import Combine
import CoreBluetooth
import CoreBluetoothWrapper
import AsyncBle

public protocol ReadableProperty {
    associatedtype TRead
    var peripheral: AsyncPeripheral { get }
    var characteristic: Characteristic { get }
    var values: AnyPublisher<TRead?, Never> { get }
}

public extension ReadableProperty {
    func read(timeout:  DispatchQueue.SchedulerTimeType.Stride = .seconds(3)) async -> TRead? {
        async let result = values.async(timeout: timeout)
        peripheral.readValue(for: characteristic)
        return await result as? TRead
    }
}

public protocol WritableProperty {
    associatedtype TWrite: DataEncodable
    
    var peripheral: AsyncPeripheral { get }
    var characteristic: Characteristic { get }
}

public extension WritableProperty {
    func write(_ value: TWrite, writeType: CBCharacteristicWriteType = .withResponse) {
        peripheral.writeValue(value.data, for: characteristic, type: writeType)
    }
}

public protocol SubscribableProperty {
    associatedtype TRead
    
    var peripheral: AsyncPeripheral { get }
    var characteristic: Characteristic { get }
    var values: AnyPublisher<TRead?, Never> { get }
}

public extension SubscribableProperty {
    func subscribe() -> AnyPublisher<TRead?, Never> {
        peripheral.setNotifyValue(true, for: characteristic)
        return values
    }
}
