// Henrik Top Mygind, 17/06/2022

import Foundation
import CoreBluetooth
import CombineUtils
import CoreBluetoothWrapper

public extension AsyncPeripheral {
    // MARK: Discover
    func discoverServicesAsync(
        _ serviceUUIDs: [CBUUID]?,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(1)
    ) async -> [Service]? {
        async let services = didDiscoverServices
            .map { $0.peripheral.services }
            .async(timeout: timeout)
        discoverServices(serviceUUIDs)
        return await services as? [Service]
    }
    
    func discoverCharacteristicsAsync(
        _ characteristicUUIDs: [CBUUID]?,
        for service: Service,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(1)
    ) async -> [Characteristic]? {
        async let characteristics = didDiscoverCharacteristics
            .map { $0.peripheral.services?
                    .first(where: { s in s.uuid == service.uuid})
                    .map { $0.characteristics }
            }
            .async(timeout: timeout)
        discoverCharacteristics(characteristicUUIDs, for: service)
        return await characteristics as? [Characteristic]
    }
    
    func discoverServicesAndCharacteristicsAsync(
        _ dict: [CBUUID: [CBUUID]?]?,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(5)
    ) async -> [Service]? {
        guard let dict = dict else {
            
            return nil
        }
        
        let services = await discoverServicesAsync(Array(dict.keys), timeout: timeout) ?? []
        
        let resultingServices = await withTaskGroup(of: [Characteristic]?.self)
        { (group: inout TaskGroup<[Characteristic]?>) -> [Service] in
            for service in services {
                let characteristicUUIDs = dict[service.uuid] as? [CBUUID]
                group.addTask { [weak self] in
                    return await self?.discoverCharacteristicsAsync(characteristicUUIDs, for: service, timeout: timeout)
                }
            }
            
            await group.waitForAll()
            
            return services
        }
        
        return resultingServices
    }
    
    // MARK: Read
    func readValueAsync(
        _ characteristic: Characteristic,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(1)
    ) async -> Data? {
        async let value = didUpdateValue
            .first(where: { $0.characteristic.uuid == characteristic.uuid })
            .map { $0.characteristic.value }
            .async(timeout: timeout)
        
        readValue(for: characteristic)
        return await value as? Data
    }
}
