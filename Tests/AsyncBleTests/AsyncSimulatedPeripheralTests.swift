// Henrik Top Mygind, 18/06/2022

import XCTest
import CoreBluetoothWrapper
import CoreBluetooth
import AsyncBle

class AsyncSimulatedPeripheralTests: XCTestCase {

    func testDiscoverIndivdualWorks() async {
        let serviceId1 = CBUUID(string: "DDEE0001")
        let charId1 = CBUUID(string: "AABB0101")
        let charId2 = CBUUID(string: "AABB0102")
        let service1 = SimulatedService(uuid: serviceId1, simulatedCharacteristics: [
            SimulatedCharacteristic(uuid: charId1),
            SimulatedCharacteristic(uuid: charId2)
        ])
        
        let serviceId2 = CBUUID(string: "DDEE0002")
        let charId3 = CBUUID(string: "AABB0201")
        let charId4 = CBUUID(string: "AABB0202")
        let service2 = SimulatedService(uuid: serviceId2, simulatedCharacteristics: [
            SimulatedCharacteristic(uuid: charId3),
            SimulatedCharacteristic(uuid: charId4)
        ])
        
        let peripheral = SimulatedPeripheral(simulatedServices: [service1, service2])
        peripheral.setState(.connected)
        
        let asyncPeripheral = AsyncPeripheral(peripheral)
        
        let services = await asyncPeripheral.discoverServicesAndCharacteristicsAsync([
            serviceId1: [charId2]
        ])
        
        XCTAssertNotNil(services)
        XCTAssertEqual(services?.map { $0.uuid }, [serviceId1])
        XCTAssertNotNil(services?.first?.characteristics)
        XCTAssertEqual(
            services?.first?.characteristics?.map { $0.uuid },
            [charId2])
    }
}
