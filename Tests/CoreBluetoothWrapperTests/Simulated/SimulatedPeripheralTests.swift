// Henrik Top Mygind, 18/06/2022

import XCTest
import CoreBluetoothWrapper
import CoreBluetooth

class SimulatedPeripheralTests: XCTestCase {
    func testDiscoverServicesWorks() {
        let simulated = SimulatedPeripheral()
        let mockDelegate = MockPeripheralDelegate()
        
        guard let service = simulated.simulatedServices.first else {
            XCTFail()
            return
        }
        
        simulated.delegate = mockDelegate
        
        XCTAssertNil(simulated.services)
        
        let didDiscover = expectation(description: "DidDiscover")
        mockDelegate.didDiscoverServicesHandler = { _,_ in
            didDiscover.fulfill()
        }
        
        simulated.setState(.connected)
        simulated.discoverServices(nil)
        
        wait(for: [didDiscover], timeout: 0.5)
        
        XCTAssertNotNil(simulated.services)
        XCTAssertEqual([service].map { $0.uuid }, simulated.services?.map { $0.uuid })
    }
    
    func testDiscoverIndividualServicesWorks() {
        let serviceIdOne = CBUUID(data: Data([1,2,3,4]))
        let serviceIdTwo = CBUUID(data: Data([5,6,7,8]))
        let simulated = SimulatedPeripheral(simulatedServices: [
            SimulatedService(uuid: serviceIdOne),
            SimulatedService(uuid: serviceIdTwo)
        ])
        let mockDelegate = MockPeripheralDelegate()
        simulated.delegate = mockDelegate
        
        XCTAssertNil(simulated.services)
        
        let didDiscover = expectation(description: "DidDiscover")
        mockDelegate.didDiscoverServicesHandler = { _,_ in
            didDiscover.fulfill()
        }
        
        simulated.setState(.connected)
        simulated.discoverServices([serviceIdOne])
        
        wait(for: [didDiscover], timeout: 0.5)
        
        XCTAssertNotNil(simulated.services)
        XCTAssertEqual([serviceIdOne], simulated.services?.map { $0.uuid })
    }
    
    func testDiscoverIndividualCharacteristicsWorks() {
        let serviceIdOne = CBUUID(data: Data([1,2,5,6]))
        let characteristicIdOne = CBUUID(data: Data([1,2,3,4]))
        let characteristicIdTwo = CBUUID(data: Data([5,6,7,8]))
        let simulatedService = SimulatedService(uuid: serviceIdOne, simulatedCharacteristics: [
            SimulatedCharacteristic(uuid: characteristicIdOne),
            SimulatedCharacteristic(uuid: characteristicIdTwo)
        ])
        
        let simulatedPeripheral = SimulatedPeripheral(simulatedServices: [
            simulatedService
        ])
        let mockDelegate = MockPeripheralDelegate()
        simulatedPeripheral.delegate = mockDelegate
        
        XCTAssertNil(simulatedPeripheral.services)
        
        let didDiscover = expectation(description: "DidDiscover")
        mockDelegate.didDiscoverCharacteristicsHandler = { _,_,_ in
            didDiscover.fulfill()
        }
        
        simulatedPeripheral.setState(.connected)
        simulatedPeripheral.discoverServices([serviceIdOne])
        simulatedPeripheral.discoverCharacteristics([characteristicIdOne], for: simulatedService)
        
        wait(for: [didDiscover], timeout: 0.5)
        
        XCTAssertNotNil(simulatedPeripheral.services)
        XCTAssertEqual([characteristicIdOne], simulatedPeripheral.services?.first?.characteristics?.map { $0.uuid })
    }
}
