// Henrik Top Mygind, 21/06/2022

import XCTest
import Combine
import CoreBluetoothWrapper
import BleProperty
import AsyncBle

extension Int: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}


class BlePropertyTests: XCTestCase {

    struct ExampleData: DataCodable, Equatable {
        var value: Int
        
        init(_ value: Int) {
            self.value = value
        }
        
        init?(_ data: Data?) {
            guard let value = Int(data) else {
                return nil
            }
            
            self.value = value
        }
        
        var data: Data {
            value.data
        }
    }
    
    class ReadableExample: BleProperty<ExampleData> & ReadableProperty { }
    class WritableExample: BleProperty<ExampleData> & WritableProperty {
        typealias TWrite = ExampleData
    }
    class SubscribableExample: BleProperty<ExampleData> & SubscribableProperty {}
    
    func testExample() async {
        let service = MockService()
        let c1 = MockCharacteristic()
        let c2 = MockCharacteristic()
        let c3 = MockCharacteristic()
        let mock = MockPeripheral()
        mock.services = [service]
        service.characteristics = [c1, c2, c3]
        
        let peripheral = AsyncPeripheral(mock)
        guard
            let readable = ReadableExample(peripheral, service: service.uuid, characteristic: c1.uuid),
            let writable = WritableExample(peripheral, service: service.uuid, characteristic: c2.uuid),
            let subscribable = SubscribableExample(peripheral, service: service.uuid, characteristic: c3.uuid) else {
            XCTFail("Couldn't create property")
            return
        }
        
        _ = await readable.read(timeout: .milliseconds(200))
        writable.write(ExampleData(42))
        var received = [Int]()
        _ = subscribable.subscribe()
            .compactMap { $0?.value }
            .sink { value in
                received.append(value)
            }
        
        XCTAssertTrue(true)
    }
    
    func testCanRead() async {
        let service = MockService()
        let characteristic = MockCharacteristic()
        let mock = MockPeripheral()
        mock.services = [service]
        service.characteristics = [characteristic]
        
        let peripheral = AsyncPeripheral(mock)
        
        guard
            let readable = ReadableExample(peripheral, service: service.uuid, characteristic: characteristic.uuid) else {
            XCTFail("Couldn't create property")
            return
        }
        
        mock.readValueHandler = { c in
            Task {
                try? await Task.sleep(nanoseconds: UInt64(0.1.inNano))
                characteristic.value = Data([27,0,0,0, 0,0,0,0])
                mock.delegate?.peripheral(mock, didUpdateValueFor: c, error: nil)
            }
        }
        
        let readValue = await readable.read(timeout: .milliseconds(200))
        
        XCTAssertEqual(readValue, ExampleData(27))
    }
    
    func testCanWrite() async {
        let service = MockService()
        let characteristic = MockCharacteristic()
        let mock = MockPeripheral()
        mock.services = [service]
        service.characteristics = [characteristic]
        
        let peripheral = AsyncPeripheral(mock)
        
        guard
            let writable = WritableExample(peripheral, service: service.uuid, characteristic: characteristic.uuid) else {
            XCTFail("Couldn't create property")
            return
        }
        
        let didWrite = expectation(description: "Did write")
        mock.writeHandler = { (d, c, t) in
            XCTAssertEqual(d, Data([42,0,0,0, 0,0,0,0]))
            didWrite.fulfill()
        }
        
        writable.write(ExampleData(42))
        wait(for: [didWrite], timeout: 0.5)
    }
    
    func testCanSubscribe() async {
        let service = MockService()
        let characteristic = MockCharacteristic()
        let mock = MockPeripheral()
        mock.services = [service]
        service.characteristics = [characteristic]
        
        let peripheral = AsyncPeripheral(mock)
        
        guard
            let subscribable = SubscribableExample(peripheral, service: service.uuid, characteristic: characteristic.uuid) else {
            XCTFail("Couldn't create property")
            return
        }
        
        let didSubscribe = expectation(description: "Did subscribe")
        mock.setNotifyHandler = { (b, c) in
            XCTAssertEqual(b, true)
            didSubscribe.fulfill()
        }
        
        var received = [ExampleData?]()
        var bag = Set<AnyCancellable>()
        subscribable.subscribe().sink { data in
            received.append(data)
        }.store(in: &bag)
        
        characteristic.value = Data([1,0,0,0, 0,0,0,0])
        mock.delegate?.peripheral(mock, didUpdateValueFor: characteristic, error: nil)
        
        characteristic.value = Data([2,0,0,0, 0,0,0,0])
        mock.delegate?.peripheral(mock, didUpdateValueFor: characteristic, error: nil)
        
        characteristic.value = Data([3,0,0,0, 0,0,0,0])
        mock.delegate?.peripheral(mock, didUpdateValueFor: characteristic, error: nil)
        
        wait(for: [didSubscribe], timeout: 0.1)
        
        XCTAssertEqual(received, [ExampleData(1), ExampleData(2), ExampleData(3)])
    }
}
