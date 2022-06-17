// Henrik Top Mygind, 17/06/2022

import XCTest
import Combine
import CoreBluetoothWrapper
import AsyncBle

class AsyncPeripheralTests: XCTestCase {

    func test_delegatesArePublished() {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)
        
        let didDiscoverServices = expectation(description: "DidDiscoverServices")
        let didDiscoverCharacteristics = expectation(description: "DidDiscoverCharacteristics")
        let didUpdateValue = expectation(description: "DidUpdateValue")
        let didReadRssi = expectation(description: "DidReadRssi")
        
        var subscriptions = Set<AnyCancellable>()
        peripheral.didDiscoverServices.sink { _ in didDiscoverServices.fulfill() }
            .store(in: &subscriptions)
        peripheral.didDiscoverCharacteristics.sink { _ in didDiscoverCharacteristics.fulfill() }
            .store(in: &subscriptions)
        peripheral.didUpdateValue.sink { _ in didUpdateValue.fulfill() }
            .store(in: &subscriptions)
        peripheral.didReadRssi.sink { _ in didReadRssi.fulfill() }
            .store(in: &subscriptions)
        
        mock.delegate?.peripheral(mock, didDiscoverServices: nil)
        mock.delegate?.peripheral(mock, didDiscoverCharacteristicsFor: MockService(), error: nil)
        mock.delegate?.peripheral(mock, didUpdateValueFor: MockCharacteristic(), error: nil)
        mock.delegate?.peripheral(mock, didReadRSSI: 42, error: nil)
        
        wait(for: [
            didDiscoverServices,
            didDiscoverCharacteristics,
            didUpdateValue,
            didReadRssi
        ], timeout: 0.3)
    }
}
