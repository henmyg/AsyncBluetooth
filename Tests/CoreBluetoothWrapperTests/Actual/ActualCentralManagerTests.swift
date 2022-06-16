// Henrik Top Mygind, 01/06/2022

import XCTest
import Foundation
import CoreBluetoothWrapper

class CentralManagerTests: XCTestCase {

    class ExampleDelegate: RestoringCentralManagerDelegate {
        func centralManager(_ central: CentralManager, willRestoreState dict: [String : Any]) {
        }
        
        func centralManager(_ central: CentralManager, didDiscover peripheral: Peripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            peripheral.readRSSI()
        }
        
        func centralManager(_ central: CentralManager, didConnect peripheral: Peripheral) {
        }
        
        func centralManager(_ central: CentralManager, didFailToConnect peripheral: Peripheral, error: Error?) {
        }
        
        func centralManager(_ central: CentralManager, didDisconnectPeripheral peripheral: Peripheral, error: Error?) {
        }
        
        func centralManagerDidUpdateState(_ central: CentralManager) {
        }
    }
    
    func test_canBuild() async {
        let manager = ActualCentralManager(delegate: .restoring(delegate: ExampleDelegate()), queue: nil, options: [:])
        XCTAssertNotNil(manager)
    }
    
    func test_doesntKeepDelegtaeAlive() {
        var strongDelegate: ExampleDelegate? = ExampleDelegate()
        weak var weakDelegate = strongDelegate
        let _ = ActualCentralManager(delegate: .restoring(delegate: strongDelegate!), queue: nil, options: [:])
        XCTAssertNotNil(weakDelegate)
        
        strongDelegate = nil
        XCTAssertNil(weakDelegate)
    }

}
