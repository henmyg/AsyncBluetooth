// Henrik Top Mygind, 16/06/2022

import Foundation
import Combine
import CoreBluetooth
import CoreBluetoothWrapper

public class AsyncCentralManager {
    
    init(_ central: CentralManager) {
        self.central = central
    }
    
    let central: CentralManager
    
    let _didUpdateStates = PassthroughSubject<CentralManager, Never>()
    public var didUpdateState: AnyPublisher<CentralManager, Never> { _didUpdateStates.eraseToAnyPublisher() }
    
    let _didDiscover = PassthroughSubject<DidDiscoverValue, Never>()
    public var didDiscover: AnyPublisher<DidDiscoverValue, Never> { _didDiscover.eraseToAnyPublisher() }
    
    let _didConnect = PassthroughSubject<DidConnectValue, Never>()
    public var didConnect: AnyPublisher<DidConnectValue, Never> { _didConnect.eraseToAnyPublisher() }
    
    let _didFailToConnect = PassthroughSubject<DidFailToConnectValue, Never>()
    public var didFailToConnect: AnyPublisher<DidFailToConnectValue, Never> { _didFailToConnect.eraseToAnyPublisher() }
    
    let _didDisconnect = PassthroughSubject<DidDisconnectValue, Never>()
    public var didDisconnect: AnyPublisher<DidDisconnectValue, Never> { _didDisconnect.eraseToAnyPublisher() }
    
    // MARK: ValueTypes
    public struct DidDiscoverValue {
        public let central: CentralManager
        public let peripheral: Peripheral
        public let advertisementData: [String : Any]
        public let rssi: NSNumber
    }
    
    public struct DidConnectValue {
        public let central: CentralManager
        public let peripheral: Peripheral
    }
    
    public struct DidFailToConnectValue {
        public let central: CentralManager
        public let peripheral: Peripheral
        public let error: Error?
    }
    
    public struct DidDisconnectValue {
        public let central: CentralManager
        public let peripheral: Peripheral
        public let error: Error?
    }
    
    public struct WillRestoreStateValue {
        public let central: CentralManager
        public let dict: [String : Any]
    }
}

extension AsyncCentralManager {
    public func centralManagerDidUpdateState(_ central: CentralManager) {
        _didUpdateStates.send(central)
    }
    
    public func centralManager(_ central: CentralManager, didDiscover peripheral: Peripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        _didDiscover.send(DidDiscoverValue(
            central: central,
            peripheral: peripheral,
            advertisementData: advertisementData,
            rssi: RSSI))
    }
    
    public func centralManager(_ central: CentralManager, didConnect peripheral: Peripheral) {
        _didConnect.send(DidConnectValue(central: central, peripheral: peripheral))
    }
    
    public func centralManager(_ central: CentralManager, didFailToConnect peripheral: Peripheral, error: Error?) {
        _didFailToConnect.send(DidFailToConnectValue(central: central, peripheral: peripheral, error: error))
    }
    
    public func centralManager(_ central: CentralManager, didDisconnectPeripheral peripheral: Peripheral, error: Error?) {
        _didDisconnect.send(DidDisconnectValue(central: central, peripheral: peripheral, error: error))
    }
}

public class SimpleAsyncCentralManager : AsyncCentralManager, SimpleCentralManagerDelegate {
    public override init(_ central: CentralManager = ActualCentralManager(delegate: nil, queue: DispatchQueue(label: "ble"), options: [:])) {
        super.init(central)
        central.delegate = .simple(delegate: SimpleDelegateRef(self))
    }
}

public class RestoringAsyncCentralManager : AsyncCentralManager {
    public override init(_ central: CentralManager = ActualCentralManager(delegate: nil, queue: DispatchQueue(label: "ble"), options: [:])) {
        super.init(central)
        central.delegate = .restoring(delegate: RestoringDelegateRef(self))
    }
    
    private let _willRestoreState = PassthroughSubject<WillRestoreStateValue, Never>()
    public var willRestoreState: AnyPublisher<WillRestoreStateValue, Never> { _willRestoreState.eraseToAnyPublisher() }
}

extension RestoringAsyncCentralManager : RestoringCentralManagerDelegate {
    public func centralManager(_ central: CentralManager, willRestoreState dict: [String : Any]) {
        _willRestoreState.send(WillRestoreStateValue(central: central, dict: dict))
    }
}
