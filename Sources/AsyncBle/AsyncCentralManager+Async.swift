// Henrik Top Mygind, 20/06/2022

import Foundation
import CoreBluetooth
import CoreBluetoothWrapper

public extension AsyncCentralManager {
    
    @discardableResult
    func stateAsync(predicate: ((CBManagerState) -> Bool)? = nil) async -> CBManagerState {
        let predicate = predicate ?? { s in s == .poweredOn }
        if predicate(state) {
            return state
        }
        
        return await didUpdateState
            .map { m in m.state }
            .first(where: { s in predicate(s) })
            .async()
    }
    
    /**
     * Scans for the first peripheral with the given services.
     */
    func scanForPeripheralAsync(
        withServices services: [CBUUID]?,
        options: [String: Any]?,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(5)
    ) async -> Peripheral? {
        
        async let result = didDiscover
            .first()
            .async(timeout: timeout)
        
        scanForPeripherals(withServices: services, options: options)
        return await result?.peripheral
    }
    
    func connectAsync(
        _ peripheral: Peripheral,
        options: [String : Any]?,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(3)
    ) async -> Bool {
        
        async let result = didConnect
            .first { $0.peripheral.identifier == peripheral.identifier }
            .async(timeout: timeout)
        
        connect(peripheral, options: options)
        return await result != nil
    }
    
    func cancelPeripheralConnectionAsync(
        _ peripheral: Peripheral,
        timeout: DispatchQueue.SchedulerTimeType.Stride = .seconds(3)
    ) async -> Bool {
        async let result = didDisconnect
            .first { $0.peripheral.identifier == peripheral.identifier }
            .async(timeout: timeout)
        cancelPeripheralConnection(peripheral)
        return await result != nil
    }
}
