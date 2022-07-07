// Henrik Top Mygind, 17/06/2022

import XCTest
import Utils
import CoreBluetoothWrapper
import AsyncBle

class AsyncPeripheral_AsyncTests: XCTestCase {

    // MARK: DiscoverServices
    func testDiscoverServices() async {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)

        mock.discoverServicesHandler = { _ in
            Task {
                mock.services = [MockService()]
                mock.delegate?.peripheral(mock, didDiscoverServices: nil)
            }
        }

        let result = await peripheral.discoverServicesAsync(nil)

        let actual = result?.map { $0.uuid }
        let expected = mock.services?.map { $0.uuid }

        XCTAssertNotNil(actual)
        XCTAssertEqual(actual, expected)
    }
    
    func testDiscoverServices_willTimeout() async {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)

        mock.discoverServicesHandler = { _ in
            Task {
                try? await Task.sleep(nanoseconds: UInt64(0.1.inNano))
                mock.services = [MockService()]
                mock.delegate?.peripheral(mock, didDiscoverServices: nil)
            }
        }

        let result = await peripheral.discoverServicesAsync(nil, timeout: .milliseconds(50))
        let actual = result?.map { $0.uuid }

        XCTAssertNil(actual)
    }
    
    // MARK: DiscoverCharacteristics
    func testDiscoverCharacteristicsAsync() async {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)
        let mockService = MockService()
        
        mock.services = [mockService]
        
        mock.discoverCharacteristicsHandler = { (characteristics, service) in
            Task {
                mockService.characteristics = [MockCharacteristic()]
                mock.delegate?.peripheral(mock, didDiscoverCharacteristicsFor: service, error: nil)
            }
        }
        
        let characteristics = await peripheral.discoverCharacteristicsAsync(nil, for: mockService)
        let actual = characteristics?.map { $0.uuid }
        let expected = mockService.characteristics?.map { $0.uuid }
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual, expected)
    }
    
    func testDiscoverServicesAndCharacteristicsAsync() async {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)
        let mockService = MockService()
        
        mock.discoverServicesHandler = { (services) in
            Task {
                mock.services = [mockService]
                mock.delegate?.peripheral(mock, didDiscoverServices: nil)
            }
        }
        
        mock.discoverCharacteristicsHandler = { (characteristics, service) in
            Task {
                mockService.characteristics = [MockCharacteristic()]
                mock.delegate?.peripheral(mock, didDiscoverCharacteristicsFor: service, error: nil)
            }
        }

        let services = await peripheral.discoverServicesAndCharacteristicsAsync(nil)
        let characteristics = services?.flatMap { s in s.characteristics ?? [] }
        
        XCTAssertNotNil(services)
        XCTAssertEqual(services?.map { $0.uuid }, [mockService.uuid])
        XCTAssertNotNil(characteristics)
        XCTAssertEqual(characteristics?.map { $0.uuid }, mockService.characteristics?.map { $0.uuid })

    }
    
    // MARK: ReadValueAsync
    func testReadValueAsync() async {
        let mock = MockPeripheral()
        let peripheral = AsyncPeripheral(mock)
        let mockCharacteristic = MockCharacteristic()
        
        mock.readValueHandler = { _ in
            Task {
                mockCharacteristic.value = Data([13, 37])
                mock.delegate?.peripheral(mock, didUpdateValueFor: mockCharacteristic, error: nil)
            }
        }
        
        let value = await peripheral.readValueAsync(mockCharacteristic)
        
        let expected = mockCharacteristic.value
        XCTAssertNotNil(value)
        XCTAssertEqual(value, expected)
    }
}
