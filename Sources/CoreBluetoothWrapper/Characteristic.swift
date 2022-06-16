// Henrik Top Mygind, 06/06/2022

import CoreBluetooth

public protocol Characteristic {
    var uuid: CBUUID { get }
    
    var value: Data? { get }
    var properties: CBCharacteristicProperties { get }
    var isNotifying: Bool { get }
}
