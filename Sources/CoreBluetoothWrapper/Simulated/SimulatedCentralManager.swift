// Henrik Top Mygind, 11/06/2022

import CoreBluetooth
import SwiftUI

public class SimulatedCentralManager : CentralManager {
    
    public init() {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(0.1.inNano))
            state = .poweredOn
            
            switch delegate {
            case .basic(delegate: let basic): basic.delegate?.centralManagerDidUpdateState(self)
            case .simple(delegate: let simple): simple.delegate?.centralManagerDidUpdateState(self)
            case .restoring(delegate: let restoring): restoring.delegate?.centralManagerDidUpdateState(self)
            default: break
            }
        }
    }
    
    public var delegate: CentralManagerDelegate?
    
    public var state: CBManagerState = .unknown
    
    public var isScanning: Bool = false
    
    public func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
        isScanning = true
        
        Task {
            while isScanning {
                for peripheral in simulatedPeripherals {
                    try? await Task.sleep(nanoseconds: UInt64(0.2.inNano))
                    
                    if isScanning == false {
                        break
                    }
                    
                    if peripheral.state != .disconnected {
                        continue
                    }
                    
                    switch delegate {
                    case .simple(delegate: let simple): simple.delegate?.centralManager(self, didDiscover: peripheral, advertisementData: [:], rssi: 42)
                    case .restoring(delegate: let restoring): restoring.delegate?.centralManager(self, didDiscover: peripheral, advertisementData: [:], rssi: 42)
                    default: break
                    }
                }
                
                try? await Task.sleep(nanoseconds: UInt64(1.1.inNano))
            }
        }
    }
    
    public func stopScan() {
        isScanning = false
    }
    
    private var connectTask: Task<(), Never>?
    public func connect(_ peripheral: Peripheral, options: [String : Any]?) {
        guard let peripheral = peripheral as? SimulatedPeripheral else {
            fatalError("Only supporting simulated peripherals")
        }
        
        connectTask?.cancel()
        connectTask = Task {
            peripheral.setState(.connecting)
            try? await Task.sleep(nanoseconds: UInt64(0.1.inNano))
            peripheral.setState(.connected)
            
            switch delegate {
            case .simple(delegate: let simple): simple.delegate?.centralManager(self, didConnect: peripheral)
            case .restoring(delegate: let restoring): restoring.delegate?.centralManager(self, didConnect: peripheral)
            default: break
            }
        }
    }
    
    public func cancelPeripheralConnection(_ peripheral: Peripheral) {
        guard let peripheral = peripheral as? SimulatedPeripheral else {
            fatalError("Only supporting simulated peripherals")
        }
        
        connectTask?.cancel()
        connectTask = Task {
            peripheral.setState(.disconnecting)
            try? await Task.sleep(nanoseconds: UInt64(0.1.inNano))
            peripheral.setState(.disconnected)
            
            switch delegate {
            case .simple(delegate: let simple): simple.delegate?.centralManager(self, didDisconnectPeripheral: peripheral, error: nil)
            case .restoring(delegate: let restoring): restoring.delegate?.centralManager(self, didDisconnectPeripheral: peripheral, error: nil)
            default: break
            }
        }
    }
    
    // SIMULATION
    public var simulatedPeripherals: [SimulatedPeripheral] = [
        SimulatedPeripheral()]
}
